import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_result.dart';
import 'errors.dart';

class ErrorParser {
  static Failure<T> parse<T extends Object?>(Object error) {
    if (error is DioException) {
      return _parseDioException<T>(error);
    } else if (error is FirebaseAuthException) {
      return _parseFirebaseAuthException<T>(error);
    } else if (error is GoogleSignInException) {
      return _parseGoogleSignInException<T>(error);
    } else if (error is SocketException) {
      return Failure<T>(
        exception: const NetworkError(message: 'No internet connection'),
        message: 'No internet connection',
      );
    } else if (error is TimeoutException) {
      return Failure<T>(
        exception: const TimeoutError(message: 'Request timed out'),
        message: 'Request timed out',
      );
    } else if (error is FormatException) {
      return Failure<T>(
        exception: ParseError(message: 'Data parsing error', cause: error),
        message: 'Data parsing error',
      );
    }

    return Failure<T>(
      exception: Unknown(cause: error),
      message: error.toString(),
    );
  }

  static Failure<T> _parseFirebaseAuthException<T extends Object?>(
    FirebaseAuthException error,
  ) {
    final String message = _firebaseAuthMessage(error);
    switch (error.code) {
      case 'network-request-failed':
        return Failure<T>(
          exception: NetworkError(message: message),
          message: message,
        );
      case 'too-many-requests':
        return Failure<T>(
          exception: TimeoutError(message: message),
          message: message,
        );
      case 'user-disabled':
      case 'requires-recent-login':
        return Failure<T>(
          exception: LoginRequired(message: message),
          message: message,
        );
      default:
        return Failure<T>(exception: JustMessage(message), message: message);
    }
  }

  static String _firebaseAuthMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  static Failure<T> _parseGoogleSignInException<T extends Object?>(
    GoogleSignInException error,
  ) {
    final String message = error.code == GoogleSignInExceptionCode.canceled
        ? 'Google sign-in was cancelled.'
        : (error.description ?? 'Google sign-in failed.');
    return Failure<T>(exception: JustMessage(message), message: message);
  }

  static Failure<T> _parseDioException<T extends Object?>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure<T>(
          exception: const TimeoutError(message: 'Connection timed out'),
          message: 'Connection timed out',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final responseData = error.response?.data;
        String message = 'Server error occurred';

        if (responseData is Map<String, dynamic>) {
          message =
              responseData['status_message']?.toString() ??
              responseData['message']?.toString() ??
              message;
        }

        if (statusCode == 401 || statusCode == 403) {
          return Failure<T>(
            exception: LoginRequired(message: message),
            message: message,
          );
        }

        return Failure<T>(
          exception: ServerError(statusCode: statusCode, message: message),
          message: message,
        );
      case DioExceptionType.connectionError:
        return Failure<T>(
          exception: const NetworkError(message: 'No internet connection'),
          message: 'No internet connection',
        );
      default:
        return Failure<T>(
          exception: Unknown(cause: error),
          message: error.message ?? 'Unexpected error occurred',
        );
    }
  }
}
