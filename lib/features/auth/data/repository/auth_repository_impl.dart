import 'package:injectable/injectable.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/remote/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // ignore: unused_field, todo: use remote data source once auth endpoints are defined
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);
}
