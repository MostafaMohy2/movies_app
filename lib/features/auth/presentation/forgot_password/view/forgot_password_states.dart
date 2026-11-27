import 'package:movies_app/core/network/resources.dart';

class ForgotPasswordState {
  final Resources<void> resetResource;

  const ForgotPasswordState({this.resetResource = const Resources.initial()});

  ForgotPasswordState copyWith({Resources<void>? resetResource}) =>
      ForgotPasswordState(resetResource: resetResource ?? this.resetResource);
}
