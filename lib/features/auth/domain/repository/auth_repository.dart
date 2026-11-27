import 'package:movies_app/core/network/api_result.dart';
import '../entities/auth_user_entity.dart';

abstract interface class AuthRepository {
  Future<ApiResult<AuthUserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthUserEntity>> loginWithGoogle();

  Future<ApiResult<AuthUserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatarAsset,
  });

  Future<ApiResult<void>> sendPasswordResetEmail({required String email});

  Future<ApiResult<void>> signOut();
}
