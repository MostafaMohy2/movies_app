import 'package:movies_app/core/network/resources.dart';

class LoginStates {
  final Resources<void> loginResource;

  const LoginStates({this.loginResource = const Resources.initial()});

  LoginStates copyWith({Resources<void>? loginResource}) =>
      LoginStates(loginResource: loginResource ?? this.loginResource);
}

sealed class LoginAction {}

class NavigateToRegisterAction extends LoginAction {}

class NavigateToForgotPasswordAction extends LoginAction {}

sealed class LoginNavigationAction {}

class NavigateToRegisterScreen extends LoginNavigationAction {}

class NavigateToForgotPasswordScreen extends LoginNavigationAction {}

class NavigateToHomeScreen extends LoginNavigationAction {}

class ShowLoginErrorToast extends LoginNavigationAction {
  final String errorMessage;
  ShowLoginErrorToast(this.errorMessage);
}
