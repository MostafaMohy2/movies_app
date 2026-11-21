import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api_result.dart';
import 'errors.dart';

class ErrorParser {
  static Failure<T> parse<T extends Object?>(Object error) {
    if (error is DioException) {
      return _parseDioException<T>(error);
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
