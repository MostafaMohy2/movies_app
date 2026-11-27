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
