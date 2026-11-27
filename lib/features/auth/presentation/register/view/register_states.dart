import 'package:movies_app/core/network/resources.dart';

class RegisterStates {
  final Resources<void> registerResource;
  final String selectedAvatarAsset;

  const RegisterStates({
    this.registerResource = const Resources.initial(),
    this.selectedAvatarAsset = 'assets/images/Component 11 – 1.png',
  });

  RegisterStates copyWith({
    Resources<void>? registerResource,
    String? selectedAvatarAsset,
  }) {
    return RegisterStates(
      registerResource: registerResource ?? this.registerResource,
      selectedAvatarAsset: selectedAvatarAsset ?? this.selectedAvatarAsset,
    );
  }
}

sealed class RegisterAction {}

class SubmitRegisterAction extends RegisterAction {
  final String name;
  final String email;
  final String password;
  final String phone;

  SubmitRegisterAction({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class SelectAvatarAction extends RegisterAction {
  final String avatarAsset;

  SelectAvatarAction({required this.avatarAsset});
}

class NavigateToLoginAction extends RegisterAction {}

sealed class RegisterNavigationAction {}

class NavigateToLoginScreen extends RegisterNavigationAction {}

class NavigateToHomeScreen extends RegisterNavigationAction {}

class ShowRegisterErrorToast extends RegisterNavigationAction {
  final String errorMessage;
  ShowRegisterErrorToast(this.errorMessage);
}
