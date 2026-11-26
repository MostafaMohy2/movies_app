import 'package:movies_app/core/network/resources.dart';

class ForgotPasswordStates {
  final Resources<void> resetResource;

  const ForgotPasswordStates({this.resetResource = const Resources.initial()});

  ForgotPasswordStates copyWith({Resources<void>? resetResource}) =>
      ForgotPasswordStates(resetResource: resetResource ?? this.resetResource);
}

sealed class ForgotPasswordAction {}

class NavigateBackToLoginAction extends ForgotPasswordAction {}

sealed class ForgotPasswordNavigationAction {}

class NavigateBackToLoginScreen extends ForgotPasswordNavigationAction {}

class ShowForgotPasswordErrorToast extends ForgotPasswordNavigationAction {
  final String errorMessage;
  ShowForgotPasswordErrorToast(this.errorMessage);
}
