import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/common_ui/buttons/app_button.dart';
import 'package:movies_app/core/common_ui/inputs/app_text_field.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_typography.dart';
import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'package:movies_app/core/utils/validator.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_states.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordCubit _cubit = sl<ForgotPasswordCubit>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  StreamSubscription<ForgotPasswordNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(ForgotPasswordNavigationAction action) {
    switch (action) {
      case NavigateBackToLoginScreen():
        Navigator.pop(context);
      case ShowResetSuccessToast():
        context.showSnackBar(
          SnackBar(
            content: Text(context.locale.resetEmailSent),
            backgroundColor: AppColors.success,
          ),
        );
      case ShowForgotPasswordErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _emailController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.doAction(
      SubmitForgotPasswordAction(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
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
                  SizedBox(height: 24.h),
                  _buildIllustration(),
                  SizedBox(height: 40.h),
                  _buildEmailField(context),
                  SizedBox(height: 28.h),
                  BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                    buildWhen: (prev, curr) =>
                        prev.resetResource != curr.resetResource,
                    builder: (ctx, state) => _buildVerifyButton(ctx, state),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        tooltip: context.locale.back,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primary,
        ),
        onPressed: () => _cubit.doAction(const NavigateBackToLoginAction()),
      ),
      title: Text(
        context.locale.forgotPassword,
        style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildIllustration() {
    return Image.asset(
      'assets/images/Forgot password-bro 1.png',
      width: 260.w,
      height: 260.h,
      fit: BoxFit.contain,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      controller: _emailController,
      hintText: context.locale.email,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: (v) => Validator.emailValidator(v, context.locale),
      onFieldSubmitted: (_) => _onVerifyPressed(),
    );
  }

  Widget _buildVerifyButton(BuildContext context, ForgotPasswordState state) {
    return AppButton(
      label: context.locale.verifyEmail,
      isLoading: state.resetResource.isLoading,
      isEnabled: !state.resetResource.isLoading,
      onPressed: _onVerifyPressed,
    );
  }
}
