// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shareindia_health_camp/core/config/flavor_config.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/presentation/home/user_main_screen.dart';

class DioLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (userToken.isNotEmpty) {
      options.headers.addAll({
        HttpHeaders.contentTypeHeader:
            options.method == 'GET'
                ? 'application/json'
                : 'application/json, application/x-www-form-urlencoded, multipart/form-data, text/plain,application/octet-stream',
        HttpHeaders.authorizationHeader: 'Bearer $userToken',
        HttpHeaders.acceptHeader: "*/*",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": true,
        'X-Requested-With': 'XMLHttpRequest',
        "Access-Control-Allow-Headers":
            "X-Requested-With, Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      });
    }

    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
        "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}",
      );
      print('Headers:');
      options.headers.forEach((k, v) => print('$k: $v'));
      print('queryParameters:');
      options.queryParameters.forEach((k, v) => print('$k: $v'));
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print("--> END ${options.method.toUpperCase()}");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
        "<-- ${response.statusCode} ${(response.requestOptions.baseUrl + response.requestOptions.path)}",
      );
      print('Headers:');
      response.headers.forEach((k, v) => print('$k: $v'));
      print('Response: ${jsonEncode(response.data)}');
      //debugPrint('Response: ${jsonEncode(response.data)}', wrapWidth: 1024);
      print('<-- END HTTP');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
        "<-- ${err.message} ${err.response?.requestOptions.baseUrl}${err.response?.requestOptions.path}",
      );
      print("${err.response?.data}");
      print('<-- End error');
    }
    if (err.response?.statusCode == 401) {
      UserMainScreen.onUnAuthorizedResponse.value = true;
    }
    super.onError(err, handler);
  }
}
