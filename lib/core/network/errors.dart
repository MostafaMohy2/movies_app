sealed class Errors {
  final String? message;
  const Errors({this.message});
}

class NetworkError extends Errors {
  const NetworkError({super.message});
}

class TimeoutError extends Errors {
  const TimeoutError({super.message});
}

class ParseError extends Errors {
  final Object? cause;
  const ParseError({super.message, this.cause});
}

class ServerError extends Errors {
  final int statusCode;
  final String? code;
  const ServerError({required this.statusCode, this.code, super.message});
}

class LoginRequired extends Errors {
  final bool forceLogout;
  const LoginRequired({this.forceLogout = false, super.message});
}

class JustMessage extends Errors {
  const JustMessage(String message) : super(message: message);
}

class Unknown extends Errors {
  final Object? cause;
  const Unknown({super.message, this.cause});
}
