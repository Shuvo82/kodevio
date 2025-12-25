import 'package:get/get.dart';
import '../models/users_res_model.dart';

class UserDetailsController extends GetxController {
  final Rx<UsersResModel?> user = Rx<UsersResModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Get user from arguments
    if (Get.arguments != null && Get.arguments is UsersResModel) {
      user.value = Get.arguments as UsersResModel;
    }
  }

  String get fullAddress {
    final address = user.value?.address;
    if (address == null) return 'N/A';
    return '${address.suite ?? ''}, ${address.street ?? ''}\n${address.city ?? ''} - ${address.zipcode ?? ''}';
  }
}
