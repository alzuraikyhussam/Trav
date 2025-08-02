import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/booking_model.dart';
import '../controllers/booking_history_controller.dart';

class BookingHistoryView extends GetView<BookingHistoryController> {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          _buildFilterTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingView();
              }
              
              if (controller.filteredBookings.isEmpty) {
                return _buildEmptyView();
              }
              
              return _buildBookingsList();
            }),
          ),
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
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Booking History',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.filterOptions.map((filter) {
            final index = controller.filterOptions.indexOf(filter);
            return _buildFilterTab(filter, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String filter, int index) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == filter;
      
      return GestureDetector(
        onTap: () => controller.selectFilter(filter),
        child: Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Text(
            filter.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .scaleXY(end: 1.05, duration: 200.ms, curve: Curves.elasticOut)
          .then()
          .scaleXY(end: 1.0, duration: 200.ms)
          .animate()
          .fadeIn(delay: (index * 100).ms, duration: 600.ms)
          .slideX(begin: 0.3, end: 0);
    });
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
              .scale(duration: 1000.ms, curve: Curves.elasticOut),
          
          SizedBox(height: 20.h),
          
          Text(
            'Loading booking history...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.sp,
            color: Colors.grey.shade400,
          )
              .animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .then()
              .shake(duration: 1000.ms),
          
          SizedBox(height: 24.h),
          
          Text(
            'No Bookings Found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms),
          
          SizedBox(height: 8.h),
          
          Text(
            'You haven\'t made any bookings yet',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms),
          
          SizedBox(height: 32.h),
          
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/carriers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Book Your First Trip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return AnimatedBuilder(
      animation: controller.listSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.listSlideAnimation.value * 50),
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = controller.filteredBookings[index];
              return _buildBookingItem(booking, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildBookingItem(Booking booking, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          _buildBookingHeader(booking),
          _buildBookingDetails(booking),
          _buildBookingActions(booking),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms, duration: 600.ms)
        .slideX(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.1));
  }

  Widget _buildBookingHeader(Booking booking) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: controller.getStatusColor(booking.status).withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: controller.getStatusColor(booking.status),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              controller.getStatusIcon(booking.status),
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking #${booking.id.substring(0, 8)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  booking.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: controller.getStatusColor(booking.status),
                  ),
                ),
              ],
            ),
          ),
          
          Text(
            '\$${booking.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(Booking booking) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Date', controller.getFormattedDate(booking.createdAt)),
              _buildDetailItem('Travelers', '${booking.travelers.length}'),
              _buildDetailItem('Seats', '${booking.selectedSeatIds.length}'),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Icon(
                Icons.payment,
                size: 16.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                booking.paymentInfo?.method.replaceAll('_', ' ').toUpperCase() ?? 'N/A',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (booking.paymentInfo?.status != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(booking.paymentInfo!.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    booking.paymentInfo!.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: _getPaymentStatusColor(booking.paymentInfo!.status),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingActions(Booking booking) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.viewBookingDetails(booking),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          
          if (booking.status == BookingStatus.pending || 
              booking.status == BookingStatus.confirmed) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.cancelBooking(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.processing:
        return Colors.blue;
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.purple;
    }
  }
}