import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controllers/payment_controller.dart';

class BankTransferWidget extends StatelessWidget {
  final PaymentController controller;

  const BankTransferWidget({
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
          _buildBankDetails(),
          _buildReceiptUpload(),
          _buildTransactionForm(),
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
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
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
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 28.sp,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 1500.ms, color: Colors.blue.withOpacity(0.3)),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank Transfer',
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
                  'Transfer to our bank account',
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

  Widget _buildBankDetails() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(height: 16.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: controller.bankDetails.entries.map((entry) {
                final index = controller.bankDetails.keys.toList().indexOf(entry.key);
                return _buildBankDetailRow(
                  label: entry.key,
                  value: entry.value,
                  delay: 400 + (index * 100),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Please use your booking ID as reference when transferring',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow({
    required String label,
    required String value,
    required int delay,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Get.snackbar(
                    'Copied',
                    '$label copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 16.sp,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildReceiptUpload() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Receipt',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 900.ms, duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(height: 16.h),
          
          Obx(() => controller.receiptImage.value != null
              ? _buildReceiptPreview()
              : _buildReceiptUploadArea()),
        ],
      ),
    );
  }

  Widget _buildReceiptUploadArea() {
    return GestureDetector(
      onTap: controller.uploadReceipt,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Obx(() => controller.isUploadingReceipt.value
                ? SizedBox(
                    width: 40.sp,
                    height: 40.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : Icon(
                    Icons.cloud_upload_outlined,
                    size: 48.sp,
                    color: Colors.grey.shade600,
                  )),
            
            SizedBox(height: 16.h),
            
            Text(
              'Tap to upload receipt',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 4.h),
            
            Text(
              'JPG, PNG or PDF (Max 5MB)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildReceiptPreview() {
    return AnimatedBuilder(
      animation: controller.receiptScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.receiptScaleAnimation.value,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    controller.receiptImage.value!,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Receipt Uploaded',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Payment receipt ready for verification',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                IconButton(
                  onPressed: controller.removeReceipt,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionForm() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 1100.ms, duration: 600.ms)
              .slideX(begin: -0.3, end: 0),
          
          SizedBox(height: 16.h),
          
          TextFormField(
            controller: controller.transactionIdController,
            decoration: InputDecoration(
              labelText: 'Transaction ID *',
              hintText: 'Enter transaction reference number',
              prefixIcon: Icon(Icons.receipt, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          SizedBox(height: 16.h),
          
          TextFormField(
            controller: controller.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Any additional information',
              prefixIcon: Icon(Icons.note, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          )
              .animate()
              .fadeIn(delay: 1300.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}