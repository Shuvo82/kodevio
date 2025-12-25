import 'package:get/get.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/api_url.dart';
import '../../../core/common/widgets/ui.dart';
import '../models/users_res_model.dart';

class UsersRepository {
  final ApiService _apiService = Get.find<ApiService>();

  /// Fetch users from API
  Future<List<UsersResModel>> fetchUsers() async {
    try {
      Ui.logInfo('🌐 Fetching users from API...');

      final result = await _apiService.getList<List<UsersResModel>>(
        ApiUrl.getUsersUrl,
        fromJsonT: (json) =>
            (json as List).map((item) => UsersResModel.fromJson(item)).toList(),
      );

      if (result.isSuccess) {
        final data = result.data!;
        Ui.logSuccess('✅ Fetched ${data.length} users');
        return data;
      } else {
        Ui.logError('❌ API error: ${result.failure?.message}');
        throw Exception(result.failure?.message ?? 'Failed to fetch users');
      }
    } catch (e) {
      Ui.logError('❌ Error fetching users: $e');
      rethrow;
    }
  }
}
