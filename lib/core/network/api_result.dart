import 'errors.dart';

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

extension ApiResultExtensions<T extends Object?> on ApiResult<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };
}
