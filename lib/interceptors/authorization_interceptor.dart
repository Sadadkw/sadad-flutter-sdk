import 'package:dio/dio.dart';

class AuthorizationInterceptor extends Interceptor {
 
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}
