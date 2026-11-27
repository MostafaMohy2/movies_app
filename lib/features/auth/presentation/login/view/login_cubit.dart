import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'login_states.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  LoginCubit(this._loginWithEmailUseCase, this._loginWithGoogleUseCase)
    : super(const LoginState());

  Future<void> loginWithEmail(String email, String password) async {
    if (state.isAnyLoading) return;
    emit(state.copyWith(loginResource: const Resources.loading()));
    final result = await _loginWithEmailUseCase(
      LoginWithEmailParams(email: email, password: password),
    );
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(loginResource: const Resources.success()));
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            loginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.isAnyLoading) return;
    emit(state.copyWith(googleLoginResource: const Resources.loading()));
    final result = await _loginWithGoogleUseCase(null);
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(googleLoginResource: const Resources.success()));
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            googleLoginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
    }
  }
}
