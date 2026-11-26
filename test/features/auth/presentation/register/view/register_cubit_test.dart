import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_cubit.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_states.dart';

void main() {
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('RegisterCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.registerResource.isInitial, isTrue);
    });

    test('navigateToLoginAction_emitsNavigateToLoginScreen', () async {
      final Future<RegisterNavigationAction> navFuture = cubit.navigation.first;
      await cubit.doAction(NavigateToLoginAction());
      expect(await navFuture, isA<NavigateToLoginScreen>());
    });
  });
}
