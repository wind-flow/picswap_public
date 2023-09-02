import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:picswap/app/manager/constants.dart';
import 'package:picswap/app/manager/storage/secure_storage.dart';
import 'package:picswap/app/manager/storage/storage_key.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/log.dart';
import 'failure.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint(
        '[REQ] [${options.method}] ${options.uri} ${options.data.toString()} header : ${options.headers}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: AppStorageKeys.accessTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: AppStorageKeys.refreshTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print(
    //     '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} ${response.data.toString()}');
    debugPrint(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    debugPrint(
        '[ERR] [header : ${err.requestOptions.headers} ${err.requestOptions.method}] ${err.requestOptions.uri} ${err.requestOptions.data} ${err.error} ${err.response?.data}');

    final refreshToken =
        await storage.read(key: AppStorageKeys.refreshTokenKey);

    // refreshToken 아예 없으면 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;

    final isPathRefresh =
        err.requestOptions.path == '/api/v1/auth/refresh-token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
            '${AppConstants.baseUrl}/api/v1/auth/refresh-token',
            data: {'refreshToken': refreshToken});

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(
            key: AppStorageKeys.accessTokenKey, value: accessToken.toString());

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        // circular dependency error
        // A, B
        // A -> B
        // B -> A
        // A -> B -> A -> B -> A -> B
        // ump -> dio -> ump -> dio

        Log.d(
            '[ERR] ${e.response?.statusCode} ${e.toString()} ${e.error} ${e.response?.statusCode}');
        debugPrint(
            't : ${e.response}, ${e.response!.data}, ${e.response!.data}');
        if (e.response?.statusCode == 400) {
          final failure = Failure.fromMap(e.response!.data);

          //4102 = invalid token
          //4103 = expired token
          if (failure.code == -4102 || failure.code == -4103) {
            // LogOut
            // ref.read(authProvider.notifier).logout();
          }

          return handler.reject(failure);
        }
        return handler.reject(e);
      } catch (e) {
        rethrow;
      }
    }

    if (err.response?.statusCode == 400) {
      final failure = Failure(
        code: err.response!.data['code'],
        message: err.response!.data['message'],
      );

      //4102 = invalid token
      //4103 = expired token
      if (failure.code == -4102 || failure.code == -4103) {
        // ref.read(authProvider.notifier).logout();
      }

      return handler.reject(failure);
    }

    return handler.reject(err);
  }
}
