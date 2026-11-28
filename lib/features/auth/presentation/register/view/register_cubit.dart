import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_cases/register_user_usecase.dart';
import 'register_states.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUserUseCase _registerUserUseCase;

  RegisterCubit(this._registerUserUseCase) : super(const RegisterState());

  void selectAvatar(String assetPath) {
    emit(state.copyWith(selectedAvatarAsset: assetPath));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (state.registerResource.isLoading) return;
    emit(state.copyWith(registerResource: const Resources.loading()));
    final result = await _registerUserUseCase(
      RegisterUserParams(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatarAsset: state.selectedAvatarAsset,
      ),
    );
    switch (result) {
      case Success<dynamic>():
        emit(state.copyWith(registerResource: const Resources.success()));
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            registerResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
    }
  }
}
