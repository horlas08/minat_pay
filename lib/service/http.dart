import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dio = Dio(); // With default `Options`.

Dio dio2 = Dio();
void configureDio() {
  // Set default configs
  dio.options.baseUrl = apiUrl;
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.contentType = Headers.jsonContentType;
  dio.options.headers = {Headers.acceptHeader: Headers.jsonContentType};
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      }));
  // dio.interceptors.add(RetryInterceptor(
  //   dio: dio,
  //   logPrint: print, // specify log function (optional)// retry count (optional)
  //   retryDelays: const [
  //     // set delays between retries (optional)
  //     // Duration(seconds: 1), // wait 1 sec before first retry
  //     // Duration(seconds: 2), // wait 2 sec before second retry
  //     // Duration(seconds: 3), // wait 3 sec before third retry
  //   ],
  // ));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        print(AppBloc().state.user?.toString());
        // Do something before request is sent.
        // If you want to resolve the request with custom data,
        // you can resolve a `Response` using `handler.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject with a `DioException` using `handler.reject(dioError)`.
        print(options.baseUrl);
        // print(options.data);

        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
        // print(response.data);
        if (response.data == '') {
          throw Exception('Internet Issue');
        }
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Do something with response error.
        // If you want to resolve the request with some custom data,
        // you can resolve a `Response` object using `handler.resolve(response)`.

        return handler.next(error);
      },
    ),
  );

  final options = BaseOptions(
    baseUrl: 'https://api.minatpay.com',
    connectTimeout: const Duration(seconds: 18),
    receiveTimeout: const Duration(seconds: 15),
  );
  dio2 = Dio(options);
  dio2.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      }));
  // dio2.interceptors.add(RetryInterceptor(
  //   dio: dio,
  //   logPrint: print, // specify log function (optional)
  //   retries: 1,
  //   // retry count (optional)
  //   retryDelays: const [
  //     // set delays between retries (optional)
  //     // Duration(seconds: 1), // wait 1 sec before first retry
  //     // Duration(seconds: 2), // wait 2 sec before second retry
  //     // Duration(seconds: 3), // wait 3 sec before third retry
  //   ],
  // ));
  dio2.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // print("_______");
        // print(AppBloc().state.user?.toString());
        // Do something before request is sent.
        // If you want to resolve the request with custom data,
        // you can resolve a `Response` using `handler.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject with a `DioException` using `handler.reject(dioError)`.
        print(options.baseUrl);
        print(options.data);

        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
        // print(response.data);
        if (response.data == '') {
          throw Exception('Internet Issue');
        }
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Do something with response error.
        // If you want to resolve the request with some custom data,
        // you can resolve a `Response` object using `handler.resolve(response)`.

        return handler.next(error);
      },
    ),
  );
}
