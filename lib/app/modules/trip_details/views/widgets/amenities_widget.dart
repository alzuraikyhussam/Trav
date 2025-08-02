import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class AmenitiesWidget extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesWidget({
    super.key,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildAmenitiesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3, end: 0);
  }

  Widget _buildAmenitiesList() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 8.h,
        children: amenities.map((amenity) {
          final index = amenities.indexOf(amenity);
          return _buildAmenityChip(amenity, index);
        }).toList(),
      ),
    );
  }

  Widget _buildAmenityChip(String amenity, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getAmenityIcon(amenity),
            color: AppColors.primary,
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            amenity,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(
          delay: (index * 200).ms,
          duration: 1000.ms,
          color: AppColors.primary.withOpacity(0.2),
        );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'charging port':
      case 'charging':
        return Icons.battery_charging_full;
      case 'snacks':
      case 'food':
        return Icons.fastfood;
      case 'tv':
      case 'entertainment':
        return Icons.tv;
      case 'blanket':
        return Icons.bed;
      case 'pillow':
        return Icons.airline_seat_individual_suite;
      case 'reading light':
        return Icons.lightbulb;
      case 'usb port':
        return Icons.usb;
      case 'restroom':
        return Icons.wc;
      default:
        return Icons.check_circle;
    }
  }
}