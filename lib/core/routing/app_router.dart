import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Movies App Foundation Ready')),
          ),
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
