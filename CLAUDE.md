# Movies App (`movies_app`) — Development Rules

Read and follow every rule before starting **any** task (feature, fix, refactor, chore, hot-fix, spike). *"It's only a small change"* never excuses skipping a rule. A task ends only when the matching `docs/*.md` files and walkthrough are updated (§24). Code that compiles + passes `flutter analyze` is not "done".

Scope: Flutter codebase at `movies_app` (Dart `^3.12.2` / Dart ≥ 3.10), cross-platform (Android, iOS, Web, Desktop), dark-first UI (`AppTheme.darkTheme`).
Features: `auth`, `browse`, `home`, `movie_details`, `onboarding`, `profile`, `search`, `splash`.

---

## 0. Pre-Task Checklist

1. Read this file (`CLAUDE.md`) in full.
2. Write a plan (files created/modified, approach, decisions) and **wait for approval** before writing code.
3. Check the theme/UI catalogue ([docs/04-theme-and-ui-components.md](docs/04-theme-and-ui-components.md)) and `lib/core/theme/` (`AppColors`, `AppTypography`, `AppTheme`) before inventing any colour, type style, shape, button, input, card, toast, or sheet. Never add a new shared widget in `lib/core/common_ui/` without confirming none covers the need.
4. Check the API reference ([docs/09-network-layer.md](docs/09-network-layer.md)) and `lib/core/network/` (`ApiConstants`, `DioClient`). If a required endpoint is missing or unconfirmed, stop and report exactly which — no workarounds.
5. If modifying a feature, re-read its feature doc (`docs/13-feature-*.md` if present).
6. Grep for existing UseCases, Mappers, widgets, and utilities in `lib/core/` before reinventing.
7. **Always cross-reference project specs & existing architecture before new code**:
   - Check `docs/01-project-overview.md` and the design spec (Figma layout, spacing, colours, typography) before building UI.
   - Check `lib/core/routing/routes.dart` and `lib/core/routing/app_router.dart` before adding routes.
   - Verify every action, state, network call, and validation rule matches the feature requirements and Clean Architecture flow.
   - Re-skin/implement UI strictly using `lib/core/theme/` (`AppColors`, `AppTypography`, `AppTheme`), `lib/core/common_ui/`, and `flutter_screenutil` responsive sizing.
8. State the plan and wait for approval on any destructive action (`flutter clean` on a busy build, `rm -rf`, keystore overwrite, force-push, schema migration, deleting generated files).

---

## 1. Component Catalogue

- Shared-UI catalogue lives in `lib/core/common_ui/`, documented in `docs/04-theme-and-ui-components.md`.
- Every new shared widget gets a row in `docs/04-theme-and-ui-components.md` **before commit**: class name, file path, full constructor signature (named params + defaults), one-line purpose.
- Check `docs/04-theme-and-ui-components.md` before building any UI primitive; extend/parameterise rather than duplicate. Update the entry when params change.
- Feature-specific widgets stay in `lib/features/<feature>/presentation/<screen>/widgets/` (or `lib/features/<feature>/presentation/widgets/` when shared within a single feature) and are **not** catalogued — the catalogue is for cross-feature primitives.

---

## 2. Git Commits

- Commit after every completed, working unit. Format:

```text
<type>(<scope>): <short description>

<body — what & why, if non-obvious>
```

- **Types**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`.
- **Scopes**: `auth`, `onboarding`, `splash`, `home`, `browse`, `search`, `movie-details`, `profile`, `network`, `di`, `routing`, `theme`, `l10n`, `ci`, `android`, `ios`, `docs`.
- **Never commit**:
  - Secrets/signing files (`.env`, `.env.*` except `.env.example`, `key.properties`, `keystore.properties`, `google-services.json`, `GoogleService-Info.plist`, `*.jks`/`*.p8`/`*.p12`/`*.keystore`)
  - Build artefacts (`build/`, `.dart_tool/`, `.flutter-plugins*`, `ios/Pods/`, `ios/.symlinks/`, `ios/Flutter/Flutter.framework`, `ios/DerivedData/`, `android/.gradle/`, `android/app/release/`, `android/local.properties`, `*.iml`, `.idea/`)
  - Failing tests
  - Stray `print`/`debugPrint`/`log` in release paths
  - Commented-out code
  - Generated files whose source changed without re-running `build_runner` / `gen-l10n` (§25)
- **Never** run `--no-verify`, `git push --force` on `main`/`development`/`release/*`, or `git reset --hard` without explicit user instruction.
- Follow `.github/pull_request_template.md`: branch from `development`, keep branches intact until reviewed/merged, coordinate merge conflicts.

---

## 3. Walkthrough History

- After every completed feature, fix, or significant refactor: create/update `docs/walkthroughs/YYYY-MM-DD_<slug>.md` and add a one-line entry to `docs/walkthroughs/README.md`.
- **Required contents**:
  - **Date**
  - **Summary** (one paragraph)
  - **Files changed** (all created/modified; generated files only when their source changed)
  - **API changes** (endpoints + whether `docs/09-network-layer.md` updated)
  - **Widgets** (`+ docs/04-theme-and-ui-components.md` change)
  - **DI** (new registrations/modules + `service_locator.config.dart` regen)
  - **Routing** (routes, args, guards in `Routes` / `AppRouter`)
  - **Localization** (new keys in `app_en.arb` and `app_ar.arb` + regenerated `app_localizations*.dart`)
  - **Platform impact** (Dart vs Android/iOS/Web/Desktop native config)
  - **Code generation** (generators re-run)
  - **Testing** (tests added/run + coverage notes)
  - **Known limitations / follow-ups**

---

## 4. Secrets & Environment

- Never hardcode API keys, bearer tokens, passwords, or signing credentials in Dart source, `AndroidManifest.xml`, or `Info.plist`.
- All `.env*` files are gitignored except `.env.example` (every key, no values).
- Pass compile-time secrets via `--dart-define` / `--dart-define-from-file` or an environment config facade (`AppEnvironment`) — never scatter `String.fromEnvironment` or raw `dotenv.env['KEY']` across call sites. Fail fast at startup if a required runtime/API key is missing rather than silently falling back to empty strings.
- `ApiConstants.baseUrl` (`lib/core/network/api_constants.dart`) holds the non-secret API base URL (`https://api.themoviedb.org/3/`). Do **not** commit TMDB API keys or user tokens alongside it.
- Android signing (`android/key.properties`, `*.jks`) and iOS provisioning (`*.mobileprovision`, `*.p12`) remain gitignored.

---

## 5. Localisation (EN / AR)

- **Every user-facing string is localised.** Supported locales: `en` (LTR) and `ar` (RTL).
- Primary mechanism in `movies_app`: Flutter's `flutter_localizations` + `gen-l10n` configured in `l10n.yaml`:
  - Source files: `lib/core/l10n/app_en.arb` and `lib/core/l10n/app_ar.arb`.
  - Generated output: `lib/core/l10n/app_localizations.dart` (`app_localizations_en.dart`, `app_localizations_ar.dart`).
  - Access in widgets via `context.locale.<key>` (`BuildContextExtensions` in `lib/core/utils/build_context_extensions.dart`) or `AppLocalizations.of(context)!.<key>`.
  - *(Note: `assets/translations/en.json` and `ar.json` also exist from initial scaffolding; keep ARB files as the active `AppLocalizations` source of truth and keep `assets/translations/` in sync if referenced by any asset-based loader.)*
- **Adding a string**: add the key (with `@key` metadata in `app_en.arb`) to **both** `app_en.arb` and `app_ar.arb` in the same PR, then run `flutter gen-l10n` (or `flutter pub get`) and commit the regenerated `app_localizations*.dart` files.
- **No `BuildContext` in Cubits/Mappers/Validators**:
  - Validators in `lib/core/utils/validator.dart` accept `AppLocalizations locale` and return the already-localised `String?`.
  - Cubits emit typed `Errors` / `NavigationAction` effects or state keys, and the Page resolves the localised message from `context.locale` inside `_handleNavigation` / `build`.
- **Only literal-string exception**: the two language-picker labels (`"العربية"`, `"English"`).
- Parametrised strings and plurals use ARB ICU placeholders and `{count, plural, ...}`. Date/time formatting lives on centralised utilities (§6).
- **RTL-first**: always use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional` (e.g., `MovieCard`), and directional icons — **never** `EdgeInsets.only(left/right)` or `Alignment.centerLeft`/`centerRight`. RTL bugs are release blockers.
- **Server i18n**: pass active locale language parameter (e.g., `en-US` / `ar`) on TMDB/backend requests when localised metadata is supported, falling back to English when missing.

---

## 6. Timestamps & Timezones

- Parse backend ISO-8601 / date strings safely (`DateTime.tryParse(value)?.toUtc()`).
- Format dates/times via centralised helpers (`lib/core/utils/date_time_extensions.dart` / `AppFormatters`) using `intl` `DateFormat` with `Localizations.localeOf(context).languageCode`. Never call raw `DateTime.toString()` or scatter ad-hoc `DateFormat` instances inside widgets.
- Always send `dt.toUtc().toIso8601String()` when transmitting timestamps to an API; never send locally-formatted strings.
- Countdown timers recompute from wall-clock each tick (`DateTime.now().difference(target)`), not by decrementing a counter. Drive ticks with `Stream.periodic` inside the Cubit, emitting a state per tick.

---

## 7. Security Checklist (run before every commit)

- [ ] No token/secret/API key/credential in source or logs.
- [ ] `accessToken`/`refreshToken`/API keys never logged and never leaked in error reports.
- [ ] Sensitive persistence uses secure storage (`flutter_secure_storage` when introduced) — non-sensitive preferences use `shared_preferences` (injected via `DiModule`).
- [ ] HTTP requests ride the shared `Dio` (`DioClient.client` in `lib/core/network/dio_client.dart`); auth headers attached via interceptor, never manually scattered across data sources.
- [ ] No PII logged (email, name, phone, password, OTP, token).
- [ ] No `print`/`debugPrint` in release paths — gate debug logging on `kDebugMode` (or a dedicated logger).
- [ ] Any new SDK/API keys passed via `--dart-define` / `.env` / manifest placeholders — never hard-coded.
- [ ] Cleartext HTTP disallowed on release (`android:usesCleartextTraffic=false`, no `NSAllowsArbitraryLoads=true` on release).

---

## 8. Testing (≥ 70 % coverage)

- Every new UseCase, Mapper, Repository, and Cubit has unit tests. Target **≥ 70 % line coverage** (`flutter test --coverage`). Do not merge PRs with failing tests or uncovered business logic.

| Layer | Location | Tools |
| :--- | :--- | :--- |
| Unit (UseCase, Mapper, Repo, Utils) | `test/<feature>/...` or `test/core/...` | `flutter_test`, `mocktail` |
| Cubit | `test/<feature>/presentation/...` | `bloc_test`, `mocktail` |
| Network | `test/<feature>/data/...` | `mocktail` over `Dio` / `<Feature>RemoteDataSource` |
| Widget | `test/<feature>/presentation/...` or `test/core/common_ui/...` | `flutter_test` (`pumpWidget`) |
| Integration | `integration_test/` | `integration_test` |

- Mirror `lib/` paths in `test/`: e.g. `lib/features/home/domain/use_case/get_popular_movies_usecase.dart` → `test/features/home/domain/use_case/get_popular_movies_usecase_test.dart`.
- `blocTest` for every Cubit (`act` → `expect` → `verify`). Build mocks per test in `setUp`, reset if reused, no shared mutable state. Register `registerFallbackValue` when matching custom types with `any()`.
- Widget tests provide `MaterialApp` + `AppLocalizations.localizationsDelegates` + `AppLocalizations.supportedLocales` (and `ScreenUtilInit` when testing responsive widgets).
- Never use `Future.delayed` to wait in tests — use `pump`, `pumpAndSettle`, or `blocTest` `wait`.

---

## 9. Clean Architecture (Cubit + BaseCubit)

Feature layout:

```text
lib/features/<name>/
├── presentation/
│   ├── <screen>/
│   │   ├── view/
│   │   │   ├── <screen>_cubit.dart
│   │   │   ├── <screen>_states.dart
│   │   │   └── <screen>_page.dart
│   │   └── widgets/                  # (screen-local)
│   └── widgets/                      # (feature-shared)
├── domain/
│   ├── entities/
│   ├── repository/
│   └── use_case/
└── data/
    ├── datasource/
    │   ├── remote/
    │   └── local/
    ├── model/
    ├── mapper/
    └── repository/
```

Top-level `lib/`: `main.dart`, `core/` (`base/`, `common_ui/`, `di/`, `entities/`, `l10n/`, `network/`, `routing/`, `theme/`, `utils/`), `features/`.

### 9.1 Limits

- Dart file **≤ 400 lines**.
- `build()` method **≤ 100 lines** (else extract private sub-widgets like `_MovieHeader` or screen-local widgets).
- Method/function **≤ 25 lines** (else extract — each extracted logic function gets its own unit test).
- Applies to every hand-written Dart file (generated `*.g.dart` / `*.config.dart` / `app_localizations*.dart` excluded).

### 9.2 Structure

Organise by **feature**, not by file type (see `docs/01-project-overview.md`).

### 9.3 `BaseCubit<T, A, NE>`

Cubit (never `Bloc`) for every screen. Bloc events are replaced by `doAction(A action)` switching on a sealed class; one-shot effects flow through `Stream<NE>` (`lib/core/base/base_cubit.dart`):

```dart
abstract class BaseCubit<T, A, NE> extends Cubit<T> {
  BaseCubit(super.initialState);

  Future<void> doAction(A action);

  final StreamController<NE> _navigationStream = StreamController.broadcast();
  Stream<NE> get navigation => _navigationStream.stream;

  void emitNavigation(NE effect) => _navigationStream.add(effect);

  @override
  Future<void> close() {
    _navigationStream.close();
    return super.close();
  }
}
```

- Every screen Cubit extends `BaseCubit<<Screen>States, <Screen>Action, <Screen>NavigationAction>`. No `Bloc`/`on<Event>`/`transformers`.
- State = plain class (no `freezed`/`equatable`) with named-default fields + hand-written `copyWith`. `Action`/`NavigationAction` = Dart 3 `sealed class`.
- Mutate only via `emit(state.copyWith(...))` (never reassign `state`, never mutate nested collections in place). One-shot effects only via `emitNavigation(...)` (never a `"consumed"` flag in State). Cubits have **no `BuildContext`** and never touch `Navigator`.

### 9.4 Page (View)

`StatefulWidget` that: resolves cubit via `sl<...>()` (`lib/core/di/service_locator.dart`); subscribes to `cubit.navigation` in `initState`; wraps body in `BlocProvider.value(value: cubit, ...)`; uses `BlocBuilder`/`BlocSelector` only around state-dependent parts; dispatches via `cubit.doAction(...)` — never calls other cubit methods directly.

```dart
class _LoginPageState extends State<LoginPage> {
  final LoginCubit cubit = sl<LoginCubit>();
  StreamSubscription<LoginNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = cubit.navigation.listen(_handleNavigation);
  }

  void _handleNavigation(LoginNavigationAction effect) {
    switch (effect) {
      case NavigateToRegisterScreen():
        context.pushReplacementNamed(Routes.register);
      case NavigateToHomeScreen():
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
      case ShowLoginErrorToast(:final errorMessage):
        context.showErrorSnackBar(errorMessage);
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    cubit.close(); // close @injectable screen-owned cubit on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocProvider.value(value: cubit, child: /* ... */);
}
```

- Cancel `_navSub` in `dispose` (and close screen-scoped `@injectable` cubits; never close `@lazySingleton` cubits in a page). Pages hold **no business logic**. All navigation, dialogs, and toasts/snackbars go through `_handleNavigation`.

### 9.5 State / Action / NavigationAction (no `freezed`)

```dart
class LoginStates {
  final Resources<String> loginResource;
  const LoginStates({this.loginResource = const Resources.initial()});

  LoginStates copyWith({Resources<String>? loginResource}) =>
      LoginStates(loginResource: loginResource ?? this.loginResource);
}

sealed class LoginAction {}
class NavigateToRegisterAction extends LoginAction {}
class LoginUserAction extends LoginAction {
  final String email;
  final String password;
  LoginUserAction(this.email, this.password);
}

sealed class LoginNavigationAction {}
class NavigateToRegisterScreen extends LoginNavigationAction {}
class NavigateToHomeScreen extends LoginNavigationAction {}
class ShowLoginErrorToast extends LoginNavigationAction {
  final String errorMessage;
  ShowLoginErrorToast(this.errorMessage);
}
```

- **Forbidden**: `freezed`, `dartz`, `fpdart`, `Either`, `equatable` (any PR adding them is a blocker).
- State = `final` fields + named constructor + hand-written `copyWith` (`field ?? this.field`). If >~12 fields, compose sub-states (not `freezed`).
- Actions/NavigationActions are always `sealed class` (exhaustive `switch`, no `default`).
- State never carries `Function`/`BuildContext`/`StreamController` and must be cheap to copy. Always emit a new instance via `copyWith`.

### 9.6 Cubit Template

```dart
@injectable
class LoginCubit
    extends BaseCubit<LoginStates, LoginAction, LoginNavigationAction> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginStates());

  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case NavigateToRegisterAction():
        emitNavigation(NavigateToRegisterScreen());
      case LoginUserAction():
        await _login(action);
    }
  }

  Future<void> _login(LoginUserAction action) async {
    emit(state.copyWith(loginResource: const Resources.loading()));
    final res = await _loginUseCase.call(action.email, action.password);
    switch (res) {
      case Success<String>():
        emit(
          state.copyWith(
            loginResource: Resources.success(data: res.data),
          ),
        );
        emitNavigation(NavigateToHomeScreen());
      case Failure<String>():
        emit(
          state.copyWith(
            loginResource: Resources.failure(
              exception: res.exception,
              message: res.message,
            ),
          ),
        );
        emitNavigation(ShowLoginErrorToast(res.message));
    }
  }
}
```

- Constructor injection (`@injectable` → new instance per resolve = fresh state per mount).
- `doAction` is a thin dispatcher delegating to one private async method per case.
- Handlers follow: `emit loading` → `call use case` → `switch on ApiResult` → `emit success/failure` → `emit nav effect`.
- Cubits **never** `try/catch` HTTP exceptions (the data layer's `safeCall` converts them) and **never** read/write storage directly.

### 9.7 UseCase

- `class <Verb><Noun>UseCase { Future<ApiResult<T>> call(<Params>) }` — positional params for 1–2 parameters, else a typed `<Verb><Noun>Params` class.
- Returns `Future<ApiResult<T>>` (or `Stream<ApiResult<T>>` for streaming).
- May compose injected use cases (never instantiate them manually).
- Exactly one public method `call`; helpers `_`-prefixed.

### 9.8 Async / Streams / BuildContext

- All I/O lives behind a `Future<ApiResult<T>>` / `Stream<ApiResult<T>>` UseCase. No `async/await` in widgets except `Navigator.pushNamed(...).then(...)` or dialog awaits.
- Long-running streams (auth session, connectivity, etc.) are owned by `@lazySingleton` services in `lib/core/`, consumed via Cubits subscribing in `doAction(StartListeningAction())` and cancelling in `close()`.
- Never call `setState` inside a `builder`. Never use `BuildContext` after `await` without `if (!context.mounted) return;`.
- Debounce search/filter input inside the Cubit by cancelling/relaunching a `Timer`. Store all `StreamSubscription` and `Timer` fields and cancel them in `close()`/`dispose()`.

### 9.9 Naming

| Artefact | Convention | Example |
| :--- | :--- | :--- |
| Widget | `PascalCase`, descriptive domain name | `MovieCard`, `LoginPage` |
| Cubit | `<Feature><Screen>Cubit` | `HomeCubit`, `MovieDetailsCubit` |
| State/Action/Nav | `<Screen>States`/`Action`/`NavigationAction` | `HomeStates`, `HomeAction`, `HomeNavigationAction` |
| Action subclass | `<Verb><Noun>Action` | `LoadPopularMoviesAction`, `LoginUserAction` |
| Nav subclass | `<Verb><Noun>Screen` / `Show<Noun><Effect>` | `NavigateToMovieDetailsScreen`, `ShowLoginErrorToast` |
| UseCase | `<Verb><Noun>UseCase` | `GetPopularMoviesUseCase` |
| Repo interface / impl | `<Feature>Repository` / `...Impl` | `MoviesRepository`, `MoviesRepositoryImpl` |
| Mapper | `<Feature>Mapper` | `MovieMapper` |
| Remote data source | `<Feature>RemoteDataSource` | `HomeRemoteDataSource` |
| Local data source | `<Feature>LocalDataSource` | `ProfileLocalDataSource` |
| Request / Response DTO | `<Name>Request` / `<Name>Response` (or `<Name>Dto`) | `LoginRequest`, `MovieResponseDto` |

### 9.10 Lint

- `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`. Follow Effective Dart and keep `prefer_const_constructors`, `avoid_print`, `use_build_context_synchronously`, and `prefer_single_quotes` clean.
- Before every commit run:
  - `dart format --output=none --set-exit-if-changed .`
  - `flutter analyze --no-fatal-infos` (aim for 0 issues/warnings)
- Both must exit `0`. No `// ignore:` without inline justification + a TODO/issue reference.

---

## 10. Separation of Concerns

- **Views** → `cubit.doAction(...)` only (never call repositories, use cases, or `Dio`).
- **Cubits** → UseCases only (never repositories directly), switching on `ApiResult<T>`.
- **UseCases** → Repository interface only, returning `Future<ApiResult<T>>`.
- **RepositoryImpl** → `<Feature>RemoteDataSource` / `LocalDataSource` + `Mapper`, wrapping calls in `safeCall(...)`.
- No feature imports another feature's use cases directly except via DI-injected constructor dependencies (documented in both features' docs). Mappers perform DTO ↔ Entity conversion only (no side effects).
- `lib/core/` **never** imports `lib/features/`. `lib/features/<X>` never imports `lib/features/<Y>` directly. `lib/core/di/` (`service_locator.config.dart`) wires dependencies across layers via `injectable`.

---

## 11. API Integration

- HTTP goes through feature-level Retrofit data sources (`<Feature>RemoteDataSource` annotated with `@RestApi()` → `*.g.dart`). Never call `Dio` directly from a Cubit, Repository, or UseCase; the single shared client is `DioClient.client` (`lib/core/network/dio_client.dart`).
- Repository boundary returns `Future<ApiResult<T>>`; wrap Retrofit/API calls in `safeCall(() async => dataSource.fetchX(...))` (`lib/core/network/safe_call.dart`), which converts exceptions into `Failure<T>` via `ErrorParser.parse` (`lib/core/network/error_parser.dart`). No raw `DioException` escapes the data layer.
- DTOs are plain Dart classes (`@JsonSerializable(fieldRename: FieldRename.snake)` or explicit `fromJson`/`toJson`, **no `freezed`**) with `final` fields, nullable defaults unless guaranteed by contract.
- Handle loading/success/error explicitly via `Resources<T>` in State (§11.2) — never an unindicated in-flight UI.
- New/updated endpoint → same PR updates `docs/09-network-layer.md`. Never hard-code full URLs outside `ApiConstants` / environment config; `@RestApi()` leaves `baseUrl` empty so runtime `DioClient.client` supplies it.

### 11.1 `ApiResult<T>` (data-layer envelope — `lib/core/network/api_result.dart`)

```dart
sealed class ApiResult<T extends Object?> {
  const ApiResult();
}

class Success<T extends Object?> extends ApiResult<T> {
  final T? data;
  const Success(this.data);
}

class Failure<T extends Object?> extends ApiResult<T> {
  final Errors? exception;
  final String message;
  const Failure({this.exception, required this.message});
}
```

- Repositories and UseCases return `Future<ApiResult<T>>` — never `Future<T>`, `Either`, or another result wrapper. Cubits handle via exhaustive `switch (response) { case Success<T>(): ... case Failure<T>(): ... }`.

### 11.2 `Resources<T>` (UI envelope — `lib/core/network/resources.dart`)

```dart
enum Status { initial, loading, success, error }

class Resources<T> {
  final Status status;
  final T? data;
  final Errors? error;
  final String? message;
  // const Resources.initial() / .loading() / .success() / .failure()
  // bool get isInitial / isLoading / isSuccess / isError
}
```

- Cubit emits `Resources<T>` into State (one field per async operation), converting `ApiResult<T>` in switch arms. Default = `const Resources.initial()`. Never roll a custom `Status`/`Resources` variant. Per-entry state uses `Map<String, Resources<T>>` (§13).

---

## 12. Loading — Shimmer

- List/grid/poster-carousel loading uses shimmer skeletons — avoid spinners/blank screens/progress bars for feed/list loads. Circular indicators are allowed only inside a loading button or a single-call blocking dialog (`DialogUtils`).
- Shared shimmer primitives belong in `lib/core/common_ui/shimmer/` (documented in `docs/04-theme-and-ui-components.md` when added). Feature shimmers live in `lib/features/<feature>/presentation/widgets/<screen>_shimmer.dart`, mirroring real content shape/dimensions.
- Driven strictly by `state.<resource>.isLoading`: show on `Resources.loading()`, remove on success/failure — never a fixed `Future.delayed`.

---

## 13. Optimistic UI

- Mutating actions update the UI immediately (happy-path) where safe (e.g., watchlist/favorites toggle):
  1. Snapshot state
  2. Apply optimistic `emit(state.copyWith(...))`
  3. Send request
  4. On `Success`: keep (optionally merge canonical fields)
  5. On `Failure`: roll back to snapshot + `emitNavigation(ShowErrorToast(...))`
- Optimistic state lives in the Cubit; rollback is silent except the error notification (no visual flash).
- **Do not** apply optimistic updates where a wrong state causes confusion or data loss — emit `Resources.loading()` instead and wait: login/register, password reset, profile update, account deletion.
- Per-entry state: `Map<String, Resources<T>>` keyed by id; copy the map in `copyWith` (never mutate in place) and re-emit.

---

## 14. Token Management & Auth Interceptor

- When authenticated user endpoints are active, token attachment and refresh logic lives in `AuthInterceptor` / `RefreshInterceptor` on the shared `DioClient.client`; only `AuthRepositoryImpl` / session service touches tokens otherwise.
- Flow:
  1. `AuthInterceptor.onRequest` attaches `Authorization: Bearer` (skipping public auth endpoints).
  2. `RefreshInterceptor.onError` on 401/403 enters refresh using a mutex (`synchronized`) so concurrent 401s trigger at most one refresh call on a separate `Dio` without `RefreshInterceptor`.
  3. On refresh failure, emit force-logout via session/event bus → router clears stack to `Routes.login`.
- Store tokens only in secure storage (`flutter_secure_storage` when introduced) — never in plain `SharedPreferences` or logs.

---

## 15. Error Handling & Notifications

- Every error flows as `Errors` (`sealed class Errors` in `lib/core/network/errors.dart`) — never raw `Exception`/`DioException`/`Object`:
  - `NetworkError`, `TimeoutError`, `ParseError`, `ServerError(statusCode, code, message)`, `LoginRequired(forceLogout, message)`, `JustMessage(message)`, `Unknown(cause, message)`.
- `safeCall` (`lib/core/network/safe_call.dart`) catches exceptions and converts them to `Failure(exception, message)` via `ErrorParser.parse`. Feature code never `try/catch`es HTTP calls.
- User feedback goes through centralised helpers (`BuildContextExtensions.showErrorSnackBar`, `DialogUtils`, or a shared `Toaster`/`BottomSheetHost` in `lib/core/` when added) triggered from `_handleNavigation` in the Page — never from inside a Cubit.
- Logging: gate debug output on `kDebugMode` (never raw `print` in release paths).

---

## 16. Auth-Gated UI

- Features requiring user identity (watchlist, favorites, profile edits, history) are auth-gated; discovery/browsing/splash/onboarding/auth routes follow the app's auth design.
- Check session state via a centralised `@lazySingleton` auth/session service — never scatter ad-hoc `user != null` checks across widgets.
- Logout/account deletion wipes local user state unconditionally (even if the network request fails): clear tokens, user cache, and reset user-scoped state before navigating to `Routes.login` via `pushNamedAndRemoveUntil(..., (_) => false)`.

---

## 17. Form State (Cubit + Validators)

Pick one pattern per screen:

- **Pattern A — `Form` + `TextFormField` + `validator` (short forms: login, register, forgot password)**:
  - `GlobalKey<FormState>` + `TextEditingController`s in the View; `validator: (v) => Validator.emailValidator(v, context.locale)`.
  - Submit only if `formKey.currentState!.validate()`, then `cubit.doAction(...)`.
  - State carries `Resources<T>` for the outcome; button `isLoading` comes from `state.<resource>.isLoading`. Field errors stay in the form fields (no `<field>Error` in State).
- **Pattern B — fully Cubit-controlled (cross-field dependencies, server hints)**:
  - State holds `<field>: String` + `<field>Error: String?` + `bool get isValid`; View dispatches `<Field>Changed(value)`; Cubit re-runs `Validator` and emits.

Shared rules:
- Validation is centralised in `lib/core/utils/validator.dart` (`Validator`). Never scatter regex in widgets or Cubits — add a static method on `Validator` accepting `AppLocalizations locale`.
- Input filtering via `inputFormatters`. Disable submit buttons while loading. Reset forms explicitly via `ResetFormAction` after success. No `reactive_forms`.

---

## 18. Performance

- **Lazy DI**: everything via `injectable` + `get_it` (`sl` in `lib/core/di/service_locator.dart`), resolved on demand.
  - `@injectable` = new per resolve (screen Cubits, UseCases if stateless)
  - `@lazySingleton` = Repositories, DataSources, Services, shared Cubits
  - `@preResolve` / `@singleton` = boot-time dependencies (e.g., `SharedPreferences` in `DiModule`)
  - Run `dart run build_runner build --delete-conflicting-outputs` after DI changes; never hand-edit `service_locator.config.dart`.
- **Large lists**: >~30 items use `.builder`/`SliverList`/`SliverGrid` with stable `ValueKey(item.id)` (never index keys). Pagination via `ScrollController` triggering `LoadMoreAction`; State owns `hasReachedEnd`/`isLoadingMore`.
- **Recomposition**: `BlocSelector` for slices of frequently-rebuilt trees. Always emit new instances via `copyWith`. Use `const` aggressively.
- **Bundle**: audit `pubspec.yaml` dependencies before adding packages; use targeted `show` imports when helpful.
- **Images**: network images via `cached_network_image` (see `MovieCard`) — never `Image.network` directly. Local assets in `assets/images/` + `assets/icons/` (SVGs via `flutter_svg`). Prefer SVG; PNGs in 1x/2x/3x.

---

## 19. State Management Boundaries

| State type | Lives in |
| :--- | :--- |
| UI-only (expanded, tab index, scroll controller) | `StatefulWidget` field |
| Single-screen async data | Cubit State with `Resources<T>` |
| Cross-feature shared (auth session, watchlist, active locale) | `@lazySingleton` Cubit or Service in `lib/core/` |
| Server cache (genres, movie details) | `@lazySingleton` Repository with in-memory fields |
| Cross-feature signals (language change, auth logout) | Broadcast stream / event bus (`@lazySingleton`) |
| Transient cross-screen payloads / route args | Typed `RouteSettings.arguments` passed via `AppRouter` |

- Never lift state higher than needed. Shared singletons stay singletons — don't re-register them as `@injectable`.
- Event streams carry signals, not state (fire-and-forget); subscribers re-fetch on re-activation.

---

## 20. Accessibility

- Icons inside `IconButton` must have `tooltip` (semantic label) or be wrapped in `Semantics(label: ...)`.
- All inputs labelled (`labelText` / `hintText`). Dialogs/sheets trap focus via `Navigator` — no custom overlay frameworks.
- Touch targets **≥ 48 × 48 dp** (wrap raw `GestureDetector`/`InkWell` in `ConstrainedBox(constraints: BoxConstraints(minWidth: 48, minHeight: 48))` or use `IconButton`/Material buttons).
- Contrast meets WCAG AA (4.5:1 text / 3:1 UI) using `lib/core/theme/app_colors.dart` — no custom colours outside `AppColors`.
- RTL: `EdgeInsetsDirectional` / `AlignmentDirectional` / `PositionedDirectional` only. `CustomPaint` reads `Directionality.of(context)` and flips geometry when RTL.
- Don't hard-code `fontSize` outside `lib/core/theme/app_typography.dart`; use `AppTypography.*` or `Theme.of(context).textTheme.*`; honour `MediaQuery.textScalerOf`.

---

## 21. HTTP Caching & Deduplication

- **Cache** data that is frequently read, rarely mutated, and shared (genre lists, TMDB image configuration, user profile) in a `@lazySingleton` repository property. Clear explicitly after mutation (don't rely on TTL for transactional data like watchlist/favorites).
- **Don't cache** paginated/filtered search lists, data being edited, or POST/PATCH/DELETE responses.
- **Dedup**: if the same GET request can fire concurrently, guard it in the repository with an in-flight `Future` cache. No global Dio cache plugin.

---

## 22. Dead Code & Module Boundaries

- Run `dart format --output=none --set-exit-if-changed .` + `flutter analyze --no-fatal-infos` before every commit. Remove unused imports and dead symbols on sight (never comment them out).
- **Boundaries**: `lib/features/<X>` never imports `lib/features/<Y>` directly — communicate via `lib/core/` or DI-injected interfaces. `lib/core/` never imports `lib/features/`.
- **Sanctioned stack**: `flutter_bloc` (Cubit only), `injectable` + `get_it`, `dio` + `retrofit` (+ `json_serializable` when added), `flutter_localizations` + `intl` (`gen-l10n`), `shared_preferences`, `cached_network_image`, `flutter_svg`, `flutter_screenutil`, `google_fonts`, `flutter_test`, `mocktail`, `bloc_test`.
- **Forbidden (PR blocker)**: `freezed`, `dartz`/`fpdart`/any `Either`, `equatable`, `bloc_concurrency`, `reactive_forms`, `provider`, `riverpod`.

---

## 23. Check Before Building

1. Read `docs/01-project-overview.md`.
2. Verify Figma design / feature spec (layout, fields, order, actions, states, copy keys, transitions).
3. Read the feature doc (`docs/13-feature-*.md`) if modifying an existing feature.
4. Read the relevant core/infra doc (`docs/04-theme-and-ui-components.md`, `docs/09-network-layer.md`, etc.).
5. Confirm the endpoint exists in `docs/09-network-layer.md` / backend API spec (else stop & report).
6. Grep for existing UseCase/Mapper/Cubit/widget/validator in `lib/core/` and `lib/features/`.
7. Extend/reuse if it exists (document why).
8. Create new only if extension would break existing contracts (flag the trade-off).

---

## 24. Post-Task Documentation Updates

**Every task ends with a docs update — "code works"/"tests pass" ≠ "done".** For each item that applies, update the matching doc in the same PR:

1. **Feature docs (`docs/13-feature-*.md`)**: touched a feature's Cubit/UseCase/Repo/Mapper/State/Action/widget/sheet → update the relevant sub-section; route added/removed → update screen inventory; cross-feature dep → update both docs; new l10n key → update Localisation section.
2. **Infra docs (`docs/01-*`–`docs/09-*`)**: touched `core/base/`, `routing/`, `theme/`, `l10n/`, `di/`, or `network/` → update the matching doc. New `Errors` subclass → `docs/09-network-layer.md`.
3. **Catalogue (`docs/04-theme-and-ui-components.md`)**: new/modified shared widget in `lib/core/common_ui/` → add/update row with full constructor signature; new asset/font → document in theme/catalogue.
4. **Network (`docs/09-network-layer.md`)**: endpoint added/changed/removed → update endpoint table and DTO/error notes.
5. **Routing**: new route in `lib/core/routing/routes.dart` / `app_router.dart` → document in project overview / feature doc.
6. **DI**: new module or binding → re-run `dart run build_runner build --delete-conflicting-outputs` and commit `lib/core/di/service_locator.config.dart`.
7. **Index (`docs/README.md`)**: new/renamed doc → update TOC and verify no stale cross-references (`grep -rn` / `rg -n` on `docs/`).
8. **Walkthrough (`docs/walkthroughs/`)**: required for every non-trivial task (§3) + add entry to `docs/walkthroughs/README.md`.

Verify before commit:

```sh
git status docs/   # expect changes matching the task
git diff docs/
```

If `git status docs/` shows no changes after a code change, stop and verify whether a docs update was missed (default: it was).

---

## 25. Code Generation Hygiene (`build_runner` & `gen-l10n`)

Generated files are **committed** (fresh checkouts compile without running generators; reviewers see generated diffs).

| Source | Output | Purpose |
| :--- | :--- | :--- |
| `@JsonSerializable` | `*.g.dart` | DTO `fromJson`/`toJson` |
| `@RestApi` | `*.g.dart` | Feature Retrofit clients (`*_remote_data_source.g.dart`) |
| `@injectable` / `@module` | `lib/core/di/service_locator.config.dart` | DI graph |
| `lib/core/l10n/*.arb` (`l10n.yaml`) | `lib/core/l10n/app_localizations*.dart` | Translation accessors |

- `freezed` is **not** in the toolchain. Never hand-edit generated files.
- After annotation changes, run: `dart run build_runner build --delete-conflicting-outputs`.
- After ARB translation changes, run: `flutter gen-l10n` (commit both ARB source + generated Dart files in the same commit).
- `.dart_tool/` stays gitignored. Split enormous major-version regen diffs into a dedicated `chore` commit.

---

## 26. Build Flavors & Entrypoints

- Current entrypoint: `lib/main.dart` (`MoviesApp`, dark theme, `initServiceLocator()`).
- If build flavors (`dev` / `staging` / `prod`) are introduced later:
  - Keep a single source of truth (`flavorizr.yaml` or per-flavor entrypoints `main_dev.dart`, `main_staging.dart`, `main_prod.dart`), with `.env.<flavor>` gitignored and wired via `AppEnvironment`.
  - Document any added flavor configuration in `docs/01-project-overview.md`.

---

## 27. Platform Channels & Native Interop

For capabilities not available in pure Dart/plugins, use `MethodChannel`/`EventChannel` behind an abstract interface:
- `lib/core/platform/<name>_platform.dart` (abstract) + `<name>_platform_method_channel.dart`.
- Channel names namespaced cleanly (e.g. `com.moviesapp/<feature>`) as a `const` in the abstract class, never inline. Method names as `camelCase` `const`s on both sides.
- Arguments use plain serialisable `Map<String, dynamic>` (no `freezed`). `PlatformException` caught and converted to an `Errors` subclass, surfaced via `Future<ApiResult<T>>`.
- Test platform interfaces via a `mocktail` mock or fake implementation.

---

## Quick Reference — Mandatory Actions Per Task

All task types require **Plan & Approval**, a **Commit**, a **Walkthrough**, and a **Docs Update**.

| Task | Theme+a11y | API | Catalogue (`docs/04`) | Shimmer | Optimistic | Codegen | Tests |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| New feature/screen | ✅ | ✅ | ✅ Update if shared | ✅ | if mutating | DI + routes | ≥70 % |
| New shared widget | ✅ | if used | ✅ Add row | if fetching | if mutating | — | ✅ |
| Modified widget | ✅ | if changed | ✅ Update row | if fetching | if mutating | — | Regression |
| New UseCase/Mapper | — | if new endpoint | — | — | — | `injectable` | ≥70 % |
| New form | ✅ | ✅ | ✅ if shared UI | if fetching | if safe | — | ≥70 % |
| New endpoint | — | ✅ `docs/09` | — | — | — | Retrofit + JSON | Unit/Repo |
| New route | — | — | — | — | — | — | ✅ |
| New DI binding/module | — | — | — | — | — | `injectable` | ✅ |
| New translation key | — | — | — | — | — | `flutter gen-l10n` | — |
| New platform channel | — | — | — | — | — | — | ✅ Mock |
| Bug fix | if UI | if API | if changed | if affected | if affected | if source ann. | Regression |
| Refactor | if UI | if API surface | if changed | if affected | if affected | if source ann. | ≥70 % |
| New shared utility | — | — | — | — | — | — | ≥70 % |
| Native Android/iOS | if UI | — | if affected | — | — | — | ✅ |
| Secret/env change | — | — | — | — | — | — | — |
| Question → change | if UI | if API | if changed | if affected | if affected | if source ann. | if code changed |
