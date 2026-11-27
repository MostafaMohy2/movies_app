import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_cubit.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_states.dart';

class _MockLoginWithEmailUseCase extends Mock
    implements LoginWithEmailUseCase {}

class _MockLoginWithGoogleUseCase extends Mock
    implements LoginWithGoogleUseCase {}

void main() {
  late _MockLoginWithEmailUseCase mockEmailUseCase;
  late _MockLoginWithGoogleUseCase mockGoogleUseCase;
  late LoginCubit cubit;

  const tUser = AuthUserEntity(
    uid: 'u1',
    email: 'test@example.com',
    name: 'Test User',
    phone: '+201000000000',
    avatarAsset: 'assets/images/Component 11 – 1.png',
  );

  setUpAll(() {
    registerFallbackValue(const LoginWithEmailParams(email: '', password: ''));
  });

  setUp(() {
    mockEmailUseCase = _MockLoginWithEmailUseCase();
    mockGoogleUseCase = _MockLoginWithGoogleUseCase();
    cubit = LoginCubit(mockEmailUseCase, mockGoogleUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LoginCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.loginResource.isInitial, isTrue);
      expect(cubit.state.googleLoginResource.isInitial, isTrue);
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

    test('submitLoginAction_success_emitsSuccessAndNavigatesHome', () async {
      when(
        () => mockEmailUseCase(any()),
      ).thenAnswer((_) async => const Success(tUser));

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        const SubmitLoginAction(
          email: 'test@example.com',
          password: 'Password1!',
        ),
      );

      expect(cubit.state.loginResource.isSuccess, isTrue);
      expect(await navFuture, isA<NavigateToHomeScreen>());
    });

    test('submitLoginAction_failure_emitsErrorAndToast', () async {
      when(() => mockEmailUseCase(any())).thenAnswer(
        (_) async => const Failure(
          exception: JustMessage('Invalid credentials'),
          message: 'Invalid credentials',
        ),
      );

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        const SubmitLoginAction(email: 'test@example.com', password: 'wrong'),
      );

      expect(cubit.state.loginResource.isError, isTrue);
      final nav = await navFuture;
      expect(nav, isA<ShowLoginErrorToast>());
      expect((nav as ShowLoginErrorToast).errorMessage, 'Invalid credentials');
    });

    test(
      'loginWithGoogleAction_success_emitsSuccessAndNavigatesHome',
      () async {
        when(
          () => mockGoogleUseCase(null),
        ).thenAnswer((_) async => const Success(tUser));

        final navFuture = cubit.navigation.first;
        await cubit.doAction(LoginWithGoogleAction());

        expect(cubit.state.googleLoginResource.isSuccess, isTrue);
        expect(await navFuture, isA<NavigateToHomeScreen>());
      },
    );
  });
}
