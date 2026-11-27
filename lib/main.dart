import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/firebase_options.dart';
import 'core/config/app_config_cubit.dart';
import 'core/config/app_config_states.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/app_localizations.dart';
import 'core/routing/routes.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initServiceLocator();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AppConfigCubit>()..doAction(LoadAppConfigAction()),
      child: BlocBuilder<AppConfigCubit, AppConfigStates>(
        builder: (context, configState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Movies App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme,
                themeMode: ThemeMode.dark,
                locale: configState.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                initialRoute: Routes.initial,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
