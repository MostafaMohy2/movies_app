import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'login_states.dart';

@injectable
class LoginCubit
    extends BaseCubit<LoginStates, LoginAction, LoginNavigationAction> {
  LoginCubit() : super(const LoginStates());

  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case NavigateToRegisterAction():
        emitNavigation(NavigateToRegisterScreen());
      case NavigateToForgotPasswordAction():
        emitNavigation(NavigateToForgotPasswordScreen());
    }
  }
}
