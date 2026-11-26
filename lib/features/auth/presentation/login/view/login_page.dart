import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/routing/routes.dart';
import 'package:movies_app/core/theme/app_typography.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'login_cubit.dart';
import 'login_states.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginCubit cubit = sl<LoginCubit>();
  StreamSubscription<LoginNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(LoginNavigationAction effect) {
    switch (effect) {
      case NavigateToRegisterScreen():
        context.pushReplacementNamed(Routes.register);
      case NavigateToForgotPasswordScreen():
        context.pushNamed(Routes.forgotPassword);
      case NavigateToHomeScreen():
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
      case ShowLoginErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(context.locale.login)),
        body: Center(
          child: Text(context.locale.login, style: AppTypography.titleLarge),
        ),
      ),
    );
  }
}
