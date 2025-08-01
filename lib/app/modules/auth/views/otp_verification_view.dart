import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/custom_widgets.dart';
import '../controllers/auth_controller.dart';

class OtpVerificationView extends GetView<AuthController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent.withOpacity(0.1),
              AppColors.primary.withOpacity(0.05),
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
                    key: controller.otpFormKey,
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
                              colors: AppColors.accentGradient,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sms,
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
                            .shake(hz: 2, curve: Curves.easeInOut)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(reverse: true),
                            )
                            .scaleXY(end: 1.05, duration: 2000.ms),
                        
                        const Gap(24),
                        
                        Text(
                          'Verify Phone',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0)
                            .then(delay: 100.ms)
                            .shimmer(duration: 1200.ms, color: AppColors.accent.withOpacity(0.3)),
                        
                        const Gap(8),
                        
                        Obx(() => Text(
                          'Enter the 6-digit code sent to\n${controller.phoneNumber.value}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ))
                            .animate(delay: 400.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        
                        const Gap(32),
                        
                        // OTP Input Field
                        AnimatedTextField(
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          validator: controller.validateOtp,
                          labelText: 'Verification Code',
                          hintText: 'Enter 6-digit code',
                          prefixIcon: Icons.pin,
                          maxLines: 1,
                        )
                            .animate(delay: 600.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(reverse: true),
                            )
                            .shimmer(
                              duration: 3000.ms, 
                              color: AppColors.accent.withOpacity(0.2),
                            ),
                        
                        const Gap(24),
                        
                        // Verify Button
                        Obx(() => AnimatedPrimaryButton(
                          text: 'Verify & Continue',
                          onPressed: controller.verifyOtp,
                          isLoading: controller.isLoading.value,
                          icon: Icons.verified_user,
                          color: AppColors.accent,
                        ))
                            .animate(delay: 800.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        
                        const Gap(24),
                        
                        // Resend Section
                        Column(
                          children: [
                            Text(
                              'Didn\'t receive the code?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            )
                                .animate(delay: 1000.ms)
                                .fadeIn(duration: 600.ms),
                            
                            const Gap(8),
                            
                            Obx(() => controller.otpResendTimer.value > 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        )
                                            .animate(
                                              onPlay: (controller) => controller.repeat(),
                                            )
                                            .rotate(duration: 2000.ms),
                                        const Gap(6),
                                        Text(
                                          'Resend in ${controller.otpResendTimer.value}s',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      .animate(
                                        onPlay: (controller) => controller.repeat(reverse: true),
                                      )
                                      .scaleXY(end: 1.02, duration: 1000.ms)
                                : AnimatedSecondaryButton(
                                    text: 'Resend Code',
                                    icon: Icons.refresh,
                                    onPressed: controller.resendOtp,
                                    color: AppColors.accent,
                                    width: 160,
                                  )),
                          ],
                        )
                            .animate(delay: 1200.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                        
                        const Gap(24),
                        
                        // Additional Help
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.info.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.info,
                                size: 20,
                              )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(reverse: true),
                                  )
                                  .scaleXY(end: 1.1, duration: 1500.ms),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  'Make sure to check your SMS messages. The code may take a few minutes to arrive.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.info,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(delay: 1400.ms)
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