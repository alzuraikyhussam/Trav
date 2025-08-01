import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/traveler_info_controller.dart';
import 'widgets/traveler_form_widget.dart';
import 'widgets/progress_indicator_widget.dart';
import 'widgets/traveler_summary_widget.dart';

class TravelerInfoView extends GetView<TravelerInfoController> {
  const TravelerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.travelers.isEmpty) {
          return _buildLoadingView();
        }
        return _buildMainContent();
      }),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 1000.ms, curve: Curves.elasticOut)
              .then()
              .rotate(duration: 2000.ms),
          
          SizedBox(height: 20.h),
          
          Text(
            'Preparing traveler forms...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildAppBar(),
        _buildProgressIndicator(),
        Expanded(
          child: _buildFormContent(),
        ),
        _buildBottomActions(),
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
                  'Passenger Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),
                
                SizedBox(height: 4.h),
                
                Obx(() => Text(
                  'Traveler ${controller.currentTravelerIndex.value + 1} of ${controller.travelers.length}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ))
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),
              ],
            ),
          ),
          
          IconButton(
            onPressed: controller.scanPassport,
            icon: Obx(() => controller.isProcessingOCR.value
                ? SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                    size: 24.sp,
                  )),
            tooltip: 'Scan Passport',
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .scale(curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Obx(() => ProgressIndicatorWidget(
        currentStep: controller.currentTravelerIndex.value,
        totalSteps: controller.travelers.length,
      ))
          .animate()
          .fadeIn(delay: 200.ms, duration: 800.ms)
          .slideY(begin: -0.2, end: 0),
    );
  }

  Widget _buildFormContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _buildTravelerSummary(),
          SizedBox(height: 16.h),
          Expanded(
            child: _buildTravelerForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerSummary() {
    return Obx(() {
      final currentTraveler = controller.travelers[controller.currentTravelerIndex.value];
      final seatNumber = controller.getSeatNumber(currentTraveler.seatId);
      
      return TravelerSummaryWidget(
        travelerNumber: controller.currentTravelerIndex.value + 1,
        seatNumber: seatNumber,
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.3, end: 0)
          .then()
          .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.2));
    });
  }

  Widget _buildTravelerForm() {
    return Obx(() {
      final currentTraveler = controller.travelers[controller.currentTravelerIndex.value];
      
      return AnimatedBuilder(
        animation: controller.slideAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: controller.slideAnimation,
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: TravelerFormWidget(
                traveler: currentTraveler,
                controller: controller,
              ),
            ),
          );
        },
      );
    });
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
      child: Row(
        children: [
          Obx(() => controller.currentTravelerIndex.value > 0
              ? Expanded(
                  child: OutlinedButton(
                    onPressed: controller.previousTraveler,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: AppColors.primary),
                        SizedBox(width: 8.w),
                        Text(
                          'Previous',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          
          Obx(() => controller.currentTravelerIndex.value > 0 
              ? SizedBox(width: 16.w) 
              : const SizedBox.shrink()),
          
          Expanded(
            flex: 2,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value 
                  ? null 
                  : _getNextButtonAction(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getNextButtonText(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          _getNextButtonIcon(),
                          color: Colors.white,
                        ),
                      ],
                    ),
            )),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  VoidCallback? _getNextButtonAction() {
    return controller.currentTravelerIndex.value < controller.travelers.length - 1
        ? controller.nextTraveler
        : controller.proceedToPayment;
  }

  String _getNextButtonText() {
    return controller.currentTravelerIndex.value < controller.travelers.length - 1
        ? 'Next Traveler'
        : 'Proceed to Payment';
  }

  IconData _getNextButtonIcon() {
    return controller.currentTravelerIndex.value < controller.travelers.length - 1
        ? Icons.arrow_forward
        : Icons.payment;
  }
}