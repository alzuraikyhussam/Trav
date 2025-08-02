import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/trip_model.dart';

class TripInfoCard extends StatelessWidget {
  final Trip trip;

  const TripInfoCard({
    super.key,
    required this.trip,
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
          _buildTimeAndRoute(),
          _buildTripDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.directions_bus,
              color: AppColors.primary,
              size: 28.sp,
            ),
          )
              .animate()
              .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 1500.ms, color: AppColors.primary.withOpacity(0.3)),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.carrierName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
                
                SizedBox(height: 4.h),
                
                Row(
                  children: [
                    Icon(
                      Icons.local_activity,
                      size: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      trip.vehicleType,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '${trip.availableSeats} seats left',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .scale(curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildTimeAndRoute() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildLocationTime(
              location: trip.origin,
              time: DateFormat('HH:mm').format(trip.departureTime),
              date: DateFormat('MMM dd').format(trip.departureTime),
              isOrigin: true,
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flight_takeoff,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 800.ms)
                    .slideX(begin: -0.5, end: 0),
                
                SizedBox(height: 8.h),
                
                Text(
                  trip.formattedDuration,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 600.ms)
                    .scale(curve: Curves.elasticOut),
              ],
            ),
          ),
          
          Expanded(
            child: _buildLocationTime(
              location: trip.destination,
              time: DateFormat('HH:mm').format(trip.arrivalTime),
              date: DateFormat('MMM dd').format(trip.arrivalTime),
              isOrigin: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTime({
    required String location,
    required String time,
    required String date,
    required bool isOrigin,
  }) {
    return Column(
      crossAxisAlignment: isOrigin 
          ? CrossAxisAlignment.start 
          : CrossAxisAlignment.end,
      children: [
        Text(
          location,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(delay: (isOrigin ? 400 : 800).ms, duration: 600.ms)
            .slideX(begin: isOrigin ? -0.3 : 0.3, end: 0),
        
        SizedBox(height: 4.h),
        
        Text(
          time,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        )
            .animate()
            .fadeIn(delay: (isOrigin ? 500 : 900).ms, duration: 600.ms)
            .slideX(begin: isOrigin ? -0.3 : 0.3, end: 0),
        
        SizedBox(height: 2.h),
        
        Text(
          date,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(delay: (isOrigin ? 600 : 1000).ms, duration: 600.ms)
            .slideX(begin: isOrigin ? -0.3 : 0.3, end: 0),
      ],
    );
  }

  Widget _buildTripDetails() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            icon: Icons.attach_money,
            label: 'Starting from',
            value: '\$${trip.price.toStringAsFixed(0)}',
            color: Colors.green,
          ),
          _buildDetailItem(
            icon: Icons.event_seat,
            label: 'Total Seats',
            value: trip.totalSeats.toString(),
            color: Colors.blue,
          ),
          _buildDetailItem(
            icon: Icons.schedule,
            label: 'Duration',
            value: trip.formattedDuration,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
        )
            .animate()
            .scale(delay: 800.ms, duration: 600.ms, curve: Curves.elasticOut)
            .then()
            .shimmer(duration: 1200.ms, color: color.withOpacity(0.3)),
        
        SizedBox(height: 8.h),
        
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        SizedBox(height: 2.h),
        
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 1000.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }
}