// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movies_app/core/di/di_module.dart' as _i384;
import 'package:movies_app/features/auth/data/datasource/remote/auth_remote_data_source.dart'
    as _i1012;
import 'package:movies_app/features/auth/data/di/auth_di_module.dart' as _i1068;
import 'package:movies_app/features/auth/data/repository/auth_repository_impl.dart'
    as _i539;
import 'package:movies_app/features/auth/domain/repository/auth_repository.dart'
    as _i110;
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_cubit.dart'
    as _i633;
import 'package:movies_app/features/auth/presentation/login/view/login_cubit.dart'
    as _i1043;
import 'package:movies_app/features/auth/presentation/register/view/register_cubit.dart'
    as _i763;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final diModule = _$DiModule();
    final authDiModule = _$AuthDiModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => diModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i633.ForgotPasswordCubit>(() => _i633.ForgotPasswordCubit());
    gh.factory<_i1043.LoginCubit>(() => _i1043.LoginCubit());
    gh.factory<_i763.RegisterCubit>(() => _i763.RegisterCubit());
    gh.lazySingleton<_i361.Dio>(() => diModule.dio);
    gh.lazySingleton<_i1012.AuthRemoteDataSource>(
      () => authDiModule.provideAuthRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i110.AuthRepository>(
      () => _i539.AuthRepositoryImpl(gh<_i1012.AuthRemoteDataSource>()),
    );
    return this;
  }
}

class _$DiModule extends _i384.DiModule {}

class _$AuthDiModule extends _i1068.AuthDiModule {}
