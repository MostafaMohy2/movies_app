import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'login_states.dart';

@injectable
class LoginCubit
    extends BaseCubit<LoginStates, LoginAction, LoginNavigationAction> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  LoginCubit(this._loginWithEmailUseCase, this._loginWithGoogleUseCase)
    : super(const LoginStates());

  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case SubmitLoginAction():
        await _submitLogin(action.email, action.password);
      case LoginWithGoogleAction():
        await _loginWithGoogle();
      case NavigateToRegisterAction():
        emitNavigation(NavigateToRegisterScreen());
      case NavigateToForgotPasswordAction():
        emitNavigation(NavigateToForgotPasswordScreen());
    }
  }

  Future<void> _submitLogin(String email, String password) async {
    emit(state.copyWith(loginResource: const Resources.loading()));
    final result = await _loginWithEmailUseCase(
      LoginWithEmailParams(email: email, password: password),
    );
    switch (result) {
      case Success():
        emit(state.copyWith(loginResource: const Resources.success()));
        emitNavigation(NavigateToHomeScreen());
      case Failure(:final exception, :final message):
        emit(
          state.copyWith(
            loginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowLoginErrorToast(errorMessage: message));
    }
  }

  Future<void> _loginWithGoogle() async {
    emit(state.copyWith(googleLoginResource: const Resources.loading()));
    final result = await _loginWithGoogleUseCase(null);
    switch (result) {
      case Success():
        emit(state.copyWith(googleLoginResource: const Resources.success()));
        emitNavigation(NavigateToHomeScreen());
      case Failure(:final exception, :final message):
        emit(
          state.copyWith(
            googleLoginResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowLoginErrorToast(errorMessage: message));
    }
  }
}
