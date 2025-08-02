import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }
        return _buildMainContent();
      }),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: AnimatedBuilder(
              animation: controller.profileSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, controller.profileSlideAnimation.value * 100),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      SizedBox(height: 24.h),
                      _buildMenuItems(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, MediaQuery.of(Get.context!).padding.top + 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: controller.editProfile,
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileImage(),
          SizedBox(height: 16.h),
          Obx(() => Text(
            controller.user.value?.name ?? 'User Name',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          )),
          SizedBox(height: 8.h),
          Obx(() => Text(
            controller.user.value?.email ?? 'user@example.com',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          )),
          SizedBox(height: 24.h),
          _buildProfileStats(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.1));
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Obx(() => CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: controller.selectedImage.value != null
              ? FileImage(controller.selectedImage.value!)
              : controller.user.value?.profileImage != null
                  ? NetworkImage(controller.user.value!.profileImage!)
                  : null,
          child: controller.selectedImage.value == null && 
                 controller.user.value?.profileImage == null
              ? Icon(
                  Icons.person,
                  size: 50.sp,
                  color: AppColors.primary,
                )
              : null,
        )),
        
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: controller.selectProfileImage,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Obx(() => controller.isUploadingImage.value
                  ? SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.camera_alt,
                      size: 16.sp,
                      color: Colors.white,
                    )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Trips', '12'),
        _buildStatItem('Points', '150'),
        _buildStatItem('Reviews', '4.8'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return AnimatedBuilder(
      animation: controller.settingsScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.settingsScaleAnimation.value,
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.history,
                title: 'Booking History',
                subtitle: 'View your past bookings',
                onTap: controller.goToBookingHistory,
                delay: 0,
              ),
              
              SizedBox(height: 16.h),
              
              _buildSettingsSection(),
              
              SizedBox(height: 16.h),
              
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: controller.logout,
                isDestructive: true,
                delay: 600,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: (isDestructive ? Colors.red : AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.primary,
                size: 24.sp,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsHeader(),
          _buildSettingSwitch(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Receive booking updates',
            value: controller.notificationsEnabled,
            onChanged: controller.updateNotificationSettings,
          ),
          _buildSettingSwitch(
            icon: Icons.location_on,
            title: 'Location Services',
            subtitle: 'Find nearby stations',
            value: controller.locationEnabled,
            onChanged: controller.updateLocationSettings,
          ),
          _buildSettingSwitch(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: controller.darkModeEnabled,
            onChanged: controller.updateDarkModeSettings,
          ),
          _buildLanguageSelector(),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSettingsHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            Icons.settings,
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: value.value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          )),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            Icons.language,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Select your preferred language',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => DropdownButton<String>(
            value: controller.selectedLanguage.value,
            underline: Container(),
            items: controller.languages.map((language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.updateLanguage(value);
              }
            },
          )),
        ],
      ),
    );
  }
}