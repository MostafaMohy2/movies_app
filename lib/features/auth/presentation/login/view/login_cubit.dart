import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_cases/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_cases/login_with_google_usecase.dart';
import 'login_states.dart';

@injectable
class LoginCubit
    extends BaseCubit<LoginState, LoginAction, LoginNavigationAction> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  LoginCubit(this._loginWithEmailUseCase, this._loginWithGoogleUseCase)
    : super(const LoginState());

  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case SubmitLoginAction(:final email, :final password):
        await _loginWithEmail(email, password);
      case LoginWithGoogleAction():
        await _loginWithGoogle();
      case NavigateToRegisterAction():
        emitNavigation(const NavigateToRegisterScreen());
      case NavigateToForgotPasswordAction():
        emitNavigation(const NavigateToForgotPasswordScreen());
    }
  }

  Future<void> _loginWithEmail(String email, String password) async {
    if (state.isAnyLoading) return;
    emit(state.copyWith(loginResource: const Resources.loading()));
    final result = await _loginWithEmailUseCase(
      LoginWithEmailParams(email: email, password: password),
    );
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(loginResource: const Resources.success()));
        emitNavigation(const NavigateToHomeScreen());
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            loginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowLoginErrorToast(message));
    }
  }

  Future<void> _loginWithGoogle() async {
    if (state.isAnyLoading) return;
    emit(state.copyWith(googleLoginResource: const Resources.loading()));
    final result = await _loginWithGoogleUseCase(null);
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(googleLoginResource: const Resources.success()));
        emitNavigation(const NavigateToHomeScreen());
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            googleLoginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowLoginErrorToast(message));
    }
  }
}
