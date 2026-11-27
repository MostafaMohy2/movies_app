import 'dart:async';
import 'package:flutter/gestures.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StreamSubscription<LoginNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
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

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        SubmitLoginAction(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<LoginCubit, LoginStates>(
            builder: (context, state) => _buildBody(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LoginStates state) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 24.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24.h),
            _buildLogo(),
            SizedBox(height: 44.h),
            _buildEmailField(context),
            SizedBox(height: 18.h),
            _buildPasswordField(context),
            SizedBox(height: 8.h),
            _buildForgotPasswordLink(context),
            SizedBox(height: 20.h),
            _buildLoginButton(context, state),
            SizedBox(height: 20.h),
            _buildCreateAccountPrompt(context),
            SizedBox(height: 24.h),
            _buildOrDivider(context),
            SizedBox(height: 24.h),
            _buildGoogleLoginButton(context, state),
            SizedBox(height: 32.h),
            _buildLanguageToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Icon(
        Icons.play_circle_outline_rounded,
        size: 110.r,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      controller: _emailController,
      hintText: context.locale.email,
      prefixIcon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (val) => Validator.emailValidator(val, context.locale),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return AppTextField(
      controller: _passwordController,
      hintText: context.locale.password,
      prefixIcon: Icons.lock_rounded,
      isPassword: true,
      textInputAction: TextInputAction.done,
      obscureTooltip: context.locale.togglePasswordVisibility,
      validator: (val) => Validator.passwordValidator(val, context.locale),
      onFieldSubmitted: (_) => _onLoginPressed(),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () => _cubit.doAction(NavigateToForgotPasswordAction()),
        style: TextButton.styleFrom(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 4.w,
            vertical: 4.h,
          ),
        ),
        child: Text(
          context.locale.forgotPasswordQuestion,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginStates state) {
    return AppButton(
      label: context.locale.login,
      isLoading: state.loginResource.isLoading,
      isEnabled: !state.googleLoginResource.isLoading,
      onPressed: _onLoginPressed,
    );
  }

  Widget _buildCreateAccountPrompt(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(text: '${context.locale.dontHaveAccount} '),
            TextSpan(
              text: context.locale.createOne,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _cubit.doAction(NavigateToRegisterAction()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.primary, thickness: 1)),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          child: Text(
            context.locale.orDivider,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.primary, thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context, LoginStates state) {
    return AppButton(
      label: context.locale.loginWithGoogle,
      isLoading: state.googleLoginResource.isLoading,
      isEnabled: !state.loginResource.isLoading,
      leading: Icon(
        Icons.g_mobiledata_rounded,
        size: 28.r,
        color: Colors.black,
      ),
      onPressed: () => _cubit.doAction(LoginWithGoogleAction()),
    );
  }

  Widget _buildLanguageToggle() {
    return Center(
      child: BlocBuilder<AppConfigCubit, AppConfigStates>(
        builder: (context, configState) {
          return LanguageToggleSwitch(
            currentLocale: configState.locale,
            onLocaleSelected: (locale) {
              context.read<AppConfigCubit>().doAction(
                ChangeLocaleAction(locale),
              );
            },
          );
        },
      ),
    );
  }
}
