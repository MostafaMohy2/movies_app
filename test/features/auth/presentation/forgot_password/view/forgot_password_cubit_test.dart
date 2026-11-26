import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_states.dart';

void main() {
  late ForgotPasswordCubit cubit;

  setUp(() {
    cubit = ForgotPasswordCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ForgotPasswordCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.resetResource.isInitial, isTrue);
    });

    test('navigateBackToLoginAction_emitsNavigateBackToLoginScreen', () async {
      final Future<ForgotPasswordNavigationAction> navFuture =
          cubit.navigation.first;
      await cubit.doAction(NavigateBackToLoginAction());
      expect(await navFuture, isA<NavigateBackToLoginScreen>());
    });
  });
}
