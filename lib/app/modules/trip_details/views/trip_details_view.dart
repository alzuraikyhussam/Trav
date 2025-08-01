import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/trip_model.dart';
import '../controllers/trip_details_controller.dart';
import 'widgets/seat_map_widget.dart';
import 'widgets/trip_info_card.dart';
import 'widgets/amenities_widget.dart';
import 'widgets/selected_seats_widget.dart';

class TripDetailsView extends GetView<TripDetailsController> {
  const TripDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }
        
        if (controller.error.value.isNotEmpty) {
          return _buildErrorView();
        }

        if (controller.trip.value == null) {
          return const Center(child: Text('Trip not found'));
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
              .shake(hz: 2, duration: 500.ms),
          
          const SizedBox(height: 20),
          
          Text(
            'Loading trip details...',
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

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shake(hz: 3, duration: 400.ms),
          
          SizedBox(height: 20.h),
          
          Text(
            controller.error.value,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms),
          
          SizedBox(height: 20.h),
          
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: const Text('Go Back'),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildTripInfoSection(),
              _buildAmenitiesSection(),
              _buildSeatSelectionSection(),
              Obx(() => controller.showSeatMap.value 
                  ? _buildSeatMapSection() 
                  : const SizedBox.shrink()),
              _buildSelectedSeatsSection(),
              _buildBottomActions(),
              SizedBox(height: 100.h), // Space for floating button
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${controller.trip.value!.origin} → ${controller.trip.value!.destination}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        background: Container(
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
        ),
      ),
    );
  }

  Widget _buildTripInfoSection() {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: TripInfoCard(trip: controller.trip.value!)
          .animate()
          .fadeIn(delay: 400.ms, duration: 800.ms)
          .slideY(begin: 0.3, end: 0)
          .then()
          .shimmer(duration: 1200.ms, color: AppColors.primary.withOpacity(0.3)),
    );
  }

  Widget _buildAmenitiesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: AmenitiesWidget(amenities: controller.trip.value!.amenities)
          .animate()
          .fadeIn(delay: 600.ms, duration: 800.ms)
          .slideX(begin: -0.3, end: 0),
    );
  }

  Widget _buildSeatSelectionSection() {
    return Container(
      margin: EdgeInsets.all(16.w),
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
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.airline_seat_recline_normal,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Select Your Seats',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                  '${controller.selectedSeatIds.length}/4',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                )),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSeatLegend(),
          ),
          
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.toggleSeatMap,
                icon: Obx(() => Icon(
                  controller.showSeatMap.value 
                      ? Icons.keyboard_arrow_up 
                      : Icons.keyboard_arrow_down,
                )),
                label: Obx(() => Text(
                  controller.showSeatMap.value ? 'Hide Seat Map' : 'Show Seat Map',
                )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 800.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
          color: Colors.green.shade300,
          label: 'Available',
          icon: Icons.airline_seat_legroom_normal,
        ),
        _buildLegendItem(
          color: Colors.blue.shade600,
          label: 'Selected',
          icon: Icons.airline_seat_legroom_normal,
        ),
        _buildLegendItem(
          color: Colors.red.shade300,
          label: 'Occupied',
          icon: Icons.airline_seat_legroom_normal,
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20.sp,
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

  Widget _buildSeatMapSection() {
    return AnimatedBuilder(
      animation: controller.seatMapSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.seatMapSlideAnimation.value * 300),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: SeatMapWidget(controller: controller)
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
          ),
        );
      },
    );
  }

  Widget _buildSelectedSeatsSection() {
    return Obx(() {
      if (controller.selectedSeatIds.isEmpty) return const SizedBox.shrink();
      
      return Container(
        margin: EdgeInsets.all(16.w),
        child: SelectedSeatsWidget(controller: controller)
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0)
            .then()
            .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.2)),
      );
    });
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (controller.selectedSeatIds.isEmpty) return const SizedBox.shrink();
      
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${controller.totalAmount.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.proceedToTravelerInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Continue to Passenger Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.5, end: 0)
          .then()
          .animate(trigger: controller.selectedSeatIds.length)
          .scaleXY(end: 1.02, duration: 200.ms, curve: Curves.elasticOut)
          .then()
          .scaleXY(end: 1.0, duration: 200.ms);
    });
  }
}