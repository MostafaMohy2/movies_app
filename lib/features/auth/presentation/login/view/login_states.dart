import 'package:movies_app/core/network/resources.dart';

class LoginStates {
  final Resources<void> loginResource;
  final Resources<void> googleLoginResource;

  const LoginStates({
    this.loginResource = const Resources.initial(),
    this.googleLoginResource = const Resources.initial(),
  });

  LoginStates copyWith({
    Resources<void>? loginResource,
    Resources<void>? googleLoginResource,
  }) {
    return LoginStates(
      loginResource: loginResource ?? this.loginResource,
      googleLoginResource: googleLoginResource ?? this.googleLoginResource,
    );
  }
}

sealed class LoginAction {
  const LoginAction();
}

class SubmitLoginAction extends LoginAction {
  final String email;
  final String password;

  const SubmitLoginAction({required this.email, required this.password});
}

class LoginWithGoogleAction extends LoginAction {}

class NavigateToRegisterAction extends LoginAction {}

class NavigateToForgotPasswordAction extends LoginAction {}

sealed class LoginNavigationAction {
  const LoginNavigationAction();
}

class NavigateToRegisterScreen extends LoginNavigationAction {}

class NavigateToForgotPasswordScreen extends LoginNavigationAction {}

class NavigateToHomeScreen extends LoginNavigationAction {}

class ShowLoginErrorToast extends LoginNavigationAction {
  final String errorMessage;

  const ShowLoginErrorToast({required this.errorMessage});
}
