# Feature: Authentication (`auth`)

## 1. Overview

Handles user authentication flows using **Firebase Authentication** and **Google Sign-In**: Login, Register, and Forgot Password. Implemented following Clean Architecture (`BaseCubit` + UseCases + `AuthRepository` + `AuthRemoteDataSource` + `AuthMapper`).

## 2. Screen Inventory & Routing

`AppRouter` lives in `lib/routing/app_router.dart` (above `lib/core/` so `core/` never imports `features/`). `Routes.initial` (`/`) opens directly to `LoginPage`.

| Screen | Route (`Routes.*`) | Cubit | States / Actions / Nav |
| :--- | :--- | :--- | :--- |
| `LoginPage` | `Routes.initial` (`/`), `Routes.login` (`/login`) | `LoginCubit` | `LoginStates`, `LoginAction` (`SubmitLoginAction`, `LoginWithGoogleAction`, `NavigateToRegisterAction`, `NavigateToForgotPasswordAction`), `LoginNavigationAction` |
| `RegisterPage` | `Routes.register` (`/register`) | `RegisterCubit` | `RegisterStates`, `RegisterAction` (`SubmitRegisterAction`, `SelectAvatarAction`, `NavigateToLoginAction`), `RegisterNavigationAction` |
| `ForgotPasswordPage` | `Routes.forgotPassword` (`/forgot-password`) | `ForgotPasswordCubit` | `ForgotPasswordStates`, `ForgotPasswordAction` (`SubmitForgotPasswordAction`, `NavigateBackToLoginAction`), `ForgotPasswordNavigationAction` |

## 3. Domain & Data Layer

- **Entity**: `lib/features/auth/domain/entities/auth_user_entity.dart` (`AuthUserEntity`)
- **Repository interface**: `lib/features/auth/domain/repository/auth_repository.dart` (`AuthRepository`)
- **UseCases**:
  - `LoginWithEmailUseCase` (`lib/features/auth/domain/use_case/login_with_email_usecase.dart`)
  - `LoginWithGoogleUseCase` (`lib/features/auth/domain/use_case/login_with_google_usecase.dart`)
  - `RegisterUserUseCase` (`lib/features/auth/domain/use_case/register_user_usecase.dart`)
  - `SendPasswordResetUseCase` (`lib/features/auth/domain/use_case/send_password_reset_usecase.dart`)
- **Repository impl**: `lib/features/auth/data/repository/auth_repository_impl.dart` (`AuthRepositoryImpl`, `@LazySingleton(as: AuthRepository)`)
- **Remote data source**: `lib/features/auth/data/datasource/remote/auth_remote_data_source.dart` (`AuthFirebaseDataSourceImpl` implementing `AuthRemoteDataSource`)
- **Mapper**: `lib/features/auth/data/mapper/auth_mapper.dart` (`AuthMapper.fromFirebaseUser`)
- **DI module**: `lib/features/auth/data/di/auth_di_module.dart` (`AuthDiModule` providing `FirebaseAuth` and `GoogleSignIn`)

## 4. Localisation Keys (`app_en.arb` / `app_ar.arb`)

- Screen & UI labels: `login`, `register`, `forgotPassword`, `email`, `password`, `confirmPassword`, `name`, `phoneNumber`, `forgotPasswordQuestion`, `dontHaveAccount`, `createOne`, `alreadyHaveAccount`, `orDivider`, `loginWithGoogle`, `createAccount`, `verifyEmail`, `avatar`, `resetEmailSent`, `googleSignInCancelled`, `togglePasswordVisibility`, `back`
- Validation keys wired to `Validator`: `invalidName`, `nameCantBeEmpty`, `nameisinInvalidFormat`, `invalidEmail`, `emailCantBeEmpty`, `emailIsInInvalidFormat`, `invalidPassword`, `passwordCantBeEmpty`, `passwordIsInInvalidFormat`, `invalidPasswordConfirmation`, `passwordConfirmationCantBeEmpty`, `passwordsDoNotMatch`, `invalidPhone`, `phoneCantBeEmpty`, `phoneIsInInvalidFormat`

## 5. Firebase Configuration

- Configured via `flutterfire configure` (`lib/firebase_options.dart`, `firebase.json`, `android/app/google-services.json`, and `com.google.gms.google-services` Gradle plugin).
- `lib/main.dart` initializes Firebase with `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
