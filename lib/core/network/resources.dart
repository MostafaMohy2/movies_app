import 'errors.dart';

enum Status { initial, loading, success, error }

class Resources<T> {
  final Status status;
  final T? data;
  final Errors? error;
  final String? message;

  const Resources._({
    required this.status,
    this.data,
    this.error,
    this.message,
  });

  const Resources.initial() : this._(status: Status.initial);

  const Resources.loading({T? data})
    : this._(status: Status.loading, data: data);

  const Resources.success({T? data})
    : this._(status: Status.success, data: data);

  const Resources.failure({Errors? exception, String? message, T? data})
    : this._(
        status: Status.error,
        error: exception,
        message: message,
        data: data,
      );

  bool get isInitial => status == Status.initial;
  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isError => status == Status.error;

  Resources<T> copyWith({
    Status? status,
    T? data,
    Errors? error,
    String? message,
  }) {
    return Resources._(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
