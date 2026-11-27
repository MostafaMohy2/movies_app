import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import '../repository/auth_repository.dart';

@injectable
class SendPasswordResetUseCase {
  final AuthRepository _repository;

  const SendPasswordResetUseCase(this._repository);

  Future<ApiResult<void>> call(String email) {
    return _repository.sendPasswordResetEmail(email: email);
  }
}
