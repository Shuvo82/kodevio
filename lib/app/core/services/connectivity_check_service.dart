import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../common/widgets/ui.dart';

class ConnectivityService extends GetxService {
  ConnectivityService get to => Get.find<ConnectivityService>();
  // Reactive connectivity status
  final RxBool isConnected = true.obs;

  late Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Initialize service
  Future<ConnectivityService> init() async {
    _connectivity = Connectivity();

    // Check initial connection status
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    isConnected.value = results.any(
      (result) => result != ConnectivityResult.none,
    );

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      isConnected.value = results.any(
        (result) => result != ConnectivityResult.none,
      );

      // Show alert when connection is lost
      if (!isConnected.value) {
        _showNoInternetAlert();
      }
    });

    return this;
  }

  // Check internet connection manually
  Future<bool> checkInternetConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    isConnected.value = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (isConnected.value) {
      return true;
    } else {
      _showNoInternetAlert();
      return false;
    }
  }

  // Show no internet alert
  void _showNoInternetAlert() {
    Ui.errorSnackBar(
      message: 'No internet connection. Please check your network settings.',
    );
  }

  // Clean up when service is disposed
  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
