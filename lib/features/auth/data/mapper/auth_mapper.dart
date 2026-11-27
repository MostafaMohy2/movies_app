import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';

class AuthMapper {
  const AuthMapper._();

  static AuthUserEntity fromFirebaseUser(
    User user, {
    String? phone,
    String? avatarAsset,
  }) {
    return AuthUserEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: phone,
      avatarAsset: avatarAsset,
    );
  }
}
