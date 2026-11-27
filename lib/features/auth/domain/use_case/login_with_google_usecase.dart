import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import '../entities/auth_user_entity.dart';
import '../repository/auth_repository.dart';

@injectable
class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  const LoginWithGoogleUseCase(this._repository);

  // ignore: avoid_positional_boolean_parameters
  Future<ApiResult<AuthUserEntity>> call(void _) {
    return _repository.loginWithGoogle();
  }
}
