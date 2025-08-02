import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${currentStep + 1} of $totalSteps',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          _buildProgressBar(),
          
          SizedBox(height: 12.h),
          
          _buildStepIndicators(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (currentStep + 1) / totalSteps;
    
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: (progress * 100).round(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(3.r),
              ),
            )
                .animate()
                .scaleX(duration: 600.ms, curve: Curves.easeOut),
          ),
          Expanded(
            flex: ((1 - progress) * 100).round(),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final isPending = index > currentStep;
        
        return _buildStepDot(
          index: index,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isPending: isPending,
        );
      }),
    );
  }

  Widget _buildStepDot({
    required int index,
    required bool isCompleted,
    required bool isCurrent,
    required bool isPending,
  }) {
    Color color;
    IconData? icon;
    
    if (isCompleted) {
      color = AppColors.primary;
      icon = Icons.check;
    } else if (isCurrent) {
      color = AppColors.primary;
    } else {
      color = Colors.grey.shade300;
    }
    
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isCurrent ? Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 3,
        ) : null,
      ),
      child: Center(
        child: isCompleted && icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: 16.sp,
              )
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isPending ? AppColors.textSecondary : Colors.white,
                ),
              ),
      ),
    )
        .animate(target: isCurrent ? 1 : 0)
        .scaleXY(
          end: 1.2,
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .shimmer(
          duration: 1500.ms,
          color: AppColors.primary.withOpacity(0.3),
        );
  }
}