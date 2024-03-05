library sadadpay;

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:sadadpay_flutter/interceptors/authorization_interceptor.dart';
import 'package:sadadpay_flutter/config/env.dart';
import 'package:sadadpay_flutter/service/sadad_service.dart';

class SadadPay extends SadadService {
  late final Dio _dio;

  SadadPay({Environment? env}) {
    setEnv(env: env);
    _dio = Dio()
      ..options.baseUrl = apiBaseUrl
      ..interceptors.add(AuthorizationInterceptor());
  }

  @override
  Future<dynamic> generateRefreshToken(
      {required final String clientKey,
      required final String clientSecret}) async {
    final basic = "$clientKey:$clientSecret";
    final encoded = base64Encode((utf8.encode(basic)));
    String basicAuth = 'Basic $encoded';
    _dio.options.headers['Authorization'] = basicAuth;
    try {
      final response = await _dio.post('/User/GenerateRefreshToken');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response.toString();
      } else {
        throw e.message.toString();
      }
    }
  }

  @override
  Future<dynamic> generateAccessToken(
      {required final String refreshToken}) async {
    _dio.options.headers['Authorization'] = 'Bearer $refreshToken';
    try {
      final response = await _dio.post('/User/GenerateAccessToken');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response.toString();
      } else {
        throw e.message.toString();
      }
    }
  }

  @override
  Future<dynamic> createInvoice(
      {required final invoices, required final token}) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await _dio.post('/Invoice/insert', data: invoices);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        throw e.message.toString();
      }
    }
  }

  @override
  Future<dynamic> getInvoice(
      {required final String invoiceId, required final token}) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.queryParameters['id'] = invoiceId;

    try {
      final response = await _dio.get('/Invoice/getbyid');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        throw e.message.toString();
      }
    }
  }
}