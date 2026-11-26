import 'package:movies_app/core/network/resources.dart';

class RegisterStates {
  final Resources<void> registerResource;

  const RegisterStates({this.registerResource = const Resources.initial()});

  RegisterStates copyWith({Resources<void>? registerResource}) =>
      RegisterStates(
        registerResource: registerResource ?? this.registerResource,
      );
}

sealed class RegisterAction {}

class NavigateToLoginAction extends RegisterAction {}

sealed class RegisterNavigationAction {}

class NavigateToLoginScreen extends RegisterNavigationAction {}

class NavigateToHomeScreen extends RegisterNavigationAction {}

class ShowRegisterErrorToast extends RegisterNavigationAction {
  final String errorMessage;
  ShowRegisterErrorToast(this.errorMessage);
}
