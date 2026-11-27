import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/use_case/send_password_reset_usecase.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_cubit.dart';

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

    test('sendReset_success_emitsSuccessResource', () async {
      when(
        () => mockResetUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      await cubit.sendReset('test@example.com');

      expect(cubit.state.resetResource.isSuccess, isTrue);
    });

    test('sendReset_failure_emitsErrorResourceWithMessage', () async {
      when(() => mockResetUseCase(any())).thenAnswer(
        (_) async => const Failure(
          exception: JustMessage('User not found'),
          message: 'User not found',
        ),
      );

      await cubit.sendReset('missing@example.com');

      expect(cubit.state.resetResource.isError, isTrue);
      expect(cubit.state.resetResource.message, 'User not found');
    });
  });
}
