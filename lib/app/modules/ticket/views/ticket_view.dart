import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/ticket_model.dart';
import '../controllers/ticket_controller.dart';

class TicketView extends GetView<TicketController> {
  const TicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }

        if (controller.ticket.value != null) {
          return _buildTicketView();
        }

        return _buildApprovalView();
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
              .scale(duration: 1000.ms, curve: Curves.elasticOut),
          
          SizedBox(height: 20.h),
          
          Text(
            'Processing your booking...',
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

  Widget _buildApprovalView() {
    return Column(
      children: [
        _buildAppBar(title: 'Booking Status'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => AnimatedBuilder(
                  animation: controller.approvalPulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: controller.approvalPulseAnimation.value,
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: _getApprovalColor().withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getApprovalIcon(),
                          size: 60.sp,
                          color: _getApprovalColor(),
                        ),
                      ),
                    );
                  },
                )),
                
                SizedBox(height: 32.h),
                
                Obx(() => Text(
                  _getApprovalTitle(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ))
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms),
                
                SizedBox(height: 16.h),
                
                Obx(() => Text(
                  _getApprovalMessage(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ))
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms),
                
                SizedBox(height: 40.h),
                
                Obx(() {
                  if (controller.approval.value?.isApproved == true) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isGeneratingTicket.value 
                            ? null 
                            : controller.generateTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: controller.isGeneratingTicket.value
                            ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Generate Ticket',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketView() {
    return Column(
      children: [
        _buildAppBar(title: 'Your Ticket'),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: AnimatedBuilder(
              animation: controller.ticketSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, controller.ticketSlideAnimation.value * 300),
                  child: Column(
                    children: [
                      _buildTicketCard(),
                      SizedBox(height: 24.h),
                      _buildTicketActions(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar({required String title}) {
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
              title,
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

  Widget _buildTicketCard() {
    final ticket = controller.ticket.value!;
    
    return Container(
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
          _buildTicketHeader(ticket),
          _buildTicketDetails(ticket),
          _buildPassengersList(ticket),
          _buildTicketFooter(ticket),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 2000.ms, color: AppColors.primary.withOpacity(0.1));
  }

  Widget _buildTicketHeader(Ticket ticket) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TRAVEL TICKET',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  ticket.pnr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.trip.value!.origin,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.getFormattedTime(controller.trip.value!.departureTime),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.trip.value!.destination,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.getFormattedTime(controller.trip.value!.arrivalTime),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails(Ticket ticket) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Date', controller.getFormattedDate(controller.trip.value!.departureTime)),
              _buildDetailItem('Carrier', controller.trip.value!.carrierName),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Status', ticket.status.name.toUpperCase()),
              _buildDetailItem('Amount', '\$${ticket.totalAmount.toStringAsFixed(2)}'),
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

  Widget _buildPassengersList(Ticket ticket) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passengers',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...ticket.passengers.map((passenger) => _buildPassengerItem(passenger)),
        ],
      ),
    );
  }

  Widget _buildPassengerItem(TicketPassenger passenger) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
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
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.fullName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  passenger.passportNumber,
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
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              passenger.seatNumber,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketFooter(Ticket ticket) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valid Until',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  controller.getFormattedDateTime(ticket.validUntil),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: controller.toggleQRCode,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.qr_code,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.downloadTicket,
                icon: Icon(Icons.download, color: AppColors.primary),
                label: Text('Download', style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.shareTicket,
                icon: Icon(Icons.share, color: AppColors.primary),
                label: Text('Share', style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.goHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              'Book Another Trip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Color _getApprovalColor() {
    final approval = controller.approval.value;
    if (approval == null) return Colors.grey;
    
    switch (approval.status) {
      case ApprovalStatus.pending:
        return Colors.orange;
      case ApprovalStatus.approved:
        return Colors.green;
      case ApprovalStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getApprovalIcon() {
    final approval = controller.approval.value;
    if (approval == null) return Icons.hourglass_empty;
    
    switch (approval.status) {
      case ApprovalStatus.pending:
        return Icons.hourglass_empty;
      case ApprovalStatus.approved:
        return Icons.check_circle;
      case ApprovalStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getApprovalTitle() {
    final approval = controller.approval.value;
    if (approval == null) return 'Processing...';
    
    switch (approval.status) {
      case ApprovalStatus.pending:
        return 'Awaiting Approval';
      case ApprovalStatus.approved:
        return 'Booking Approved!';
      case ApprovalStatus.rejected:
        return 'Booking Rejected';
    }
  }

  String _getApprovalMessage() {
    final approval = controller.approval.value;
    if (approval == null) return 'Please wait while we process your booking.';
    
    switch (approval.status) {
      case ApprovalStatus.pending:
        return 'We are reviewing your payment and will approve your booking shortly.';
      case ApprovalStatus.approved:
        return 'Your payment has been verified. You can now generate your ticket.';
      case ApprovalStatus.rejected:
        return 'There was an issue with your payment. Please contact support.';
    }
  }
}