import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _navigateAfterDelay();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.splashAnimationDuration),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    ));

    animationController.forward();
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

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}