import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/common_ui/buttons/app_button.dart';
import 'package:movies_app/core/common_ui/inputs/app_text_field.dart';
import 'package:movies_app/core/common_ui/toggles/language_toggle_switch.dart';
import 'package:movies_app/core/config/app_config_cubit.dart';
import 'package:movies_app/core/config/app_config_states.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/routing/routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_typography.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'package:movies_app/core/utils/validator.dart';
import 'login_cubit.dart';
import 'login_states.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginCubit _cubit = sl<LoginCubit>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<LoginNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(LoginNavigationAction action) {
    switch (action) {
      case NavigateToHomeScreen():
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
      case NavigateToRegisterScreen():
        Navigator.pushNamed(context, Routes.register);
      case NavigateToForgotPasswordScreen():
        Navigator.pushNamed(context, Routes.forgotPassword);
      case ShowLoginErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.doAction(
      SubmitLoginAction(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 24.w,
              vertical: 24.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32.h),
                  _buildLogo(),
                  SizedBox(height: 40.h),
                  _buildEmailField(context),
                  SizedBox(height: 16.h),
                  _buildPasswordField(context),
                  SizedBox(height: 8.h),
                  _buildForgotPasswordLink(context),
                  SizedBox(height: 24.h),
                  _buildLoginActionsSection(context),
                  SizedBox(height: 32.h),
                  _buildLanguageToggle(context),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginActionsSection(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (prev, curr) =>
              prev.loginResource != curr.loginResource ||
              prev.isAnyLoading != curr.isAnyLoading,
          builder: (ctx, state) => _buildLoginButton(ctx, state),
        ),
        SizedBox(height: 16.h),
        _buildCreateAccountRow(context),
        SizedBox(height: 24.h),
        _buildOrDivider(context),
        SizedBox(height: 24.h),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (prev, curr) =>
              prev.googleLoginResource != curr.googleLoginResource ||
              prev.isAnyLoading != curr.isAnyLoading,
          builder: (ctx, state) => _buildGoogleButton(ctx, state),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo1.png',
      width: 120.w,
      height: 120.h,
      fit: BoxFit.contain,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      controller: _emailController,
      hintText: context.locale.email,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (v) => Validator.emailValidator(v, context.locale),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return AppTextField(
      controller: _passwordController,
      hintText: context.locale.password,
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      obscureTooltip: context.locale.togglePasswordVisibility,
      textInputAction: TextInputAction.done,
      validator: (v) => Validator.passwordValidator(v, context.locale),
      onFieldSubmitted: (_) => _onLoginPressed(),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () =>
            _cubit.doAction(const NavigateToForgotPasswordAction()),
        child: Text(
          context.locale.forgotPasswordQuestion,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return AppButton(
      label: context.locale.login,
      isLoading: state.loginResource.isLoading,
      isEnabled: !state.isAnyLoading,
      onPressed: _onLoginPressed,
    );
  }

  Widget _buildCreateAccountRow(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(context.locale.dontHaveAccount, style: AppTypography.bodyMedium),
        GestureDetector(
          onTap: () => _cubit.doAction(const NavigateToRegisterAction()),
          child: Text(
            context.locale.createOne,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.primary)),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          child: Text(
            context.locale.orDivider,
            style: AppTypography.bodyMedium,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context, LoginState state) {
    return AppButton(
      label: context.locale.loginWithGoogle,
      isLoading: state.googleLoginResource.isLoading,
      isEnabled: !state.isAnyLoading,
      leading: Image.asset(
        'assets/images/icon _google_.png',
        width: 24.r,
        height: 24.r,
        fit: BoxFit.contain,
      ),
      onPressed: () => _cubit.doAction(const LoginWithGoogleAction()),
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
    return BlocBuilder<AppConfigCubit, AppConfigStates>(
      bloc: sl<AppConfigCubit>(),
      builder: (_, configState) => LanguageToggleSwitch(
        currentLocale: configState.locale,
        onLocaleSelected: (locale) =>
            sl<AppConfigCubit>().doAction(ChangeLocaleAction(locale)),
      ),
    );
  }
}
