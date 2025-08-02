import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/trip_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/services/api_service.dart';
import '../../routes/app_routes.dart';

class PaymentController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final ApiService _apiService = Get.find<ApiService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Booking data
  late Trip trip;
  late List<String> selectedSeatIds;
  late List<Map<String, dynamic>> travelers;
  late double totalAmount;

  // Payment state
  final RxString selectedPaymentMethod = 'bank_transfer'.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Bank transfer data
  final RxBool isUploadingReceipt = false.obs;
  final Rx<File?> receiptImage = Rx<File?>(null);
  final TextEditingController transactionIdController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Credit card data
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();

  // Animation controllers
  late AnimationController slideAnimationController;
  late AnimationController receiptAnimationController;
  late Animation<double> slideAnimation;
  late Animation<double> receiptScaleAnimation;

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Payment methods
  final List<PaymentMethodData> paymentMethods = [
    PaymentMethodData(
      id: 'bank_transfer',
      name: 'Bank Transfer',
      subtitle: 'Upload receipt after transfer',
      icon: Icons.account_balance,
      color: Colors.blue,
    ),
    PaymentMethodData(
      id: 'credit_card',
      name: 'Credit Card',
      subtitle: 'Visa, Mastercard, etc.',
      icon: Icons.credit_card,
      color: Colors.green,
    ),
    PaymentMethodData(
      id: 'digital_wallet',
      name: 'Digital Wallet',
      subtitle: 'PayPal, Apple Pay, etc.',
      icon: Icons.account_balance_wallet,
      color: Colors.purple,
    ),
  ];

  // Bank details for transfer
  final Map<String, String> bankDetails = {
    'Bank Name': 'TravelEase Bank',
    'Account Name': 'TravelEase Ltd',
    'Account Number': '1234567890',
    'IBAN': 'EG123456789012345678901234',
    'Swift Code': 'TRAVELEG',
  };

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _initializeAnimations();
  }

  void _initializeData() {
    final arguments = Get.arguments;
    if (arguments != null) {
      trip = arguments['trip'];
      selectedSeatIds = List<String>.from(arguments['selectedSeatIds']);
      travelers = List<Map<String, dynamic>>.from(arguments['travelers']);
      totalAmount = arguments['totalAmount'];
    }
  }

  void _initializeAnimations() {
    slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    receiptAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.easeInOut,
    ));

    receiptScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: receiptAnimationController,
      curve: Curves.elasticOut,
    ));

    slideAnimationController.forward();
  }

  void selectPaymentMethod(String methodId) {
    selectedPaymentMethod.value = methodId;
    slideAnimationController.reset();
    slideAnimationController.forward();
  }

  Future<void> uploadReceipt() async {
    try {
      // Check storage permission
      final permission = await Permission.photos.request();
      if (!permission.isGranted) {
        _showErrorSnackbar('Storage permission is required to upload receipt');
        return;
      }

      isUploadingReceipt.value = true;

      // Show options for camera or gallery
      final source = await _showImageSourceDialog();
      if (source == null) return;

      // Pick image
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        receiptImage.value = File(image.path);
        receiptAnimationController.forward();
        
        Get.snackbar(
          'Success',
          'Receipt uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _showErrorSnackbar('Failed to upload receipt: ${e.toString()}');
    } finally {
      isUploadingReceipt.value = false;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void removeReceipt() {
    receiptImage.value = null;
    receiptAnimationController.reverse();
  }

  Future<void> processPayment() async {
    if (!_validatePaymentForm()) return;

    try {
      isLoading.value = true;
      error.value = '';

      // Create payment data
      final paymentData = await _createPaymentData();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to ticket view
      Get.offNamedUntil(
        Routes.ticket,
        (route) => route.settings.name == Routes.carriers,
        arguments: {
          'booking': paymentData,
          'trip': trip,
          'travelers': travelers,
        },
      );

    } catch (e) {
      error.value = 'Payment failed: ${e.toString()}';
      _showErrorSnackbar(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validatePaymentForm() {
    if (selectedPaymentMethod.value == 'bank_transfer') {
      if (receiptImage.value == null) {
        _showErrorSnackbar('Please upload payment receipt');
        return false;
      }
      if (transactionIdController.text.trim().isEmpty) {
        _showErrorSnackbar('Please enter transaction ID');
        return false;
      }
    } else if (selectedPaymentMethod.value == 'credit_card') {
      if (!_validateCreditCard()) {
        return false;
      }
    }
    return true;
  }

  bool _validateCreditCard() {
    if (cardNumberController.text.trim().length < 16) {
      _showErrorSnackbar('Please enter valid card number');
      return false;
    }
    if (expiryController.text.trim().length < 5) {
      _showErrorSnackbar('Please enter valid expiry date');
      return false;
    }
    if (cvvController.text.trim().length < 3) {
      _showErrorSnackbar('Please enter valid CVV');
      return false;
    }
    if (cardHolderController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter card holder name');
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> _createPaymentData() async {
    String? receiptUrl;
    
    // Upload receipt if bank transfer
    if (selectedPaymentMethod.value == 'bank_transfer' && receiptImage.value != null) {
      // Simulate file upload - replace with actual upload
      await Future.delayed(const Duration(seconds: 1));
      receiptUrl = 'https://example.com/receipts/${DateTime.now().millisecondsSinceEpoch}.jpg';
    }

    return {
      'id': 'booking_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': 'current_user_id', // Replace with actual user ID
      'trip_id': trip.id,
      'selected_seat_ids': selectedSeatIds,
      'travelers': travelers,
      'total_amount': totalAmount,
      'status': 'pending',
      'payment_info': {
        'id': 'payment_${DateTime.now().millisecondsSinceEpoch}',
        'method': selectedPaymentMethod.value,
        'amount': totalAmount,
        'currency': 'USD',
        'status': selectedPaymentMethod.value == 'bank_transfer' ? 'pending' : 'completed',
        'receipt_image_url': receiptUrl,
        'transaction_id': transactionIdController.text.trim(),
        'paid_at': selectedPaymentMethod.value != 'bank_transfer' ? DateTime.now().toIso8601String() : null,
      },
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  @override
  void onClose() {
    slideAnimationController.dispose();
    receiptAnimationController.dispose();
    transactionIdController.dispose();
    notesController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardHolderController.dispose();
    super.onClose();
  }
}

class PaymentMethodData {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;

  PaymentMethodData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}