import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import '../entities/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class LoginWithEmailParams {
  final String email;
  final String password;

  const LoginWithEmailParams({required this.email, required this.password});
}

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;

  const LoginWithEmailUseCase(this._repository);

  Future<ApiResult<AuthUserEntity>> call(LoginWithEmailParams params) {
    return _repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
