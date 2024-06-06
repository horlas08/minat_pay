import 'package:dio/dio.dart';
import 'package:minat_pay/config/app.config.dart';

final options = BaseOptions(
  baseUrl: apiUrl,
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
);

// Dio dio = Dio(options);

final dio = Dio(); // With default `Options`.

void configureDio() {
  // Set default configs
  dio.options.baseUrl = apiUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Do something before request is sent.
        // If you want to resolve the request with custom data,
        // you can resolve a `Response` using `handler.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject with a `DioException` using `handler.reject(dioError)`.
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
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
