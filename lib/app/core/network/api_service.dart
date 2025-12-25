import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/http_logger_service.dart';
import 'failures.dart';
import 'result.dart';
import 'api_url.dart';
import 'api_response.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );

  final HttpLoggerService _httpLogger = Get.find<HttpLoggerService>();

  ApiService() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Add Pretty Dio Logger interceptor (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // Add custom interceptor for auth and HTTP logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final startTime = DateTime.now();
          options.extra['start_time'] = startTime;

          // Log request to in-app inspector
          _httpLogger.logRequest(options);

          handler.next(options);
        },
        onResponse: (response, handler) async {
          // Calculate duration
          final startTime =
              response.requestOptions.extra['start_time'] as DateTime?;
          final duration = startTime != null
              ? DateTime.now().difference(startTime)
              : Duration.zero;

          // Log response to in-app inspector
          _httpLogger.logResponse(response, duration);

          handler.next(response);
        },
        onError: (error, handler) async {
          // Calculate duration
          final startTime =
              error.requestOptions.extra['start_time'] as DateTime?;
          final duration = startTime != null
              ? DateTime.now().difference(startTime)
              : Duration.zero;

          // Log error to in-app inspector
          _httpLogger.logError(error, duration);

          handler.next(error);
        },
      ),
    );
  }

  Future<Result<ApiResponse<T>>> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: query);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Unexpected error: $e'));
    }
  }

  /// GET request for APIs that return PLAIN ARRAYS (no wrapper object)
  ///
  /// Use this when the API returns: `[{...}, {...}]` instead of `{data: [{...}]}`
  ///
  /// Example:
  /// ```dart
  /// // FakeStoreAPI returns plain array: [{id: 1, title: "..."}, {id: 2, ...}]
  /// final result = await apiService.getList<List<ProductModel>>(
  ///   'https://fakestoreapi.com/products',
  ///   fromJsonT: (json) => (json as List)
  ///       .map((item) => ProductModel.fromJson(item))
  ///       .toList(),
  /// );
  /// ```
  Future<Result<T>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    required T Function(dynamic json) fromJsonT,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: query);

      // Response is a plain array, parse it directly
      final data = fromJsonT(response.data);
      return Success(data);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Result<ApiResponse<T>>> post<T>(
    String endpoint,
    dynamic data, {
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Result<ApiResponse<T>>> put<T>(
    String endpoint,
    dynamic data, {
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Result<ApiResponse<T>>> delete<T>(
    String endpoint, {
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Unexpected error: $e'));
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        // Handle different HTTP status codes
        switch (statusCode) {
          case 400:
            // Bad Request - usually validation errors
            String message = 'Validation failed';
            if (responseData is Map<String, dynamic>) {
              // Try to extract message from response
              if (responseData['errors'] != null) {
                // Handle validation errors array or object
                final errors = responseData['errors'];
                if (errors is List) {
                  // Join all error messages from array
                  message = errors.map((e) => e.toString()).join('\n');
                } else if (errors is Map<String, dynamic>) {
                  message = errors.values.map((e) => e.toString()).join('\n');
                } else {
                  message = errors.toString();
                }
              } else if (responseData['message'] != null) {
                message = responseData['message'].toString();
              } else if (responseData['error'] != null) {
                message = responseData['error'].toString();
              }
            }
            return ValidationFailure(message);
          case 401:
            // Unauthorized
            return const ValidationFailure('Unauthorized access');
          case 403:
            // Forbidden
            return const ValidationFailure('Access forbidden');
          case 404:
            // Not Found
            return const ValidationFailure('Resource not found');
          case 422:
            // Unprocessable Entity - validation errors
            String message = 'Validation failed';
            if (responseData is Map<String, dynamic>) {
              if (responseData['errors'] != null) {
                // Handle validation errors array or object
                final errors = responseData['errors'];
                if (errors is List) {
                  // Join all error messages from array
                  message = errors.map((e) => e.toString()).join('\n');
                } else if (errors is Map<String, dynamic>) {
                  message = errors.values.map((e) => e.toString()).join('\n');
                } else {
                  message = errors.toString();
                }
              } else if (responseData['message'] != null) {
                message = responseData['message'].toString();
              }
            }
            return ValidationFailure(message);
          case 500:
          case 502:
          case 503:
          case 504:
            // Server errors
            return ServerFailure('Server error: $statusCode');
          default:
            return ServerFailure('HTTP error: $statusCode');
        }
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      default:
        return ServerFailure('Network error: ${error.message}');
    }
  }
}
