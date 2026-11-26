import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/theme/app_typography.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_states.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordCubit cubit = sl<ForgotPasswordCubit>();
  StreamSubscription<ForgotPasswordNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(ForgotPasswordNavigationAction effect) {
    switch (effect) {
      case NavigateBackToLoginScreen():
        context.pop();
      case ShowForgotPasswordErrorToast(:final errorMessage):
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
        appBar: AppBar(title: Text(context.locale.forgotPassword)),
        body: Center(
          child: Text(
            context.locale.forgotPassword,
            style: AppTypography.titleLarge,
          ),
        ),
      ),
    );
  }
}
