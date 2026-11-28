import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_cases/register_user_usecase.dart';
import 'register_states.dart';

@injectable
class RegisterCubit
    extends BaseCubit<RegisterState, RegisterAction, RegisterNavigationAction> {
  final RegisterUserUseCase _registerUserUseCase;

  RegisterCubit(this._registerUserUseCase) : super(const RegisterState());

  @override
  Future<void> doAction(RegisterAction action) async {
    switch (action) {
      case SelectAvatarAction(:final avatarAsset):
        emit(state.copyWith(selectedAvatarAsset: avatarAsset));
      case SubmitRegisterAction(
        :final name,
        :final email,
        :final password,
        :final phone,
      ):
        await _register(
          name: name,
          email: email,
          password: password,
          phone: phone,
        );
      case NavigateToLoginAction():
        emitNavigation(const NavigateToLoginScreen());
    }
  }

  Future<void> _register({
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
        emitNavigation(const NavigateToLoginScreen());
      case Failure<dynamic>(:final exception, :final message):
        emit(
          state.copyWith(
            registerResource: Resources.failure(
              exception: exception,
              message: message,
            ),
          ),
        );
        emitNavigation(ShowRegisterErrorToast(message));
    }
  }
}
