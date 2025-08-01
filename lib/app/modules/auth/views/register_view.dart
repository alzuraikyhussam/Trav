import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              
              // Header
              _buildHeader(context),
              
              const Gap(40),
              
              // Register Form
              _buildRegisterForm(context),
              
              const Gap(30),
              
              // Register Button
              _buildRegisterButton(),
              
              const Gap(20),
              
              // Login Link
              _buildLoginLink(context),
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
        
        // Welcome Text
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        
        const Gap(8),
        
        Text(
          'Sign up to start your travel journey',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Form(
      key: controller.registerFormKey,
      child: Column(
        children: [
          // Full Name Field
          TextFormField(
            controller: controller.nameController,
            keyboardType: TextInputType.name,
            validator: controller.validateName,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          
          const Gap(20),
          
          // Email Field
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          
          const Gap(20),
          
          // Phone Number Field
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          
          const Gap(20),
          
          // Password Field
          Obx(() => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            validator: controller.validatePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: controller.togglePasswordVisibility,
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          )),
          
          const Gap(20),
          
          // Confirm Password Field
          Obx(() => TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: !controller.isConfirmPasswordVisible.value,
            validator: controller.validateConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: controller.toggleConfirmPasswordVisibility,
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.register,
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : const Text('Create Account'),
      )),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: controller.goToLogin,
            child: Text(
              'Sign In',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}