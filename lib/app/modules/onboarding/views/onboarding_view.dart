import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50),
                  Obx(() => Text(
                    '${controller.currentPage.value + 1} / ${controller.onboardingItems.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )),
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page View
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingItems.length,
                itemBuilder: (context, index) {
                  final item = controller.onboardingItems[index];
                  return _buildOnboardingPage(context, item, index);
                },
              ),
            ),
            
            // Bottom Navigation
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page Indicator
                  Obx(() => SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.onboardingItems.length,
                    effect: WormEffect(
                      dotColor: AppColors.lightGrey,
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 16,
                    ),
                  )),
                  
                  const SizedBox(height: 30),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      // Previous Button
                      Obx(() => controller.currentPage.value > 0
                          ? Expanded(
                              child: OutlinedButton(
                                onPressed: controller.previousPage,
                                child: const Text('Previous'),
                              ),
                            )
                          : const Expanded(child: SizedBox())),
                      
                      const SizedBox(width: 16),
                      
                      // Next/Get Started Button
                      Expanded(
                        flex: 2,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.nextPage,
                          child: Text(
                            controller.isLastPage.value
                                ? 'Get Started'
                                : 'Next',
                          ),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, OnboardingItem item, int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: item.color.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    item.image,
                    size: 80,
                    color: item.color,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 50),
          
          // Title
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Description
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}