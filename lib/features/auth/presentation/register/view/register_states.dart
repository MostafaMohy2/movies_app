import 'package:movies_app/core/network/resources.dart';

class RegisterState {
  final Resources<void> registerResource;
  final String selectedAvatarAsset;

  const RegisterState({
    this.registerResource = const Resources.initial(),
    this.selectedAvatarAsset = 'assets/images/Component 11 \u2013 1.png',
  });

  RegisterState copyWith({
    Resources<void>? registerResource,
    String? selectedAvatarAsset,
  }) => RegisterState(
    registerResource: registerResource ?? this.registerResource,
    selectedAvatarAsset: selectedAvatarAsset ?? this.selectedAvatarAsset,
  );
}
