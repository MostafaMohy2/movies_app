class AuthUserEntity {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String? avatarAsset;

  const AuthUserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.avatarAsset,
  });
}
