import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_cases/send_password_reset_usecase.dart';
import 'forgot_password_states.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  ForgotPasswordCubit(this._sendPasswordResetUseCase)
    : super(const ForgotPasswordState());

  Future<void> sendReset(String email) async {
    if (state.resetResource.isLoading) return;
    emit(state.copyWith(resetResource: const Resources.loading()));
    final result = await _sendPasswordResetUseCase(email);
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(resetResource: const Resources.success()));
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            resetResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
    }
  }
}
