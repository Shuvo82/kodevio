import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/user_details_controller.dart';
import '../repository/currency_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersRepository>(() => UsersRepository());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class UserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDetailsController>(() => UserDetailsController());
  }
}
