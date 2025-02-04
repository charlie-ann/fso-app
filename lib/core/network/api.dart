import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:fso_support/core/config/env/env.dart';

import '../storage/storage.dart';

class Api {
  late Dio dio;

  Api() {
    dio = Dio(
      BaseOptions(
        baseUrl: Environment.getConfig.baseUrl,
        receiveTimeout: const Duration(seconds: 40),
        connectTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "platform": Platform.isAndroid ? "android" : "ios",
          // "mock": true,
        },
      ),
    );

    dio.interceptors.addAll({AppInterceptors(dio: dio)});
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;

  String? token;

  final storage = StorageImpl();

  AppInterceptors({
    required this.dio,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(err.response?.statusMessage.toString());
      print(err.response?.statusCode.toString());
      print(err.response?.toString());
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        throw ConnectTimeoutException(err.requestOptions);
      case DioExceptionType.sendTimeout:
        throw ConnectTimeoutException(err.requestOptions);
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(
                res: err.response, requestOptions: err.requestOptions);
          case 401:
            throw UnauthorizedException(
                res: err.response, requestOptions: err.requestOptions);
          case 403:
            throw NotVerifiedException(
                res: err.response, requestOptions: err.requestOptions);
          case 404:
            throw NotFoundException(
                res: err.response, requestOptions: err.requestOptions);
          case 409:
            throw ConflictException(
                res: err.response, requestOptions: err.requestOptions);
          case 422:
            throw UnprocessableException(
                res: err.response, requestOptions: err.requestOptions);
          case 500:
            throw InternalServerErrorException(
                res: err.response, requestOptions: err.requestOptions);
          case 502:
            throw InternalServerErrorException(
                res: err.response, requestOptions: err.requestOptions);
          default:
            throw UnknownException(
                res: err.response, requestOptions: err.requestOptions);
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
      case DioExceptionType.badCertificate:
        throw InternalServerErrorException(
            res: err.response, requestOptions: err.requestOptions);
      case DioExceptionType.connectionError:
        throw ConnectTimeoutException(err.requestOptions);
    }
    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    token = await storage.getToken();
    if (token != null && token != "") {
      options.headers.addAll({'Authorization': "Bearer $token"});
    }
    log("Header :::: ${options.headers}");
    log("Data :::: ${options.data}");
    log("query params ${options.queryParameters}");
    log(options.path);
    log(options.baseUrl);
    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    log(response.statusCode.toString());
    return handler.next(response);
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'The connection to the internet has been lost.\nPlease try again';
  }
}

class UnknownException extends DioException {
  Response? res;

  UnknownException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return res?.data?['message'].toString() ??
        res?.data?['error'].toString() ??
        'Something went wrong.\nPlease try again.';
  }
}

class InternalServerErrorException extends DioException {
  Response? res;

  InternalServerErrorException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return 'Something went wrong.\nPlease try again.';
  }
}

class ConflictException extends DioException {
  Response? res;

  ConflictException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return res?.data?['message'].toString() ??
        'Something went wrong.\nPlease try again.';
  }
}

class UnprocessableException extends DioException {
  Response? res;

  UnprocessableException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    log("herrrr");
    return res?.data?['errors']?['email']?[0] ??
        res?.data?['message'].toString() ??
        'Something went wrong.\nPlease try again.';
  }
}

class NotFoundException extends DioException {
  Response? res;

  NotFoundException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return 'Something went wrong.\nPlease try again.';
  }
}

class UnauthorizedException extends DioException {
  Response? res;

  UnauthorizedException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return res?.data?['message'].toString() ??
        'Something went wrong.\nPlease try again.';
  }
}

class NotVerifiedException extends DioException {
  Response? res;

  NotVerifiedException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return res?.data?['message'] == null
        ? 'Something went wrong.\nPlease try again.'
        : "${res?.data?['message'].toString()}, please verify.";
  }
}

class BadRequestException extends DioException {
  Response? res;

  BadRequestException({this.res, required super.requestOptions})
      : super(response: res);
  @override
  String toString() {
    return res?.data?['message'].toString() ??
        'Something went wrong.\nPlease try again.';
  }
}

class ConnectTimeoutException extends DioException {
  ConnectTimeoutException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'Connection timeout';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);
  @override
  String toString() {
    return 'The connection has timed out.\nplease try again.';
  }
}
