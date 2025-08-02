import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  // User data
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Profile image
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isUploadingImage = false.obs;

  // Settings
  final RxBool notificationsEnabled = true.obs;
  final RxBool locationEnabled = false.obs;
  final RxBool darkModeEnabled = false.obs;
  final RxString selectedLanguage = 'English'.obs;

  // Animation controllers
  late AnimationController profileAnimationController;
  late AnimationController settingsAnimationController;
  
  late Animation<double> profileSlideAnimation;
  late Animation<double> settingsScaleAnimation;

  final List<String> languages = ['English', 'العربية', 'Français', 'Español'];

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _loadUserProfile();
  }

  void _initializeAnimations() {
    profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    settingsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    profileSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: profileAnimationController,
      curve: Curves.elasticOut,
    ));

    settingsScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: settingsAnimationController,
      curve: Curves.elasticOut,
    ));

    profileAnimationController.forward();
    settingsAnimationController.forward();
  }

  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Mock user data - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      user.value = User(
        id: 'user_123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        profileImage: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );

      // Populate form controllers
      nameController.text = user.value!.name;
      emailController.text = user.value!.email;
      phoneController.text = user.value!.phone;

    } catch (e) {
      error.value = 'Failed to load profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update user data
      user.value = user.value!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        updatedAt: DateTime.now(),
      );

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      error.value = 'Failed to update profile: ${e.toString()}';
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty || !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Phone number cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> selectProfileImage() async {
    try {
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) return;

      isUploadingImage.value = true;

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        await _uploadProfileImage();
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProfileImage() async {
    try {
      // Simulate image upload
      await Future.delayed(const Duration(seconds: 2));
      
      // Update user with new image URL
      const imageUrl = 'https://example.com/profile_images/user_123.jpg';
      user.value = user.value!.copyWith(
        profileImage: imageUrl,
        updatedAt: DateTime.now(),
      );

      Get.snackbar(
        'Success',
        'Profile image updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      selectedImage.value = null;
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateNotificationSettings(bool enabled) {
    notificationsEnabled.value = enabled;
    _saveSettings();
  }

  void updateLocationSettings(bool enabled) {
    locationEnabled.value = enabled;
    _saveSettings();
  }

  void updateDarkModeSettings(bool enabled) {
    darkModeEnabled.value = enabled;
    _saveSettings();
    
    // Update app theme
    Get.changeThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  void updateLanguage(String language) {
    selectedLanguage.value = language;
    _saveSettings();
    
    Get.snackbar(
      'Language Updated',
      'Language changed to $language',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _saveSettings() {
    // Simulate saving settings to local storage
    Get.snackbar(
      'Settings Saved',
      'Your preferences have been saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Clear user data
    user.value = null;
    
    // Navigate to login
    Get.offAllNamed(Routes.login);
    
    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void goToBookingHistory() {
    Get.toNamed(Routes.bookingHistory);
  }

  void editProfile() {
    // Toggle edit mode or navigate to edit screen
    Get.snackbar(
      'Edit Mode',
      'Profile editing enabled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    profileAnimationController.dispose();
    settingsAnimationController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}