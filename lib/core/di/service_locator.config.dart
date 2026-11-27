// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movies_app/core/config/app_config_cubit.dart' as _i112;
import 'package:movies_app/core/di/di_module.dart' as _i384;
import 'package:movies_app/features/auth/data/datasource/remote/auth_remote_data_source.dart'
    as _i1012;
import 'package:movies_app/features/auth/data/di/auth_di_module.dart' as _i1068;
import 'package:movies_app/features/auth/data/repository/auth_repository_impl.dart'
    as _i539;
import 'package:movies_app/features/auth/domain/repository/auth_repository.dart'
    as _i110;
import 'package:movies_app/features/auth/domain/use_case/login_with_email_usecase.dart'
    as _i458;
import 'package:movies_app/features/auth/domain/use_case/login_with_google_usecase.dart'
    as _i876;
import 'package:movies_app/features/auth/domain/use_case/register_user_usecase.dart'
    as _i951;
import 'package:movies_app/features/auth/domain/use_case/send_password_reset_usecase.dart'
    as _i165;
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
    gh.lazySingleton<_i361.Dio>(() => diModule.dio);
    gh.lazySingleton<_i59.FirebaseAuth>(() => authDiModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => authDiModule.googleSignIn);
    gh.lazySingleton<_i112.AppConfigCubit>(
      () => _i112.AppConfigCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1012.AuthRemoteDataSource>(
      () => _i1012.AuthFirebaseDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i110.AuthRepository>(
      () => _i539.AuthRepositoryImpl(gh<_i1012.AuthRemoteDataSource>()),
    );
    gh.factory<_i458.LoginWithEmailUseCase>(
      () => _i458.LoginWithEmailUseCase(gh<_i110.AuthRepository>()),
    );
    gh.factory<_i876.LoginWithGoogleUseCase>(
      () => _i876.LoginWithGoogleUseCase(gh<_i110.AuthRepository>()),
    );
    gh.factory<_i951.RegisterUserUseCase>(
      () => _i951.RegisterUserUseCase(gh<_i110.AuthRepository>()),
    );
    gh.factory<_i165.SendPasswordResetUseCase>(
      () => _i165.SendPasswordResetUseCase(gh<_i110.AuthRepository>()),
    );
    gh.factory<_i633.ForgotPasswordCubit>(
      () => _i633.ForgotPasswordCubit(gh<_i165.SendPasswordResetUseCase>()),
    );
    gh.factory<_i763.RegisterCubit>(
      () => _i763.RegisterCubit(gh<_i951.RegisterUserUseCase>()),
    );
    gh.factory<_i1043.LoginCubit>(
      () => _i1043.LoginCubit(
        gh<_i458.LoginWithEmailUseCase>(),
        gh<_i876.LoginWithGoogleUseCase>(),
      ),
    );
    return this;
  }
}

class _$DiModule extends _i384.DiModule {}

class _$AuthDiModule extends _i1068.AuthDiModule {}
