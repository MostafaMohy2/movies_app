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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  StreamSubscription<ForgotPasswordNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(ForgotPasswordNavigationAction effect) {
    switch (effect) {
      case NavigateBackToLoginScreen():
        context.pop();
      case ShowResetSuccessToast():
        context.showSnackBar(
          SnackBar(content: Text(context.locale.resetEmailSent)),
        );
      case ShowForgotPasswordErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  void _onVerifyEmailPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        SubmitForgotPasswordAction(email: _emailController.text.trim()),
      );
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _emailController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordStates>(
            builder: (context, state) => _buildBody(context, state),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        tooltip: context.locale.back,
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: () => _cubit.doAction(NavigateBackToLoginAction()),
      ),
      title: Text(
        context.locale.forgotPassword,
        style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ForgotPasswordStates state) {
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
            SizedBox(height: 16.h),
            _buildIllustrationPlaceholder(),
            SizedBox(height: 40.h),
            _buildEmailField(context),
            SizedBox(height: 24.h),
            _buildVerifyEmailButton(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustrationPlaceholder() {
    return Center(
      child: Container(
        width: 220.r,
        height: 220.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.14),
        ),
        child: Icon(
          Icons.lock_reset_rounded,
          size: 110.r,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      controller: _emailController,
      hintText: context.locale.email,
      prefixIcon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: (val) => Validator.emailValidator(val, context.locale),
      onFieldSubmitted: (_) => _onVerifyEmailPressed(),
    );
  }

  Widget _buildVerifyEmailButton(
    BuildContext context,
    ForgotPasswordStates state,
  ) {
    return AppButton(
      label: context.locale.verifyEmail,
      isLoading: state.resetResource.isLoading,
      onPressed: _onVerifyEmailPressed,
    );
  }
}
