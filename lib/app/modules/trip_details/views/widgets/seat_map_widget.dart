import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/trip_model.dart';
import '../../controllers/trip_details_controller.dart';

class SeatMapWidget extends StatelessWidget {
  final TripDetailsController controller;

  const SeatMapWidget({
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
          _buildSeatMapHeader(),
          _buildBusLayout(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSeatMapHeader() {
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
            Icons.directions_bus,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'Seat Layout',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Front',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildBusLayout() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Driver section
          _buildDriverSection(),
          
          SizedBox(height: 20.h),
          
          // Seats grid
          Obx(() => _buildSeatsGrid()),
        ],
      ),
    );
  }

  Widget _buildDriverSection() {
    return Container(
      width: double.infinity,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.drive_eta,
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Driver',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideX(begin: -0.3, end: 0);
  }

  Widget _buildSeatsGrid() {
    final seats = controller.seats;
    if (seats.isEmpty) return const SizedBox.shrink();

    // Group seats by row
    Map<int, List<Seat>> seatsByRow = {};
    for (var seat in seats) {
      if (!seatsByRow.containsKey(seat.row)) {
        seatsByRow[seat.row] = [];
      }
      seatsByRow[seat.row]!.add(seat);
    }

    return Column(
      children: seatsByRow.entries.map((entry) {
        final rowNumber = entry.key;
        final rowSeats = entry.value;
        rowSeats.sort((a, b) => a.column.compareTo(b.column));
        
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: _buildSeatRow(rowNumber, rowSeats),
        )
            .animate()
            .fadeIn(delay: (rowNumber * 50).ms, duration: 600.ms)
            .slideX(
              begin: rowNumber.isOdd ? -0.3 : 0.3,
              end: 0,
            );
      }).toList(),
    );
  }

  Widget _buildSeatRow(int rowNumber, List<Seat> rowSeats) {
    return Row(
      children: [
        // Row number
        Container(
          width: 30.w,
          height: 35.h,
          alignment: Alignment.center,
          child: Text(
            rowNumber.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // Left side seats (2 seats)
        ...rowSeats.take(2).map((seat) => _buildSeatWidget(seat)),
        
        // Aisle space
        SizedBox(width: 20.w),
        
        // Right side seats (2 seats)
        ...rowSeats.skip(2).map((seat) => _buildSeatWidget(seat)),
      ],
    );
  }

  Widget _buildSeatWidget(Seat seat) {
    return GestureDetector(
      onTap: () => controller.toggleSeatSelection(seat),
      child: AnimatedBuilder(
        animation: controller.selectedSeatsScaleAnimation,
        builder: (context, child) {
          final isSelected = controller.selectedSeatIds.contains(seat.id);
          final scale = isSelected ? controller.selectedSeatsScaleAnimation.value : 1.0;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 35.w,
              height: 35.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: controller.getSeatColor(seat),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.8)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.getSeatIcon(seat.type),
                    size: 16.sp,
                    color: _getSeatIconColor(seat),
                  ),
                  Text(
                    seat.seatNumber.substring(1), // Just the letter part
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: _getSeatIconColor(seat),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    )
        .animate(target: controller.selectedSeatIds.contains(seat.id) ? 1 : 0)
        .scaleXY(
          end: 1.1,
          duration: 200.ms,
          curve: Curves.elasticOut,
        );
  }

  Color _getSeatIconColor(Seat seat) {
    switch (seat.status) {
      case SeatStatus.available:
        return Colors.white;
      case SeatStatus.selected:
        return Colors.white;
      case SeatStatus.occupied:
        return Colors.white;
      case SeatStatus.blocked:
        return Colors.grey.shade600;
    }
  }
}