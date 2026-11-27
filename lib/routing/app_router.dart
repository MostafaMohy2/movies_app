import 'package:flutter/material.dart';
import 'package:movies_app/core/routing/routes.dart';
import 'package:movies_app/features/auth/presentation/forgot_password/view/forgot_password_page.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_page.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
