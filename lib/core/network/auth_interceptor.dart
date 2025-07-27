import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // added this condition to check for our custom flag
    // if true just pass request along without adding login token
    if (options.extra['skipAuthInterceptor'] == true) {
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }
}
