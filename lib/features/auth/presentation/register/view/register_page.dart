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
import 'register_cubit.dart';
import 'register_states.dart';

/// Available avatar asset paths for the register avatar carousel.
const List<String> _kAvatarAssets = [
  'assets/images/Component 11 \u2013 1.png',
  'assets/images/Component 11 \u2013 2.png',
  'assets/images/Component 11 \u2013 4.png',
  'assets/images/Component 11 \u2013 5.png',
  'assets/images/Component 11 \u2013 6.png',
  'assets/images/Component 11 \u2013 7.png',
  'assets/images/Component 11 \u2013 8.png',
  'assets/images/Component 11 \u2013 9.png',
  'assets/images/Component 11 \u2013 10.png',
];

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterCubit _cubit = sl<RegisterCubit>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final PageController _avatarPageController = PageController(
    viewportFraction: 0.4,
    initialPage: 0,
  );
  StreamSubscription<RegisterNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(RegisterNavigationAction action) {
    switch (action) {
      case NavigateToLoginScreen():
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
      case ShowRegisterErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _avatarPageController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.doAction(
      SubmitRegisterAction(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      ),
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
              vertical: 16.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<RegisterCubit, RegisterState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedAvatarAsset != curr.selectedAvatarAsset,
                    builder: (ctx, state) => _buildAvatarCarousel(ctx, state),
                  ),
                  SizedBox(height: 8.h),
                  Text(context.locale.avatar, style: AppTypography.bodyMedium),
                  SizedBox(height: 24.h),
                  _buildNameField(context),
                  SizedBox(height: 16.h),
                  _buildEmailField(context),
                  SizedBox(height: 16.h),
                  _buildPasswordField(context),
                  SizedBox(height: 16.h),
                  _buildConfirmPasswordField(context),
                  SizedBox(height: 16.h),
                  _buildPhoneField(context),
                  SizedBox(height: 28.h),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    buildWhen: (prev, curr) =>
                        prev.registerResource != curr.registerResource,
                    builder: (ctx, state) => _buildRegisterButton(ctx, state),
                  ),
                  SizedBox(height: 16.h),
                  _buildLoginRow(context),
                  SizedBox(height: 24.h),
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
        onPressed: () => _cubit.doAction(const NavigateToLoginAction()),
      ),
      title: Text(
        context.locale.register,
        style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildAvatarCarousel(BuildContext context, RegisterState state) {
    return SizedBox(
      height: 110.h,
      child: PageView.builder(
        controller: _avatarPageController,
        itemCount: _kAvatarAssets.length,
        onPageChanged: (index) => _cubit.doAction(
          SelectAvatarAction(avatarAsset: _kAvatarAssets[index]),
        ),
        itemBuilder: (_, index) {
          final asset = _kAvatarAssets[index];
          final isSelected = state.selectedAvatarAsset == asset;
          return _AvatarItem(
            assetPath: asset,
            isSelected: isSelected,
            onTap: () {
              _avatarPageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _cubit.doAction(SelectAvatarAction(avatarAsset: asset));
            },
          );
        },
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AppTextField(
      controller: _nameController,
      hintText: context.locale.name,
      prefixIcon: Icons.person_outline_rounded,
      textInputAction: TextInputAction.next,
      validator: (v) => Validator.nameValidator(v, context.locale),
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
      textInputAction: TextInputAction.next,
      validator: (v) => Validator.passwordValidator(v, context.locale),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return AppTextField(
      controller: _confirmPasswordController,
      hintText: context.locale.confirmPassword,
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      obscureTooltip: context.locale.togglePasswordVisibility,
      textInputAction: TextInputAction.next,
      validator: (v) => Validator.passwordConfirmationValidator(
        v,
        _passwordController.text,
        context.locale,
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return AppTextField(
      controller: _phoneController,
      hintText: context.locale.phoneNumber,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      validator: (v) => Validator.phoneValidator(v, context.locale),
      onFieldSubmitted: (_) => _onRegisterPressed(),
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterState state) {
    return AppButton(
      label: context.locale.createAccount,
      isLoading: state.registerResource.isLoading,
      isEnabled: !state.registerResource.isLoading,
      onPressed: _onRegisterPressed,
    );
  }

  Widget _buildLoginRow(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.locale.alreadyHaveAccount,
          style: AppTypography.bodyMedium,
        ),
        GestureDetector(
          onTap: () => _cubit.doAction(const NavigateToLoginAction()),
          child: Text(
            context.locale.login,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

class _AvatarItem extends StatelessWidget {
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarItem({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsetsDirectional.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: isSelected ? 44.r : 36.r,
          backgroundColor: AppColors.surface,
          backgroundImage: AssetImage(assetPath),
        ),
      ),
    );
  }
}
