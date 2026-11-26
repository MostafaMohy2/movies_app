import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'forgot_password_states.dart';

@injectable
class ForgotPasswordCubit
    extends
        BaseCubit<
          ForgotPasswordStates,
          ForgotPasswordAction,
          ForgotPasswordNavigationAction
        > {
  ForgotPasswordCubit() : super(const ForgotPasswordStates());

  @override
  Future<void> doAction(ForgotPasswordAction action) async {
    switch (action) {
      case NavigateBackToLoginAction():
        emitNavigation(NavigateBackToLoginScreen());
    }
  }
}
