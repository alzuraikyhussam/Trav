import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class TravelerSummaryWidget extends StatelessWidget {
  final int travelerNumber;
  final String seatNumber;

  const TravelerSummaryWidget({
    super.key,
    required this.travelerNumber,
    required this.seatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTravelerIcon(),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildTravelerInfo(),
          ),
          _buildSeatInfo(),
        ],
      ),
    );
  }

  Widget _buildTravelerIcon() {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 28.sp,
      ),
    )
        .animate()
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .then()
        .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.3));
  }

  Widget _buildTravelerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Traveler $travelerNumber',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
        
        SizedBox(height: 4.h),
        
        Text(
          'Complete the form below',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0),
      ],
    );
  }

  Widget _buildSeatInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.airline_seat_legroom_normal,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            'Seat',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            seatNumber,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .scale(curve: Curves.elasticOut);
  }
}