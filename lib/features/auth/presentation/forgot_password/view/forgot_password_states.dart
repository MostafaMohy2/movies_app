import 'package:movies_app/core/network/resources.dart';

class ForgotPasswordState {
  final Resources<void> resetResource;

  const ForgotPasswordState({this.resetResource = const Resources.initial()});

  ForgotPasswordState copyWith({Resources<void>? resetResource}) =>
      ForgotPasswordState(resetResource: resetResource ?? this.resetResource);
}

sealed class ForgotPasswordAction {
  const ForgotPasswordAction();
}

class SubmitForgotPasswordAction extends ForgotPasswordAction {
  final String email;

  const SubmitForgotPasswordAction({required this.email});
}

class NavigateBackToLoginAction extends ForgotPasswordAction {
  const NavigateBackToLoginAction();
}

sealed class ForgotPasswordNavigationAction {
  const ForgotPasswordNavigationAction();
}

class NavigateBackToLoginScreen extends ForgotPasswordNavigationAction {
  const NavigateBackToLoginScreen();
}

class ShowResetSuccessToast extends ForgotPasswordNavigationAction {
  const ShowResetSuccessToast();
}

class ShowForgotPasswordErrorToast extends ForgotPasswordNavigationAction {
  final String errorMessage;

  const ShowForgotPasswordErrorToast(this.errorMessage);
}
