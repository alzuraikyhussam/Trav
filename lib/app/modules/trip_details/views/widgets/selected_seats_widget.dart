import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/trip_model.dart';
import '../../controllers/trip_details_controller.dart';

class SelectedSeatsWidget extends StatelessWidget {
  final TripDetailsController controller;

  const SelectedSeatsWidget({
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSelectedSeatsList(),
          _buildPriceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'Selected Seats',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              controller.selectedSeatIds.length.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ))
              .animate()
              .scale(duration: 300.ms, curve: Curves.elasticOut),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildSelectedSeatsList() {
    return Obx(() {
      final selectedSeats = controller.seats
          .where((seat) => controller.selectedSeatIds.contains(seat.id))
          .toList();

      if (selectedSeats.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'No seats selected',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: selectedSeats.map((seat) {
            final index = selectedSeats.indexOf(seat);
            return _buildSeatItem(seat, index);
          }).toList(),
        ),
      );
    });
  }

  Widget _buildSeatItem(Seat seat, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              controller.getSeatIcon(seat.type),
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
                  'Seat ${seat.seatNumber}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                SizedBox(height: 2.h),
                
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getSeatTypeColor(seat.type).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        controller.getSeatTypeLabel(seat.type),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _getSeatTypeColor(seat.type),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    Text(
                      'Row ${seat.row}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${seat.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              
              SizedBox(height: 4.h),
              
              GestureDetector(
                onTap: () => controller.toggleSeatSelection(seat),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms, duration: 600.ms)
        .slideX(begin: 0.3, end: 0)
        .then()
        .shimmer(
          delay: (index * 200).ms,
          duration: 1200.ms,
          color: AppColors.primary.withOpacity(0.1),
        );
  }

  Widget _buildPriceBreakdown() {
    return Obx(() {
      final selectedSeats = controller.seats
          .where((seat) => controller.selectedSeatIds.contains(seat.id))
          .toList();

      if (selectedSeats.isEmpty) return const SizedBox.shrink();

      // Group seats by type for pricing
      Map<SeatType, List<Seat>> seatsByType = {};
      for (var seat in selectedSeats) {
        if (!seatsByType.containsKey(seat.type)) {
          seatsByType[seat.type] = [];
        }
        seatsByType[seat.type]!.add(seat);
      }

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          children: [
            // Price breakdown by seat type
            ...seatsByType.entries.map((entry) {
              final seatType = entry.key;
              final seats = entry.value;
              final price = seats.first.price ?? 0.0;
              final totalPrice = price * seats.length;

              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.getSeatTypeLabel(seatType)} (${seats.length}x)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
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
            
            if (seatsByType.isNotEmpty) ...[
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
                    '\$${controller.totalAmount.value.toStringAsFixed(2)}',
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
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.3, end: 0);
    });
  }

  Color _getSeatTypeColor(SeatType type) {
    switch (type) {
      case SeatType.vip:
        return Colors.purple;
      case SeatType.premium:
        return Colors.orange;
      case SeatType.regular:
        return Colors.blue;
    }
  }
}