import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controllers/traveler_info_controller.dart';

class TravelerFormWidget extends StatelessWidget {
  final TravelerFormData traveler;
  final TravelerInfoController controller;

  const TravelerFormWidget({
    super.key,
    required this.traveler,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoSection(),
              SizedBox(height: 24.h),
              _buildPassportSection(),
              SizedBox(height: 24.h),
              _buildDatesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: traveler.firstNameController,
                label: 'First Name',
                hint: 'Enter first name',
                icon: Icons.person,
                delay: 200,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTextField(
                controller: traveler.lastNameController,
                label: 'Last Name',
                hint: 'Enter last name',
                icon: Icons.person_outline,
                delay: 300,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        _buildGenderSelector(),
        
        SizedBox(height: 16.h),
        
        _buildNationalityDropdown(),
      ],
    );
  }

  Widget _buildPassportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Passport Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: controller.scanPassport,
              icon: Obx(() => controller.isProcessingOCR.value
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Icon(
                      Icons.document_scanner,
                      color: AppColors.primary,
                    )),
              tooltip: 'Scan Passport',
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
        
        SizedBox(height: 16.h),
        
        _buildTextField(
          controller: traveler.passportController,
          label: 'Passport Number',
          hint: 'Enter passport number',
          icon: Icons.assignment_ind,
          delay: 500,
          textCapitalization: TextCapitalization.characters,
        ),
      ],
    );
  }

  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Dates',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildDateSelector(
                label: 'Date of Birth',
                isDateOfBirth: true,
                delay: 700,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildDateSelector(
                label: 'Passport Expiry',
                isDateOfBirth: false,
                delay: 800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int delay,
    TextCapitalization textCapitalization = TextCapitalization.words,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => Row(
          children: [
            Expanded(
              child: _buildGenderOption('Male', Icons.male),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildGenderOption('Female', Icons.female),
            ),
          ],
        )),
      ],
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = traveler.selectedGender.value == gender;
    
    return GestureDetector(
      onTap: () => traveler.selectedGender.value = gender,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              gender,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scaleXY(end: 1.05, duration: 200.ms, curve: Curves.elasticOut)
        .then()
        .scaleXY(end: 1.0, duration: 200.ms);
  }

  Widget _buildNationalityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nationality',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => DropdownButtonFormField<String>(
          value: traveler.selectedNationality.value.isEmpty 
              ? null 
              : traveler.selectedNationality.value,
          decoration: InputDecoration(
            hintText: 'Select nationality',
            prefixIcon: Icon(Icons.public, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: controller.nationalities.map((nationality) {
            return DropdownMenuItem<String>(
              value: nationality,
              child: Text(nationality),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              traveler.selectedNationality.value = value;
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select nationality';
            }
            return null;
          },
        )),
      ],
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildDateSelector({
    required String label,
    required bool isDateOfBirth,
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final selectedDate = isDateOfBirth 
              ? traveler.selectedDateOfBirth.value 
              : traveler.selectedPassportExpiry.value;
          
          return GestureDetector(
            onTap: () => controller.selectDate(Get.context!, isDateOfBirth: isDateOfBirth),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    selectedDate != null 
                        ? DateFormat('MMM dd, yyyy').format(selectedDate)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedDate != null 
                          ? AppColors.textPrimary 
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }
}