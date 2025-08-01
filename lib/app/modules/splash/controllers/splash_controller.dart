import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: AppConstants.splashDuration), () {
      _checkNavigationRoute();
    });
  }

  void _checkNavigationRoute() {
    // Check if user has seen onboarding
    if (!_storageService.hasSeenOnboarding()) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    // Check if user is logged in
    if (_authService.isLoggedIn) {
      Get.offAllNamed(Routes.carriers);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}