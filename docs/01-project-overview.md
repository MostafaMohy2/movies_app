# Project Overview — `movies_app`

## 1. Summary

`movies_app` is a cross-platform Flutter application (Dart `^3.12.2`) built with feature-first Clean Architecture, `BaseCubit` state management, `get_it` + `injectable` DI, and `dio` + `retrofit` networking.

## 2. Sanctioned Stack

| Concern | Package / Implementation | Location |
| :--- | :--- | :--- |
| State management | `flutter_bloc` (`BaseCubit<T, A, NE>`) | `lib/core/base/base_cubit.dart` |
| Dependency injection | `get_it` (`sl`) + `injectable` | `lib/core/di/service_locator.dart`, `di_module.dart` |
| Networking | `dio` + `retrofit` + `safeCall` + `ErrorParser` | `lib/core/network/` |
| Routing | `AppRouter.onGenerateRoute` + `Routes` | `lib/core/routing/` |
| Localization | `flutter_localizations` + `intl` (`gen-l10n`) | `l10n.yaml`, `lib/core/l10n/` |
| Theme & responsiveness | `AppTheme`, `AppColors`, `AppTypography`, `flutter_screenutil`, `google_fonts` | `lib/core/theme/` |
| Media | `cached_network_image`, `flutter_svg` | `lib/core/common_ui/` |
| Local persistence | `shared_preferences` | `lib/core/di/di_module.dart` |
| Testing | `flutter_test`, `bloc_test`, `mocktail` | `test/` |

**Forbidden packages**: `freezed`, `dartz`, `fpdart`, `Either`, `equatable`, `bloc_concurrency`, `reactive_forms`, `provider`, `riverpod`.

## 3. Repository Structure

```text
lib/
├── main.dart                     # App entrypoint (MoviesApp, ScreenUtilInit, initServiceLocator)
├── core/
│   ├── base/                     # BaseCubit<T, A, NE>
│   ├── common_ui/                # Cross-feature UI primitives (catalogued in docs/04)
│   ├── di/                       # Service locator (sl), DiModule, service_locator.config.dart
│   ├── entities/                 # Shared domain entities (MovieEntity)
│   ├── l10n/                     # ARB files (app_en.arb, app_ar.arb) & generated AppLocalizations
│   ├── network/                  # DioClient, ApiConstants, ApiResult, Resources, Errors, safeCall
│   ├── routing/                  # Routes & AppRouter
│   ├── theme/                    # AppColors, AppTypography, AppTheme
│   └── utils/                    # Validator, DialogUtils, BuildContext/DateTime/Icon/Number/Widget extensions
└── features/
    ├── auth/
    ├── browse/
    ├── home/
    ├── movie_details/
    ├── onboarding/
    ├── profile/
    ├── search/
    └── splash/
```

## 4. Routing Inventory

Defined in `lib/core/routing/routes.dart` and handled in `lib/core/routing/app_router.dart`:

- `Routes.initial` (`/`), `Routes.splash` (`/splash`)
- `Routes.onboarding` (`/onboarding`)
- `Routes.login` (`/login`), `Routes.register` (`/register`), `Routes.forgotPassword` (`/forgot-password`)
- `Routes.home` (`/home`), `Routes.movieDetails` (`/movie-details`)
- `Routes.search` (`/search`), `Routes.browse` (`/browse`), `Routes.profile` (`/profile`)

*(Currently only `Routes.initial` / `Routes.splash` render the foundation placeholder; feature pages will be wired as features are built.)*

## 5. Golden Rules

- All rules in [CLAUDE.md](../CLAUDE.md) apply to every task.
- `lib/core/` never imports `lib/features/`; features never import each other directly.
- Every shared UI widget in `lib/core/common_ui/` must be registered in [04-theme-and-ui-components.md](04-theme-and-ui-components.md).
- Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze --no-fatal-infos`, and `flutter test` before committing.
