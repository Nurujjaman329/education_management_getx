// import 'package:dio/dio.dart';
// import 'package:edex_365_getx/core/config/app.dart';
// import 'package:flutter/foundation.dart'; // for kDebugMode


// import '../../main.dart';

// class HttpManager {
//   static String _token = '';

//   /// Getter and setter for the token
//   static set token(String value) => _token = value;
//   static String get token => _token;

//   final Dio _dio;

//   /// You can pass a different baseUrl optionally
//   HttpManager({String? baseUrl})
//       : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? EdexAppConfig.apiBase)) {
//     _dio.options.validateStatus = (status) {
//       return status != null && status < 500;
//     };

//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Content-Type headers
//         if (options.data is FormData) {
//           options.contentType = Headers.multipartFormDataContentType;
//         } else {
//           options.headers['Content-Type'] = "application/json";
//         }

//         // Set Authorization header
//         if (_token.isNotEmpty) {
//           options.headers["Authorization"] = "Bearer $_token";
//         }

//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         handler.next(response);
//       },
//       onError: (DioException error, handler) {
//         if (error.response?.statusCode == 401) {
//           // Force logout or navigate to login
//           navigatorKey.currentState?.pushNamedAndRemoveUntil(
//             AppRoutes.signIn,
//             (route) => false,
//           );
//         }
//         handler.next(error);
//       },
//     ));

//     // Add debug logger
//     if (kDebugMode) {
//       _dio.interceptors.add(LogInterceptor(
//         request: true,
//         requestBody: true,
//         responseBody: true,
//         error: true,
//       ));
//     }
//   }

//   /// Use this to access Dio client
//   Dio get client => _dio;
// }
