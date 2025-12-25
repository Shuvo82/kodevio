class ApiResponse<T> {
  final String status;
  final String? message;
  final T? data;
  final dynamic errors; // Can be Map, List, String, number, etc.

  ApiResponse({required this.status, this.message, this.data, this.errors});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    // Handle both 'status' and 'success' fields
    String status = json['status'] ?? "";
    if (status.isEmpty && json['success'] != null) {
      status = json['success'] == true ? "success" : "error";
    }

    // Handle data extraction
    T? data;
    if (fromJsonT != null) {
      if (json['data'] != null) {
        // Standard format: data is nested under 'data' key
        data = fromJsonT(json['data']);
      } else if (status == "success" && json.length > 1) {
        // Root-level data format: data is at root level (e.g., {success: true, available_days: 7, ...})
        // Exclude status-like fields from being treated as data
        final excludedKeys = {'status', 'success', 'message', 'errors'};
        final hasDataFields =
            json.keys.any((key) => !excludedKeys.contains(key));
        if (hasDataFields) {
          data = fromJsonT(json);
        }
      } else if (status.isEmpty && json.isNotEmpty) {
        // DummyJSON format: no status/success field, data is at root level
        // Check if it looks like actual data (has meaningful fields)
        final excludedKeys = {'status', 'success', 'message', 'errors'};
        final hasDataFields =
            json.keys.any((key) => !excludedKeys.contains(key));
        if (hasDataFields) {
          data = fromJsonT(json);
          status = "success"; // Assume success if we got data
        }
      }
    }

    return ApiResponse<T>(
      status: status,
      message: json['message'],
      data: data,
      errors: json['errors'],
    );
  }
}
