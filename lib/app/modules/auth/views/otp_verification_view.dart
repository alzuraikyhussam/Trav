import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class OtpVerificationView extends GetView<AuthController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              
              // Header
              _buildHeader(context),
              
              const Gap(50),
              
              // OTP Form
              _buildOtpForm(context),
              
              const Gap(30),
              
              // Verify Button
              _buildVerifyButton(),
              
              const Gap(20),
              
              // Resend OTP
              _buildResendSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textPrimary,
          ),
        ),
        
        const Gap(30),
        
        // Title
        Text(
          'Verify Phone',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        
        const Gap(8),
        
        Obx(() => Text(
          'Enter the 6-digit code sent to ${controller.phoneNumber.value}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        )),
      ],
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Form(
      key: controller.otpFormKey,
      child: Column(
        children: [
          // OTP Input
          TextFormField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            validator: controller.validateOtp,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: const InputDecoration(
              labelText: 'Verification Code',
              hintText: '000000',
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.verifyOtp,
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : const Text('Verify & Continue'),
      )),
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Didn\'t receive the code?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const Gap(8),
          
          Obx(() => controller.otpResendTimer.value > 0
              ? Text(
                  'Resend in ${controller.otpResendTimer.value}s',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
              : TextButton(
                  onPressed: controller.resendOtp,
                  child: Text(
                    'Resend Code',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}