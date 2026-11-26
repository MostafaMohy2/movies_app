import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../datasource/remote/auth_remote_data_source.dart';

@module
abstract class AuthDiModule {
  @lazySingleton
  AuthRemoteDataSource provideAuthRemoteDataSource(Dio dio) =>
      AuthRemoteDataSource(dio);
}
