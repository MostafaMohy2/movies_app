# Project Guidelines & Agents for `movies_app`

Welcome to `movies_app`. This project is a cross-platform Flutter application built with Dart.

## Mandatory Development Rules (`CLAUDE.md`)

**All work in this repository MUST follow [CLAUDE.md](CLAUDE.md) in full** — *"It's only a small change" never excuses skipping a rule.*

Key non-negotiables (see [CLAUDE.md](CLAUDE.md) for the full specification):
- **Pre-Task (§0)**: Read `CLAUDE.md`, inspect `docs/04-theme-and-ui-components.md`, `docs/09-network-layer.md`, and relevant `lib/core/` files, write a plan, and wait for user approval before editing code.
- **Architecture (§9–§11)**: Feature-first Clean Architecture using `BaseCubit<T, A, NE>` (`doAction` + `Stream<NE>`), plain immutable state classes with hand-written `copyWith`, `sealed class` Actions/NavigationActions, `UseCase` returning `Future<ApiResult<T>>`, `safeCall` + `Errors`, `Resources<T>` in State, and `injectable` + `get_it` (`sl`).
- **Forbidden Packages (§9.5, §22)**: Never add `freezed`, `dartz`, `fpdart`, `Either`, `equatable`, `bloc_concurrency`, `reactive_forms`, `provider`, or `riverpod`.
- **UI, Theme & L10n (§1, §5, §12, §20)**: Use `AppColors`, `AppTypography`, `AppTheme`, shared primitives in `lib/core/common_ui/` (catalogued in `docs/04-theme-and-ui-components.md`), shimmer loading for lists/grids, RTL-safe directional APIs (`EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`), and `AppLocalizations` (`app_en.arb` + `app_ar.arb`).
- **Verification & Docs (§3, §8, §9.10, §24)**: Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze --no-fatal-infos`, and tests (target ≥ 70% coverage), and update matching `docs/*.md` + `docs/walkthroughs/` before considering a task done.

## Project Specialized Subagents

### `flutter_developer`
- **Role**: Senior Flutter & Dart Specialist for `movies_app`.
- **Definition Path**: [.agents/agents/flutter_developer.md](.agents/agents/flutter_developer.md)
- **When to Invoke / Delegate**:
  - Developing new UI screens (Onboarding, Auth, Home, Browse, Search, Movie Details, Profile).
  - Building custom widgets, animations, Hero transitions, and shimmer skeletons.
  - Implementing `BaseCubit` state management, `UseCase`s, `Repository` implementations, and mappers.
  - Integrating Retrofit/Dio movie data APIs with `safeCall`, `ApiResult`, and pagination.
  - Resolving layout bugs (`RenderFlex` overflows, unbounded height/width) and RTL issues.
  - Writing `flutter_test` / `bloc_test` / `mocktail` tests and running static analysis (`flutter analyze`).

## Code Standards Summary
- **Dart & Flutter Version**: Modern Dart 3+ (`^3.12.2`) with sound null safety.
- **Widgets**: Prefer `const` constructors, keep files ≤ 400 lines, `build()` ≤ 100 lines, methods ≤ 25 lines.
- **Responsiveness**: Use `flutter_screenutil`, `LayoutBuilder`, `MediaQuery`, and adaptive widgets.
- **Architecture**: Keep presentation (`Cubit`), domain (`UseCase`, `Repository` interface, `Entity`), and data (`DataSource`, `DTO`, `Mapper`, `RepositoryImpl`) strictly decoupled.
