import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controllers/payment_controller.dart';

class BookingSummaryWidget extends StatelessWidget {
  final PaymentController controller;

  const BookingSummaryWidget({
    super.key,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTripInfo(),
          _buildTravelersInfo(),
          _buildPricingBreakdown(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.receipt_long,
              color: Colors.white,
              size: 28.sp,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.3)),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Summary',
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
                  'Review your trip details',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Information',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(height: 12.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildTripDetailRow(
                  icon: Icons.directions_bus,
                  label: 'Carrier',
                  value: controller.trip.carrierName,
                  delay: 400,
                ),
                
                SizedBox(height: 12.h),
                
                _buildTripDetailRow(
                  icon: Icons.route,
                  label: 'Route',
                  value: '${controller.trip.origin} → ${controller.trip.destination}',
                  delay: 500,
                ),
                
                SizedBox(height: 12.h),
                
                _buildTripDetailRow(
                  icon: Icons.schedule,
                  label: 'Departure',
                  value: DateFormat('MMM dd, yyyy - HH:mm').format(controller.trip.departureTime),
                  delay: 600,
                ),
                
                SizedBox(height: 12.h),
                
                _buildTripDetailRow(
                  icon: Icons.airline_seat_legroom_normal,
                  label: 'Seats',
                  value: '${controller.selectedSeatIds.length} seat(s)',
                  delay: 700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required int delay,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildTravelersInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travelers (${controller.travelers.length})',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(height: 12.h),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: controller.travelers.asMap().entries.map((entry) {
                final index = entry.key;
                final traveler = entry.value;
                return _buildTravelerItem(traveler, index);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerItem(Map<String, dynamic> traveler, int index) {
    final seatId = traveler['seat_id'] as String;
    final seat = controller.trip.seats.firstWhere((s) => s.id == seatId);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: index < controller.travelers.length - 1
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${traveler['first_name']} ${traveler['last_name']}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  traveler['passport_number'] ?? 'No passport',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              seat.seatNumber,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (900 + index * 100).ms, duration: 600.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildPricingBreakdown() {
    return Container(
      margin: EdgeInsets.all(20.w),
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
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Seat pricing breakdown
          ...controller.selectedSeatIds.asMap().entries.map((entry) {
            final index = entry.key;
            final seatId = entry.value;
            final seat = controller.trip.seats.firstWhere((s) => s.id == seatId);
            final traveler = controller.travelers[index];
            
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${traveler['first_name']} (${seat.seatNumber})',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${seat.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          
          if (controller.selectedSeatIds.isNotEmpty) ...[
            Divider(
              color: AppColors.primary.withOpacity(0.3),
              thickness: 1,
            ),
            
            SizedBox(height: 8.h),
            
            Row(
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
                Text(
                  '\$${controller.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 1200.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.1));
  }
}