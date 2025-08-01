import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validators/validators.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  // Text Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxInt otpResendTimer = 0.obs;
  final RxString phoneNumber = ''.obs;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validation methods
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != AppConstants.phoneNumberLength) {
      return 'Phone number must be ${AppConstants.phoneNumberLength} digits';
    }
    if (!isNumeric(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.passwordMinLength) {
      return 'Password must be at least ${AppConstants.passwordMinLength} characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    if (!isNumeric(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  // Authentication methods
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _authService.login(
        phoneController.text.trim(),
        passwordController.text.trim(),
      );

      if (result.success) {
        Get.offAllNamed(Routes.carriers);
        Get.snackbar(
          'Success',
          result.message ?? 'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _authService.register(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );

      if (result.success) {
        phoneNumber.value = phoneController.text.trim();
        Get.toNamed(Routes.otpVerification);
        Get.snackbar(
          'Success',
          result.message ?? 'Registration successful. Please verify OTP.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _startOtpTimer();
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _authService.verifyOtp(
        phoneNumber.value,
        otpController.text.trim(),
      );

      if (result.success) {
        Get.offAllNamed(Routes.carriers);
        Get.snackbar(
          'Success',
          result.message ?? 'OTP verification successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'OTP verification failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (otpResendTimer.value > 0) return;

    isLoading.value = true;

    try {
      final result = await _authService.resendOtp(phoneNumber.value);

      if (result.success) {
        Get.snackbar(
          'Success',
          result.message ?? 'OTP sent successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _startOtpTimer();
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to send OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _startOtpTimer() {
    otpResendTimer.value = AppConstants.otpResendTime;
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (otpResendTimer.value > 0) {
        otpResendTimer.value--;
        return true;
      }
      return false;
    });
  }

  // Navigation methods
  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToLogin() {
    Get.back();
  }

  void clearForm() {
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    emailController.clear();
    otpController.clear();
  }
}