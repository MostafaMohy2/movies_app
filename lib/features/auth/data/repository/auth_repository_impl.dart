import 'package:injectable/injectable.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/safe_call.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';
import 'package:movies_app/features/auth/domain/repository/auth_repository.dart';
import '../datasource/remote/auth_remote_data_source.dart';
import '../mapper/auth_mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<AuthUserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) => safeCall(() async {
    final credential = await _remoteDataSource.loginWithEmail(
      email: email,
      password: password,
    );
    return AuthMapper.fromFirebaseUser(credential.user!);
  });

  @override
  Future<ApiResult<AuthUserEntity>> loginWithGoogle() => safeCall(() async {
    final credential = await _remoteDataSource.loginWithGoogle();
    return AuthMapper.fromFirebaseUser(credential.user!);
  });

  @override
  Future<ApiResult<AuthUserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatarAsset,
  }) => safeCall(() async {
    final credential = await _remoteDataSource.register(
      email: email,
      password: password,
    );
    await _remoteDataSource.updateProfile(
      displayName: name,
      photoURL: avatarAsset,
    );
    return AuthMapper.fromFirebaseUser(
      credential.user!,
      phone: phone,
      avatarAsset: avatarAsset,
    );
  });

  @override
  Future<ApiResult<void>> sendPasswordResetEmail({required String email}) =>
      safeCall(() => _remoteDataSource.sendPasswordResetEmail(email: email));

  @override
  Future<ApiResult<void>> signOut() =>
      safeCall(() => _remoteDataSource.signOut());
}
