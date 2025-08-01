import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxBool isLastPage = false.obs;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: 'Find Your Perfect Trip',
      description: 'Discover amazing destinations and comfortable travel options with our extensive network of trusted carriers.',
      image: Icons.search,
      color: const Color(0xFF6C63FF),
    ),
    OnboardingItem(
      title: 'Book with Confidence',
      description: 'Secure booking process with real-time seat selection and instant confirmation for your peace of mind.',
      image: Icons.verified_user,
      color: const Color(0xFF2E86AB),
    ),
    OnboardingItem(
      title: 'Travel Smart',
      description: 'Track your journey, manage bookings, and enjoy a seamless travel experience with our smart features.',
      image: Icons.smart_toy,
      color: const Color(0xFF06D6A0),
    ),
    OnboardingItem(
      title: 'Start Your Journey',
      description: 'Join thousands of happy travelers and discover the world with comfort and convenience.',
      image: Icons.flight_takeoff,
      color: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == onboardingItems.length - 1;
  }

  void nextPage() {
    if (currentPage.value < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await _storageService.setHasSeenOnboarding(true);
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}