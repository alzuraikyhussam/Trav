import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/custom_widgets.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: AnimatedCard(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(24),
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: controller.loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Back Button
                        Row(
                          children: [
                            AnimatedIconButton(
                              icon: Icons.arrow_back_ios_new,
                              onPressed: () => Get.back(),
                              tooltip: 'Back',
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: -0.3, end: 0),
                            const Spacer(),
                          ],
                        ),
                        
                        const Gap(20),
                        
                        // Logo and Title
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.primaryGradient,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flight_takeoff,
                            size: 40,
                            color: Colors.white,
                          ),
                        )
                            .animate()
                            .scale(
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                              begin: const Offset(0.3, 0.3),
                            )
                            .fadeIn()
                            .then(delay: 200.ms)
                            .shake(hz: 2, curve: Curves.easeInOut),
                        
                        const Gap(24),
                        
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0)
                            .then(delay: 100.ms)
                            .shimmer(duration: 1200.ms, color: AppColors.primary.withOpacity(0.3)),
                        
                        const Gap(8),
                        
                        Text(
                          'Sign in to continue your journey',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                            .animate(delay: 400.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        
                        const Gap(32),
                        
                        // Phone Number Field
                        AnimatedTextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          validator: controller.validatePhone,
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icons.phone,
                        )
                            .animate(delay: 600.ms)
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: -0.3, end: 0),
                        
                        const Gap(20),
                        
                        // Password Field
                        Obx(() => AnimatedTextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          validator: controller.validatePassword,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: AnimatedIconButton(
                            icon: controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onPressed: controller.togglePasswordVisibility,
                            backgroundColor: Colors.transparent,
                            tooltip: controller.isPasswordVisible.value 
                                ? 'Hide Password' 
                                : 'Show Password',
                          ),
                        ))
                            .animate(delay: 800.ms)
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: 0.3, end: 0),
                        
                        const Gap(16),
                        
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Info',
                                'Forgot password feature coming soon!',
                                backgroundColor: AppColors.info,
                                colorText: Colors.white,
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                              .animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              )
                              .shimmer(
                                duration: 2000.ms,
                                color: AppColors.primary.withOpacity(0.3),
                              ),
                        )
                            .animate(delay: 1000.ms)
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: 0.2, end: 0),
                        
                        const Gap(24),
                        
                        // Login Button
                        Obx(() => AnimatedPrimaryButton(
                          text: 'Sign In',
                          onPressed: controller.login,
                          isLoading: controller.isLoading.value,
                          icon: Icons.login,
                        ))
                            .animate(delay: 1200.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        
                        const Gap(20),
                        
                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        )
                            .animate(delay: 1400.ms)
                            .fadeIn(duration: 600.ms)
                            .scaleX(begin: 0, end: 1),
                        
                        const Gap(20),
                        
                        // Social Login Buttons (Demo)
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedSecondaryButton(
                                text: 'Google',
                                icon: Icons.g_mobiledata,
                                onPressed: () {
                                  Get.snackbar(
                                    'Info',
                                    'Google login coming soon!',
                                    backgroundColor: AppColors.info,
                                    colorText: Colors.white,
                                  );
                                },
                                color: AppColors.error,
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: AnimatedSecondaryButton(
                                text: 'Facebook',
                                icon: Icons.facebook,
                                onPressed: () {
                                  Get.snackbar(
                                    'Info',
                                    'Facebook login coming soon!',
                                    backgroundColor: AppColors.info,
                                    colorText: Colors.white,
                                  );
                                },
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        )
                            .animate(delay: 1500.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        
                        const Gap(20),
                        
                        // Register Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.goToRegister,
                                child: Text(
                                  'Sign Up',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                    .animate(
                                      onPlay: (controller) => controller.repeat(reverse: true),
                                    )
                                    .shimmer(
                                      duration: 2000.ms,
                                      color: AppColors.primary.withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                        )
                            .animate(delay: 1600.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}