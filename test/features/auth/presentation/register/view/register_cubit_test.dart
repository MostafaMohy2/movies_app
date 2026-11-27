import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';
import 'package:movies_app/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_cubit.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_states.dart';

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  late _MockRegisterUserUseCase mockRegisterUseCase;
  late RegisterCubit cubit;

  const tUser = AuthUserEntity(
    uid: 'u1',
    email: 'test@example.com',
    name: 'Test User',
    phone: '+201000000000',
    avatarAsset: 'assets/images/Component 11 – 1.png',
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(
        name: '',
        email: '',
        password: '',
        phone: '',
        avatarAsset: '',
      ),
    );
  });

  setUp(() {
    mockRegisterUseCase = _MockRegisterUserUseCase();
    cubit = RegisterCubit(mockRegisterUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('RegisterCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.registerResource.isInitial, isTrue);
    });

    test('selectAvatarAction_updatesSelectedAvatarAsset', () async {
      const nextAvatar = 'assets/images/Component 11 – 2.png';
      await cubit.doAction(SelectAvatarAction(avatarAsset: nextAvatar));
      expect(cubit.state.selectedAvatarAsset, nextAvatar);
    });

    test('navigateToLoginAction_emitsNavigateToLoginScreen', () async {
      final Future<RegisterNavigationAction> navFuture = cubit.navigation.first;
      await cubit.doAction(NavigateToLoginAction());
      expect(await navFuture, isA<NavigateToLoginScreen>());
    });

    test('submitRegisterAction_success_emitsSuccessAndNavigatesHome', () async {
      when(
        () => mockRegisterUseCase(any()),
      ).thenAnswer((_) async => const Success(tUser));

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        SubmitRegisterAction(
          name: 'Test User',
          email: 'test@example.com',
          password: 'Password1!',
          phone: '+201000000000',
        ),
      );

      expect(cubit.state.registerResource.isSuccess, isTrue);
      expect(await navFuture, isA<NavigateToHomeScreen>());
    });

    test('submitRegisterAction_failure_emitsErrorAndToast', () async {
      when(() => mockRegisterUseCase(any())).thenAnswer(
        (_) async => const Failure(
          exception: JustMessage('Email already in use'),
          message: 'Email already in use',
        ),
      );

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        SubmitRegisterAction(
          name: 'Test User',
          email: 'test@example.com',
          password: 'Password1!',
          phone: '+201000000000',
        ),
      );

      expect(cubit.state.registerResource.isError, isTrue);
      final nav = await navFuture;
      expect(nav, isA<ShowRegisterErrorToast>());
      expect(
        (nav as ShowRegisterErrorToast).errorMessage,
        'Email already in use',
      );
    });
  });
}
