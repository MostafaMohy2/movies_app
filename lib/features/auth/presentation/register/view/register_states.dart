import 'package:movies_app/core/network/resources.dart';

class RegisterState {
  final Resources<void> registerResource;
  final String selectedAvatarAsset;

  const RegisterState({
    this.registerResource = const Resources.initial(),
    this.selectedAvatarAsset = 'assets/images/Component 11 – 1.png',
  });

  RegisterState copyWith({
    Resources<void>? registerResource,
    String? selectedAvatarAsset,
  }) => RegisterState(
    registerResource: registerResource ?? this.registerResource,
    selectedAvatarAsset: selectedAvatarAsset ?? this.selectedAvatarAsset,
  );
}

sealed class RegisterAction {
  const RegisterAction();
}

class SelectAvatarAction extends RegisterAction {
  final String avatarAsset;

  const SelectAvatarAction({required this.avatarAsset});
}

class SubmitRegisterAction extends RegisterAction {
  final String name;
  final String email;
  final String password;
  final String phone;

  const SubmitRegisterAction({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class NavigateToLoginAction extends RegisterAction {
  const NavigateToLoginAction();
}

sealed class RegisterNavigationAction {
  const RegisterNavigationAction();
}

class NavigateToLoginScreen extends RegisterNavigationAction {
  const NavigateToLoginScreen();
}

class ShowRegisterErrorToast extends RegisterNavigationAction {
  final String errorMessage;

  const ShowRegisterErrorToast(this.errorMessage);
}
