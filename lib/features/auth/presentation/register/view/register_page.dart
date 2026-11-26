import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/routing/routes.dart';
import 'package:movies_app/core/theme/app_typography.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'register_cubit.dart';
import 'register_states.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterCubit cubit = sl<RegisterCubit>();
  StreamSubscription<RegisterNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(RegisterNavigationAction effect) {
    switch (effect) {
      case NavigateToLoginScreen():
        context.pushReplacementNamed(Routes.login);
      case NavigateToHomeScreen():
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
      case ShowRegisterErrorToast(:final errorMessage):
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
        appBar: AppBar(title: Text(context.locale.register)),
        body: Center(
          child: Text(context.locale.register, style: AppTypography.titleLarge),
        ),
      ),
    );
  }
}
