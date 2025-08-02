import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controllers/payment_controller.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentController controller;

  const PaymentMethodSelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Column(
        children: controller.paymentMethods.map((method) {
          final index = controller.paymentMethods.indexOf(method);
          return _buildPaymentMethodItem(method, index);
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodData method, int index) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == method.id;
      
      return GestureDetector(
        onTap: () => controller.selectPaymentMethod(method.id),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected ? method.color.withOpacity(0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? method.color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: isSelected ? method.color : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  method.icon,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? method.color : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      method.subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? method.color : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: method.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .scaleXY(
            end: 1.02,
            duration: 200.ms,
            curve: Curves.elasticOut,
          )
          .then()
          .scaleXY(end: 1.0, duration: 200.ms)
          .animate()
          .fadeIn(delay: (index * 100).ms, duration: 600.ms)
          .slideX(begin: -0.3, end: 0);
    });
  }
}