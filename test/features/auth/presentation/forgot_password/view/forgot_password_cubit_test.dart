import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/use_cases/send_password_reset_usecase.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_states.dart';

class _MockSendPasswordResetUseCase extends Mock
    implements SendPasswordResetUseCase {}

void main() {
  late _MockSendPasswordResetUseCase mockResetUseCase;
  late ForgotPasswordCubit cubit;

  setUp(() {
    mockResetUseCase = _MockSendPasswordResetUseCase();
    cubit = ForgotPasswordCubit(mockResetUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ForgotPasswordCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.resetResource.isInitial, isTrue);
    });

    test('navigateBackToLoginAction_emitsNavigateBackToLoginScreen', () async {
      final navFuture = cubit.navigation.first;
      await cubit.doAction(const NavigateBackToLoginAction());
      expect(await navFuture, isA<NavigateBackToLoginScreen>());
    });

    test('submitForgotPasswordAction_success_emitsSuccessToast', () async {
      when(
        () => mockResetUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        const SubmitForgotPasswordAction(email: 'test@example.com'),
      );

      expect(cubit.state.resetResource.isSuccess, isTrue);
      expect(await navFuture, isA<ShowResetSuccessToast>());
    });

    test('submitForgotPasswordAction_failure_emitsErrorToast', () async {
      when(() => mockResetUseCase(any())).thenAnswer(
        (_) async => const Failure(
          exception: JustMessage('User not found'),
          message: 'User not found',
        ),
      );

      final navFuture = cubit.navigation.first;
      await cubit.doAction(
        const SubmitForgotPasswordAction(email: 'missing@example.com'),
      );

      expect(cubit.state.resetResource.isError, isTrue);
      final nav = await navFuture;
      expect(nav, isA<ShowForgotPasswordErrorToast>());
      expect(
        (nav as ShowForgotPasswordErrorToast).errorMessage,
        'User not found',
      );
    });
  });
}
