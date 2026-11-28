import 'package:movies_app/core/network/resources.dart';

class LoginState {
  final Resources<void> loginResource;
  final Resources<void> googleLoginResource;

  const LoginState({
    this.loginResource = const Resources.initial(),
    this.googleLoginResource = const Resources.initial(),
  });

  LoginState copyWith({
    Resources<void>? loginResource,
    Resources<void>? googleLoginResource,
  }) => LoginState(
    loginResource: loginResource ?? this.loginResource,
    googleLoginResource: googleLoginResource ?? this.googleLoginResource,
  );

  bool get isAnyLoading =>
      loginResource.isLoading || googleLoginResource.isLoading;
}

sealed class LoginAction {
  const LoginAction();
}

class SubmitLoginAction extends LoginAction {
  final String email;
  final String password;

  const SubmitLoginAction({required this.email, required this.password});
}

class LoginWithGoogleAction extends LoginAction {
  const LoginWithGoogleAction();
}

class NavigateToRegisterAction extends LoginAction {
  const NavigateToRegisterAction();
}

class NavigateToForgotPasswordAction extends LoginAction {
  const NavigateToForgotPasswordAction();
}

sealed class LoginNavigationAction {
  const LoginNavigationAction();
}

class NavigateToHomeScreen extends LoginNavigationAction {
  const NavigateToHomeScreen();
}

class NavigateToRegisterScreen extends LoginNavigationAction {
  const NavigateToRegisterScreen();
}

class NavigateToForgotPasswordScreen extends LoginNavigationAction {
  const NavigateToForgotPasswordScreen();
}

class ShowLoginErrorToast extends LoginNavigationAction {
  final String errorMessage;

  const ShowLoginErrorToast(this.errorMessage);
}
