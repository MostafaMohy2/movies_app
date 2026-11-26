import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_cubit.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_states.dart';

void main() {
  late LoginCubit cubit;

  setUp(() {
    cubit = LoginCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LoginCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.loginResource.isInitial, isTrue);
    });

    test('navigateToRegisterAction_emitsNavigateToRegisterScreen', () async {
      final Future<LoginNavigationAction> navFuture = cubit.navigation.first;
      await cubit.doAction(NavigateToRegisterAction());
      expect(await navFuture, isA<NavigateToRegisterScreen>());
    });

    test(
      'navigateToForgotPasswordAction_emitsNavigateToForgotPasswordScreen',
      () async {
        final Future<LoginNavigationAction> navFuture = cubit.navigation.first;
        await cubit.doAction(NavigateToForgotPasswordAction());
        expect(await navFuture, isA<NavigateToForgotPasswordScreen>());
      },
    );
  });
}
