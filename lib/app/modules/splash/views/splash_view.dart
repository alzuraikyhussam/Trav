import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(),
              ),
            ),
            
            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.scaleAnimation.value,
                        child: Opacity(
                          opacity: controller.fadeAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackWithOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flight_takeoff,
                              size: 60,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // App Name
                  AnimatedBuilder(
                    animation: controller.fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.fadeAnimation.value,
                        child: const Text(
                          'TravelEase',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Tagline
                  AnimatedBuilder(
                    animation: controller.fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.fadeAnimation.value,
                        child: const Text(
                          'Your Journey Starts Here',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Loading Indicator
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Version
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.whiteWithOpacity(0.1)
      ..strokeWidth = 1;

    // Draw subtle pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        final x = (size.width / 20) * i;
        final y = (size.height / 20) * j;
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}