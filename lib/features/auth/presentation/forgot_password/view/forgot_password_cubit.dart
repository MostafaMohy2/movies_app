import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_cases/send_password_reset_usecase.dart';
import 'forgot_password_states.dart';

@injectable
class ForgotPasswordCubit
    extends
        BaseCubit<
          ForgotPasswordState,
          ForgotPasswordAction,
          ForgotPasswordNavigationAction
        > {
  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  ForgotPasswordCubit(this._sendPasswordResetUseCase)
    : super(const ForgotPasswordState());

  @override
  Future<void> doAction(ForgotPasswordAction action) async {
    switch (action) {
      case SubmitForgotPasswordAction(:final email):
        await _sendReset(email);
      case NavigateBackToLoginAction():
        emitNavigation(const NavigateBackToLoginScreen());
    }
  }

  Future<void> _sendReset(String email) async {
    if (state.resetResource.isLoading) return;
    emit(state.copyWith(resetResource: const Resources.loading()));
    final result = await _sendPasswordResetUseCase(email);
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(resetResource: const Resources.success()));
        emitNavigation(const ShowResetSuccessToast());
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            resetResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowForgotPasswordErrorToast(message));
    }
  }
}
