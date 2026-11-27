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
import 'register_cubit.dart';
import 'register_states.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const List<String> _avatarAssets = [
    'assets/images/Component 11 – 1.png',
    'assets/images/Component 11 – 2.png',
    'assets/images/Component 11 – 4.png',
    'assets/images/Component 11 – 5.png',
    'assets/images/Component 11 – 6.png',
    'assets/images/Component 11 – 7.png',
    'assets/images/Component 11 – 8.png',
    'assets/images/Component 11 – 9.png',
    'assets/images/Component 11 – 10.png',
  ];

  final RegisterCubit _cubit = sl<RegisterCubit>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _avatarController = PageController(
    viewportFraction: 0.36,
    initialPage: 0,
  );
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  StreamSubscription<RegisterNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navigation.listen(_handleNavigation);
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

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        SubmitRegisterAction(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _avatarController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
          child: BlocBuilder<RegisterCubit, RegisterStates>(
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
        onPressed: () => _cubit.doAction(NavigateToLoginAction()),
      ),
      title: Text(
        context.locale.register,
        style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RegisterStates state) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAvatarCarousel(state),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                context.locale.avatar,
                style: AppTypography.bodyLarge,
              ),
            ),
            SizedBox(height: 20.h),
            _buildNameField(context),
            SizedBox(height: 16.h),
            _buildEmailField(context),
            SizedBox(height: 16.h),
            _buildPasswordField(context),
            SizedBox(height: 16.h),
            _buildConfirmPasswordField(context),
            SizedBox(height: 16.h),
            _buildPhoneField(context),
            SizedBox(height: 24.h),
            _buildCreateAccountButton(context, state),
            SizedBox(height: 18.h),
            _buildLoginPrompt(context),
            SizedBox(height: 20.h),
            _buildLanguageToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCarousel(RegisterStates state) {
    return SizedBox(
      height: 140.h,
      child: PageView.builder(
        controller: _avatarController,
        itemCount: _avatarAssets.length,
        onPageChanged: (index) {
          _cubit.doAction(
            SelectAvatarAction(avatarAsset: _avatarAssets[index]),
          );
        },
        itemBuilder: (context, index) {
          final asset = _avatarAssets[index];
          final isSelected = asset == state.selectedAvatarAsset;
          return GestureDetector(
            onTap: () {
              _avatarController.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
              _cubit.doAction(SelectAvatarAction(avatarAsset: asset));
            },
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: isSelected ? 124.r : 84.r,
                height: isSelected ? 124.r : 84.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.transparent,
                    width: 2.5,
                  ),
                ),
                child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AppTextField(
      controller: _nameController,
      hintText: context.locale.name,
      prefixIcon: Icons.badge_outlined,
      validator: (val) => Validator.nameValidator(val, context.locale),
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
      obscureTooltip: context.locale.togglePasswordVisibility,
      validator: (val) => Validator.passwordValidator(val, context.locale),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return AppTextField(
      controller: _confirmPasswordController,
      hintText: context.locale.confirmPassword,
      prefixIcon: Icons.lock_rounded,
      isPassword: true,
      obscureTooltip: context.locale.togglePasswordVisibility,
      validator: (val) => Validator.passwordConfirmationValidator(
        val,
        _passwordController.text,
        context.locale,
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return AppTextField(
      controller: _phoneController,
      hintText: context.locale.phoneNumber,
      prefixIcon: Icons.phone_rounded,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      validator: (val) => Validator.phoneValidator(val, context.locale),
      onFieldSubmitted: (_) => _onRegisterPressed(),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context, RegisterStates state) {
    return AppButton(
      label: context.locale.createAccount,
      isLoading: state.registerResource.isLoading,
      onPressed: _onRegisterPressed,
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(text: '${context.locale.alreadyHaveAccount} '),
            TextSpan(
              text: context.locale.login,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _cubit.doAction(NavigateToLoginAction()),
            ),
          ],
        ),
      ),
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
