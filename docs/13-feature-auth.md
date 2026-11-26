# Feature: Authentication (`auth`)

## 1. Overview

Handles user authentication flows: Login, Register, and Forgot Password. Currently scaffolded following Clean Architecture (`BaseCubit` + `AuthRepository` + `AuthRemoteDataSource`).

## 2. Screen Inventory

| Screen | Route (`Routes.*`) | Cubit | States / Actions / Nav |
| :--- | :--- | :--- | :--- |
| `LoginPage` | `Routes.login` (`/login`) | `LoginCubit` | `LoginStates`, `LoginAction`, `LoginNavigationAction` |
| `RegisterPage` | `Routes.register` (`/register`) | `RegisterCubit` | `RegisterStates`, `RegisterAction`, `RegisterNavigationAction` |
| `ForgotPasswordPage` | `Routes.forgotPassword` (`/forgot-password`) | `ForgotPasswordCubit` | `ForgotPasswordStates`, `ForgotPasswordAction`, `ForgotPasswordNavigationAction` |

*(Note: `AppRouter` currently stays in `lib/core/routing/app_router.dart` and must not import `lib/features/` per `CLAUDE.md` §10; route wiring will follow once router composition is lifted above `core/`.)*

## 3. Domain & Data Layer

- **Repository interface**: `lib/features/auth/domain/repository/auth_repository.dart` (`AuthRepository`)
- **Repository impl**: `lib/features/auth/data/repository/auth_repository_impl.dart` (`AuthRepositoryImpl`, `@LazySingleton(as: AuthRepository)`)
- **Remote data source**: `lib/features/auth/data/datasource/remote/auth_remote_data_source.dart` (`AuthRemoteDataSource`, `@RestApi()` consuming injected `Dio`)
- **DI module**: `lib/features/auth/data/di/auth_di_module.dart` (`AuthDiModule`)

## 4. Localisation Keys (`app_en.arb` / `app_ar.arb`)

- `login`, `register`, `forgotPassword`
- Validation keys already available in `Validator`: `invalidName`, `nameCantBeEmpty`, `nameisinInvalidFormat`, `invalidEmail`, `emailCantBeEmpty`, `emailIsInInvalidFormat`, `invalidPassword`, `passwordCantBeEmpty`, `passwordIsInInvalidFormat`, `invalidPasswordConfirmation`, `passwordConfirmationCantBeEmpty`, `passwordsDoNotMatch`

## 5. Known Limitations / Next Steps

- Auth backend endpoints, request/response DTOs, mappers, and use cases are pending API contract confirmation in [09-network-layer.md](09-network-layer.md).
- Form UIs and `Validator` wiring will be implemented per `CLAUDE.md` §17 (Pattern A or B) once endpoints and Figma specs are applied.
