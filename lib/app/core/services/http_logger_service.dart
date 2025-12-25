import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'dart:convert';

class HttpLog {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;
  final int? statusCode;
  final Map<String, dynamic>? responseHeaders;
  final dynamic responseBody;
  final String? error;
  final Duration? duration;

  HttpLog({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    this.requestHeaders,
    this.requestBody,
    this.statusCode,
    this.responseHeaders,
    this.responseBody,
    this.error,
    this.duration,
  });

  String get statusDisplay {
    if (error != null) return 'ERROR';
    if (statusCode == null) return 'PENDING';
    return statusCode.toString();
  }

  String get methodDisplay => method.toUpperCase();

  String get timeDisplay {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String get durationDisplay {
    if (duration == null) return '-';
    if (duration!.inMilliseconds < 1000) {
      return '${duration!.inMilliseconds}ms';
    }
    return '${(duration!.inMilliseconds / 1000).toStringAsFixed(2)}s';
  }
}

class HttpLoggerService extends GetxService {
  static HttpLoggerService get to => Get.find<HttpLoggerService>();

  final RxList<HttpLog> _logs = <HttpLog>[].obs;
  final Map<String, HttpLog> _pendingLogs = {};
  final int maxLogs = 100; // Keep last 100 logs

  List<HttpLog> get logs => _logs.reversed.toList(); // Latest first

  void logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final log = HttpLog(
      id: id,
      timestamp: DateTime.now(),
      method: options.method,
      url: '${options.baseUrl}${options.path}',
      requestHeaders: options.headers.cast<String, dynamic>(),
      requestBody: options.data,
    );

    _pendingLogs[id] = log;
    _addLog(log);
  }

  void logResponse(Response response, Duration duration) {
    if (!kDebugMode) return;

    final id = _findPendingLogId(response.requestOptions);
    if (id == null) return;

    final existingLog = _pendingLogs[id];
    if (existingLog == null) return;

    final updatedLog = HttpLog(
      id: id,
      timestamp: existingLog.timestamp,
      method: existingLog.method,
      url: existingLog.url,
      requestHeaders: existingLog.requestHeaders,
      requestBody: existingLog.requestBody,
      statusCode: response.statusCode,
      responseHeaders: response.headers.map.cast<String, dynamic>(),
      responseBody: response.data,
      duration: duration,
    );

    _updateLog(id, updatedLog);
    _pendingLogs.remove(id);
  }

  void logError(DioException error, Duration duration) {
    if (!kDebugMode) return;

    final id = _findPendingLogId(error.requestOptions);
    if (id == null) return;

    final existingLog = _pendingLogs[id];
    if (existingLog == null) return;

    final updatedLog = HttpLog(
      id: id,
      timestamp: existingLog.timestamp,
      method: existingLog.method,
      url: existingLog.url,
      requestHeaders: existingLog.requestHeaders,
      requestBody: existingLog.requestBody,
      statusCode: error.response?.statusCode,
      responseHeaders: error.response?.headers.map.cast<String, dynamic>(),
      responseBody: error.response?.data,
      error: error.message ?? 'Unknown error',
      duration: duration,
    );

    _updateLog(id, updatedLog);
    _pendingLogs.remove(id);
  }

  String? _findPendingLogId(RequestOptions options) {
    final url = '${options.baseUrl}${options.path}';
    final method = options.method;

    // Find matching pending log (most recent)
    final entries = _pendingLogs.entries.toList()
      ..sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));

    for (final entry in entries) {
      if (entry.value.url == url && entry.value.method == method) {
        return entry.key;
      }
    }

    return null;
  }

  void _addLog(HttpLog log) {
    _logs.add(log);

    // Keep only last maxLogs
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }
  }

  void _updateLog(String id, HttpLog updatedLog) {
    final index = _logs.indexWhere((log) => log.id == id);
    if (index != -1) {
      _logs[index] = updatedLog;
    }
  }

  void clearLogs() {
    _logs.clear();
    _pendingLogs.clear();
  }

  String formatJson(dynamic json) {
    try {
      if (json == null) return 'null';
      if (json is String) {
        try {
          final decoded = jsonDecode(json);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (_) {
          return json;
        }
      }
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }
}

