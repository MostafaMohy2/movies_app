import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';
import 'package:movies_app/features/auth/domain/use_cases/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_cases/login_with_google_usecase.dart';
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
    test('initial state has initial resources', () {
      expect(cubit.state.loginResource.isInitial, isTrue);
      expect(cubit.state.googleLoginResource.isInitial, isTrue);
      expect(cubit.state.isAnyLoading, isFalse);
    });

    test('navigateToRegisterAction emits NavigateToRegisterScreen', () async {
      final navFuture = cubit.navigation.first;
      await cubit.doAction(const NavigateToRegisterAction());
      expect(await navFuture, isA<NavigateToRegisterScreen>());
    });

    test(
      'navigateToForgotPasswordAction emits NavigateToForgotPasswordScreen',
      () async {
        final navFuture = cubit.navigation.first;
        await cubit.doAction(const NavigateToForgotPasswordAction());
        expect(await navFuture, isA<NavigateToForgotPasswordScreen>());
      },
    );

    blocTest<LoginCubit, LoginState>(
      'submitLoginAction emits loading then success on Success result',
      build: () {
        when(
          () => mockEmailUseCase(any()),
        ).thenAnswer((_) async => const Success(tUser));
        return cubit;
      },
      act: (c) => c.doAction(
        const SubmitLoginAction(
          email: 'test@example.com',
          password: 'Password1!',
        ),
      ),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginResource.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<LoginState>().having(
          (s) => s.loginResource.isSuccess,
          'isSuccess',
          isTrue,
        ),
      ],
    );

    test(
      'submitLoginAction failure emits error resource and ShowLoginErrorToast',
      () async {
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
        expect(cubit.state.loginResource.message, 'Invalid credentials');
        final nav = await navFuture;
        expect(nav, isA<ShowLoginErrorToast>());
        expect(
          (nav as ShowLoginErrorToast).errorMessage,
          'Invalid credentials',
        );
      },
    );

    blocTest<LoginCubit, LoginState>(
      'loginWithGoogleAction emits loading then success on Success result',
      build: () {
        when(
          () => mockGoogleUseCase(null),
        ).thenAnswer((_) async => const Success(tUser));
        return cubit;
      },
      act: (c) => c.doAction(const LoginWithGoogleAction()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.googleLoginResource.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<LoginState>().having(
          (s) => s.googleLoginResource.isSuccess,
          'isSuccess',
          isTrue,
        ),
      ],
    );

    test('submitLoginAction is ignored when already loading', () async {
      when(() => mockEmailUseCase(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return const Success(tUser);
      });

      final first = cubit.doAction(
        const SubmitLoginAction(
          email: 'test@example.com',
          password: 'Password1!',
        ),
      );
      await cubit.doAction(
        const SubmitLoginAction(
          email: 'test@example.com',
          password: 'Password1!',
        ),
      );
      await first;

      verify(() => mockEmailUseCase(any())).called(1);
    });
  });
}
