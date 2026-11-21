import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

@module
abstract class DiModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio => DioClient.client;

  @lazySingleton
  ApiService get apiService => ApiService(DioClient.client);
}
