import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_email_usecase.dart';
import 'package:movies_app/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_cubit.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_states.dart';

class _MockLoginWithEmailUseCase extends Mock
    implements LoginWithEmailUseCase {}

class _MockLoginWithGoogleUseCase extends Mock
    implements LoginWithGoogleUseCase {}

void main() {
  late LoginCubit cubit;
  late _MockLoginWithEmailUseCase mockEmailUseCase;
  late _MockLoginWithGoogleUseCase mockGoogleUseCase;

  setUpAll(() {
    registerFallbackValue(const LoginWithEmailParams(email: '', password: ''));
  });

  setUp(() {
    mockEmailUseCase = _MockLoginWithEmailUseCase();
    mockGoogleUseCase = _MockLoginWithGoogleUseCase();
    cubit = LoginCubit(mockEmailUseCase, mockGoogleUseCase);
  });

  tearDown(() async => cubit.close());

  group('LoginCubit', () {
    test('initial state has initial resources', () {
      expect(cubit.state.loginResource.isInitial, isTrue);
      expect(cubit.state.googleLoginResource.isInitial, isTrue);
      expect(cubit.state.isAnyLoading, isFalse);
    });

    blocTest<LoginCubit, LoginState>(
      'loginWithEmail emits loading then success on Success result',
      build: () {
        when(
          () => mockEmailUseCase(any()),
        ).thenAnswer((_) async => const Success(null));
        return LoginCubit(mockEmailUseCase, mockGoogleUseCase);
      },
      act: (c) => c.loginWithEmail('a@b.com', 'Password1!'),
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

    blocTest<LoginCubit, LoginState>(
      'loginWithEmail emits loading then error on Failure result',
      build: () {
        when(() => mockEmailUseCase(any())).thenAnswer(
          (_) async => const Failure(message: 'Invalid credentials'),
        );
        return LoginCubit(mockEmailUseCase, mockGoogleUseCase);
      },
      act: (c) => c.loginWithEmail('a@b.com', 'wrongpass'),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginResource.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<LoginState>()
            .having((s) => s.loginResource.isError, 'isError', isTrue)
            .having(
              (s) => s.loginResource.message,
              'message',
              'Invalid credentials',
            ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'loginWithGoogle emits loading then success on Success result',
      build: () {
        when(
          () => mockGoogleUseCase(any()),
        ).thenAnswer((_) async => const Success(null));
        return LoginCubit(mockEmailUseCase, mockGoogleUseCase);
      },
      act: (c) => c.loginWithGoogle(),
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

    test('loginWithEmail is ignored when already loading', () async {
      when(() => mockEmailUseCase(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return const Success(null);
      });
      // Start first call (puts state into loading)
      final firstCall = cubit.loginWithEmail('a@b.com', 'Password1!');
      // Second call should be a no-op
      await cubit.loginWithEmail('a@b.com', 'Password1!');
      await firstCall;
      verify(() => mockEmailUseCase(any())).called(1);
    });
  });
}
