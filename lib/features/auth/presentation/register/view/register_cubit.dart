import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'register_states.dart';

@injectable
class RegisterCubit
    extends
        BaseCubit<RegisterStates, RegisterAction, RegisterNavigationAction> {
  RegisterCubit() : super(const RegisterStates());

  @override
  Future<void> doAction(RegisterAction action) async {
    switch (action) {
      case NavigateToLoginAction():
        emitNavigation(NavigateToLoginScreen());
    }
  }
}
