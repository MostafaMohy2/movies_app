import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import '../entities/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class RegisterUserParams {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String avatarAsset;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.avatarAsset,
  });
}

@injectable
class RegisterUserUseCase {
  final AuthRepository _repository;

  const RegisterUserUseCase(this._repository);

  Future<ApiResult<AuthUserEntity>> call(RegisterUserParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      avatarAsset: params.avatarAsset,
    );
  }
}
