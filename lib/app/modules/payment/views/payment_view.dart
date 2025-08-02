import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/payment_controller.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/bank_transfer_widget.dart';
import 'widgets/credit_card_widget.dart';
import 'widgets/booking_summary_widget.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: _buildMainContent(),
          ),
          _buildBottomActions(),
        ],
      ),
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
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(width: 8.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),
                
                SizedBox(height: 4.h),
                
                Text(
                  'Complete your booking',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(() => Text(
              '\$${controller.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .scale(curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildBookingSummary(),
          SizedBox(height: 24.h),
          _buildPaymentMethodSelector(),
          SizedBox(height: 24.h),
          _buildPaymentForm(),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    return BookingSummaryWidget(controller: controller)
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.2));
  }

  Widget _buildPaymentMethodSelector() {
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
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Icon(
                  Icons.payment,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          PaymentMethodSelector(controller: controller),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 800.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildPaymentForm() {
    return Obx(() {
      return AnimatedBuilder(
        animation: controller.slideAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(controller.slideAnimation),
            child: FadeTransition(
              opacity: controller.slideAnimation,
              child: _getPaymentFormWidget(),
            ),
          );
        },
      );
    });
  }

  Widget _getPaymentFormWidget() {
    switch (controller.selectedPaymentMethod.value) {
      case 'bank_transfer':
        return BankTransferWidget(controller: controller);
      case 'credit_card':
        return CreditCardWidget(controller: controller);
      case 'digital_wallet':
        return _buildDigitalWalletWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDigitalWalletWidget() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
          Icon(
            Icons.account_balance_wallet,
            size: 64.sp,
            color: Colors.purple,
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 1500.ms, color: Colors.purple.withOpacity(0.3)),
          
          SizedBox(height: 16.h),
          
          Text(
            'Digital Wallet Payment',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'This feature will be available soon',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total amount display
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Obx(() => Text(
                    '\$${controller.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Pay button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 24.sp,
                        height: 24.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Complete Payment',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              )),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              'Your payment is secure and encrypted',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.5, end: 0);
  }
}