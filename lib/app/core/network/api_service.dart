import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common/widgets/ui.dart';
import '../services/http_logger_service.dart';
import 'failures.dart';
import 'result.dart';
import 'api_url.dart';
import 'api_response.dart';

/// Dio-based API Service
///
/// This service handles all HTTP requests using Dio package.
/// Benefits over plain HTTP:
/// - Interceptors for automatic auth token injection
/// - Better error handling with typed failures
/// - Request/Response logging
/// - File upload support
/// - Timeout handling
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

  /// 🔧 Setup Interceptors
  ///
  /// Interceptors run before/after every request:
  /// 1. onRequest: Adds auth token, logs request
  /// 2. onResponse: Logs successful response
  /// 3. onError: Logs errors, handles 401 (logout)
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

  /// 📤 Upload Multiple Files (Multipart)
  ///
  /// Example usage:
  /// ```dart
  /// final files = [File('/path/to/image1.jpg'), File('/path/to/image2.jpg')];
  /// final result = await apiService.uploadMultipleFiles(
  ///   '/upload',
  ///   files: files,
  ///   fileFieldName: 'files[]',
  ///   additionalData: {'title': 'My Photos', 'description': 'Vacation pics'},
  /// );
  /// ```
  Future<Result<ApiResponse<T>>> uploadMultipleFiles<T>(
    String endpoint, {
    required List<File> files,
    String fileFieldName = 'files[]',
    Map<String, String>? additionalData,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final formData = FormData();

      // Add additional text fields
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
      }

      // Add files
      for (var file in files) {
        String fileName = file.path.split("/").last;

        // Detect MIME type from file extension
        String? mimeType = _getMimeType(fileName);

        formData.files.add(
          MapEntry(
            fileFieldName,
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );
      }

      Ui.logInfo('📤 Uploading ${files.length} files to $endpoint');

      final response = await _dio.post(endpoint, data: formData);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Upload error: $e'));
    }
  }

  /// 📤 Upload Single File (Multipart)
  ///
  /// Example usage:
  /// ```dart
  /// final file = File('/path/to/profile.jpg');
  /// final result = await apiService.uploadSingleFile(
  ///   '/profile/upload',
  ///   file: file,
  ///   fileFieldName: 'image',
  ///   additionalData: {'user_id': '123'},
  /// );
  /// ```
  Future<Result<ApiResponse<T>>> uploadSingleFile<T>(
    String endpoint, {
    required File file,
    String fileFieldName = 'image',
    Map<String, String>? additionalData,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final formData = FormData();

      // Add additional text fields
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
      }

      // Add single file
      String fileName = file.path.split("/").last;
      String? mimeType = _getMimeType(fileName);

      formData.files.add(
        MapEntry(
          fileFieldName,
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        ),
      );

      Ui.logInfo('📤 Uploading file: $fileName to $endpoint');

      final response = await _dio.post(endpoint, data: formData);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Upload error: $e'));
    }
  }

  /// 🎯 Flexible Multipart Request (Most Powerful!)
  ///
  /// This is the MOST FLEXIBLE method for multipart requests.
  /// You can:
  /// - Send only fields (no files)
  /// - Send only files (no fields)
  /// - Send any combination of fields and files
  /// - Add multiple files with different field names
  ///
  /// Example 1: Only fields (no images)
  /// ```dart
  /// final result = await apiService.multipartRequest(
  ///   '/api/update-profile',
  ///   fields: {
  ///     'name': 'John Doe',
  ///     'email': 'john@example.com',
  ///     'phone': '1234567890',
  ///   },
  /// );
  /// ```
  ///
  /// Example 2: Fields + Single Image
  /// ```dart
  /// final result = await apiService.multipartRequest(
  ///   '/api/create-product',
  ///   fields: {
  ///     'name': 'Product Name',
  ///     'price': '99.99',
  ///     'category': 'Electronics',
  ///   },
  ///   files: {
  ///     'image': [File('/path/to/product.jpg')],
  ///   },
  /// );
  /// ```
  ///
  /// Example 3: Fields + Multiple Images with Different Field Names
  /// ```dart
  /// final result = await apiService.multipartRequest(
  ///   '/api/create-listing',
  ///   fields: {
  ///     'title': 'House for Sale',
  ///     'description': 'Beautiful house',
  ///   },
  ///   files: {
  ///     'thumbnail': [File('/path/to/thumbnail.jpg')],
  ///     'gallery[]': [
  ///       File('/path/to/image1.jpg'),
  ///       File('/path/to/image2.jpg'),
  ///       File('/path/to/image3.jpg'),
  ///     ],
  ///     'document': [File('/path/to/deed.pdf')],
  ///   },
  /// );
  /// ```
  ///
  /// Example 4: Only Images (no fields)
  /// ```dart
  /// final result = await apiService.multipartRequest(
  ///   '/api/upload-photos',
  ///   files: {
  ///     'photos[]': [
  ///       File('/path/to/photo1.jpg'),
  ///       File('/path/to/photo2.jpg'),
  ///     ],
  ///   },
  /// );
  /// ```
  Future<Result<ApiResponse<T>>> multipartRequest<T>(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, List<File>>? files,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final formData = FormData();

      // Add all text fields
      if (fields != null) {
        fields.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
        Ui.logInfo('📝 Adding ${fields.length} fields to multipart request');
      }

      // Add all files
      if (files != null && files.isNotEmpty) {
        int totalFiles = 0;
        for (var entry in files.entries) {
          String fieldName = entry.key;
          List<File> fileList = entry.value;

          for (var file in fileList) {
            String fileName = file.path.split("/").last;
            String? mimeType = _getMimeType(fileName);

            formData.files.add(
              MapEntry(
                fieldName,
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: mimeType != null
                      ? MediaType.parse(mimeType)
                      : null,
                ),
              ),
            );
            totalFiles++;
          }
        }
        Ui.logInfo('📤 Adding $totalFiles files to multipart request');
      }

      Ui.logInfo('🚀 Sending multipart request to $endpoint');

      final response = await _dio.post(endpoint, data: formData);
      final apiResponse = ApiResponse.fromJson(response.data, fromJsonT);
      return Success(apiResponse);
    } on DioException catch (e) {
      return ResultFailure(_handleDioError(e));
    } catch (e) {
      return ResultFailure(ServerFailure('Multipart request error: $e'));
    }
  }

  /// 🔧 Helper: Get MIME type from file extension
  String? _getMimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'json':
        return 'application/json';
      case 'xml':
        return 'application/xml';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return null;
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
