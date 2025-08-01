import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/custom_widgets.dart';
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
                  ))
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideX(begin: 0.3, end: 0)
                      .then()
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .shimmer(
                        duration: 2000.ms,
                        color: AppColors.primary.withOpacity(0.3),
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
                  ))
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 30),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      // Previous Button
                      Obx(() => controller.currentPage.value > 0
                          ? Expanded(
                              child: AnimatedSecondaryButton(
                                text: 'Previous',
                                onPressed: controller.previousPage,
                                icon: Icons.arrow_back,
                              )
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .slideX(begin: -0.3, end: 0),
                            )
                          : const Expanded(child: SizedBox())),
                      
                      const SizedBox(width: 16),
                      
                      // Next/Get Started Button
                      Expanded(
                        flex: 2,
                        child: Obx(() => AnimatedPrimaryButton(
                          text: controller.isLastPage.value
                              ? 'Get Started'
                              : 'Next',
                          onPressed: controller.nextPage,
                          icon: controller.isLastPage.value
                              ? Icons.rocket_launch
                              : Icons.arrow_forward,
                        ))
                            .animate()
                            .fadeIn(delay: 800.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
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
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: item.color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              item.image,
              size: 80,
              color: item.color,
            ),
          )
              .animate()
              .scale(
                duration: 800.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0.3, 0.3),
              )
              .fadeIn(duration: 600.ms)
              .then(delay: 300.ms)
              .shake(hz: 1, curve: Curves.easeInOut)
              .then()
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(end: 1.05, duration: 2000.ms),
          
          const SizedBox(height: 50),
          
          // Title
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.3, end: 0)
              .then(delay: 100.ms)
              .shimmer(
                duration: 1200.ms,
                color: item.color.withOpacity(0.3),
              ),
          
          const SizedBox(height: 20),
          
          // Description
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.2, end: 0)
              .then(delay: 500.ms)
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .fadeIn(begin: 0.8, end: 1.0, duration: 3000.ms),
        ],
      ),
    );
  }
}