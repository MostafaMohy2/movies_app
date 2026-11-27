# Walkthrough: Firebase Auth Full Implementation & Routing

**Date**: 2026-11-27  
**Branch**: `feat/auth-profile`

## Summary of Changes

1. **Presentation Layer (`lib/features/auth/presentation/`)**:
   - Wired `RegisterCubit` to `RegisterUserUseCase` and avatar selection (`SelectAvatarAction`), and `ForgotPasswordCubit` to `SendPasswordResetUseCase` (`SubmitForgotPasswordAction`).
   - Built Figma-faithful UIs for `LoginPage`, `RegisterPage` (with 9-avatar `PageView` carousel from `assets/images/Component 11 – *.png`), and `ForgotPasswordPage` using `AppTextField`, `AppButton`, `LanguageToggleSwitch`, `AppColors`, `AppTypography`, and `Validator`.
   - Connected `LanguageToggleSwitch` to `AppConfigCubit` for live EN/AR locale switching.
2. **Routing & App Entry (`lib/routing/app_router.dart`, `lib/main.dart`)**:
   - Lifted `AppRouter` out of `lib/core/routing/` to `lib/routing/app_router.dart` so `lib/core/` never imports `lib/features/`.
   - Configured `Routes.initial` (`/`) and `Routes.login` to open `LoginPage`, alongside `Routes.register` and `Routes.forgotPassword`.
   - Added guarded `Firebase.initializeApp()` and root `AppConfigCubit` `BlocProvider` in `lib/main.dart`.
3. **Codegen, Tests & Docs**:
   - Ran `flutter gen-l10n` and `dart run build_runner build`.
   - Updated `widget_test.dart`, `login_cubit_test.dart`, `register_cubit_test.dart`, and `forgot_password_cubit_test.dart` with `mocktail` mocks.
   - Updated `docs/04-theme-and-ui-components.md`, `docs/09-network-layer.md`, and `docs/13-feature-auth.md`.
