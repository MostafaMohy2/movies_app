import 'package:injectable/injectable.dart';
import 'package:movies_app/core/base/base_cubit.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/resources.dart';
import 'package:movies_app/features/auth/domain/use_case/register_user_usecase.dart';
import 'register_states.dart';

@injectable
class RegisterCubit
    extends
        BaseCubit<RegisterStates, RegisterAction, RegisterNavigationAction> {
  final RegisterUserUseCase _registerUserUseCase;

  RegisterCubit(this._registerUserUseCase) : super(const RegisterStates());

  @override
  Future<void> doAction(RegisterAction action) async {
    switch (action) {
      case SubmitRegisterAction():
        await _submitRegister(action);
      case SelectAvatarAction(:final avatarAsset):
        emit(state.copyWith(selectedAvatarAsset: avatarAsset));
      case NavigateToLoginAction():
        emitNavigation(NavigateToLoginScreen());
    }
  }

  Future<void> _submitRegister(SubmitRegisterAction action) async {
    emit(state.copyWith(registerResource: const Resources.loading()));
    final result = await _registerUserUseCase(
      RegisterUserParams(
        name: action.name,
        email: action.email,
        password: action.password,
        phone: action.phone,
        avatarAsset: state.selectedAvatarAsset,
      ),
    );
    switch (result) {
      case Success():
        emit(state.copyWith(registerResource: const Resources.success()));
        emitNavigation(NavigateToHomeScreen());
      case Failure(:final exception, :final message):
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
