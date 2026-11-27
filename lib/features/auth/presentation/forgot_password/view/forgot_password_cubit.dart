import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_case/send_password_reset_usecase.dart';
import 'forgot_password_states.dart';

@injectable
class ForgotPasswordCubit
    extends
        BaseCubit<
          ForgotPasswordStates,
          ForgotPasswordAction,
          ForgotPasswordNavigationAction
        > {
  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  ForgotPasswordCubit(this._sendPasswordResetUseCase)
    : super(const ForgotPasswordStates());

  @override
  Future<void> doAction(ForgotPasswordAction action) async {
    switch (action) {
      case SubmitForgotPasswordAction(:final email):
        await _submitReset(email);
      case NavigateBackToLoginAction():
        emitNavigation(NavigateBackToLoginScreen());
    }
  }

  Future<void> _submitReset(String email) async {
    emit(state.copyWith(resetResource: const Resources.loading()));
    final result = await _sendPasswordResetUseCase(email);
    switch (result) {
      case Success():
        emit(state.copyWith(resetResource: const Resources.success()));
        emitNavigation(ShowResetSuccessToast());
      case Failure(:final exception, :final message):
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
