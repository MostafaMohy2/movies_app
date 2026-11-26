import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;
}
