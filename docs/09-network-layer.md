# Network Layer Reference (`movies_app`)

## 1. Architecture & Components

| Component | File | Responsibility |
| :--- | :--- | :--- |
| `ApiConstants` | `lib/core/network/api_constants.dart` | Base URL (`https://api.themoviedb.org/3/`) and 20s connect/receive/send timeouts |
| `DioClient` | `lib/core/network/dio_client.dart` | Singleton `Dio` instance (`DioClient.client`) bound in `DiModule` with JSON headers and `LogInterceptor` |
| Feature `*RemoteDataSource` | `lib/features/<feature>/data/datasource/remote/` | Feature-scoped Retrofit `@RestApi()` clients receiving injected `Dio` via each feature's DI module |
| `safeCall` | `lib/core/network/safe_call.dart` | Executes async network calls and maps exceptions via `ErrorParser.parse` |
| `ErrorParser` | `lib/core/network/error_parser.dart` | Maps `DioException`, `SocketException`, `TimeoutException`, `FormatException`, and `Object` to `Failure<T>` |
| `Errors` | `lib/core/network/errors.dart` | Sealed error hierarchy (`NetworkError`, `TimeoutError`, `ParseError`, `ServerError`, `LoginRequired`, `JustMessage`, `Unknown`) |
| `ApiResult<T>` | `lib/core/network/api_result.dart` | Sealed data-layer envelope (`Success<T>`, `Failure<T>`) |
| `Resources<T>` | `lib/core/network/resources.dart` | UI state envelope (`Status { initial, loading, success, error }`) |

## 2. Rules

- Repository methods return `Future<ApiResult<T>>` wrapped with `safeCall(...)`.
- Never use a shared monolithic `ApiService`; each feature defines its own `<Feature>RemoteDataSource` (`@RestApi()`) and feature DI `@module`.
- Never call `Dio` directly from Cubits, UseCases, or Views.
- Never hardcode API keys/tokens in `ApiConstants` or `DioClient` (`--dart-define` / `.env` config required).
- Update §3 below whenever an endpoint is added, modified, or removed.

## 3. Endpoint Inventory

| Feature | Method & Path | DataSource | Request / Response DTO | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `auth` | *(pending API spec)* | `AuthRemoteDataSource` | — | Scaffold created; awaiting endpoint confirmation |
