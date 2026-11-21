import 'api_result.dart';
import 'error_parser.dart';

Future<ApiResult<T>> safeCall<T extends Object?>(
  Future<T> Function() call,
) async {
  try {
    final response = await call();
    return Success<T>(response);
  } catch (error) {
    return ErrorParser.parse<T>(error);
  }
}
