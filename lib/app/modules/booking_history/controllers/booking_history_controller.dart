import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../core/services/api_service.dart';

class BookingHistoryController extends GetxController with GetTickerProviderStateMixin {
  final ApiService _apiService = Get.find<ApiService>();

  // State management
  final RxList<Booking> allBookings = <Booking>[].obs;
  final RxList<Booking> filteredBookings = <Booking>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'all'.obs;

  // Animation
  late AnimationController listAnimationController;
  late Animation<double> listSlideAnimation;

  final List<String> filterOptions = ['all', 'pending', 'confirmed', 'completed', 'cancelled'];

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _loadBookingHistory();
  }

  void _initializeAnimations() {
    listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    listSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: listAnimationController,
      curve: Curves.elasticOut,
    ));

    listAnimationController.forward();
  }

  Future<void> _loadBookingHistory() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock booking data
      allBookings.value = _generateMockBookings();
      _applyFilter();

    } catch (e) {
      error.value = 'Failed to load booking history: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  List<Booking> _generateMockBookings() {
    return [
      Booking(
        id: 'booking_001',
        userId: 'user_123',
        tripId: 'trip_001',
        selectedSeatIds: ['seat_A1', 'seat_A2'],
        travelers: [
          Traveler(
            id: 'traveler_001',
            firstName: 'John',
            lastName: 'Doe',
            gender: 'Male',
            dateOfBirth: DateTime(1990, 5, 15),
            nationality: 'American',
            passportNumber: 'US123456789',
            passportExpiry: DateTime(2030, 5, 15),
            seatId: 'seat_A1',
          ),
          Traveler(
            id: 'traveler_002',
            firstName: 'Jane',
            lastName: 'Doe',
            gender: 'Female',
            dateOfBirth: DateTime(1992, 8, 20),
            nationality: 'American',
            passportNumber: 'US987654321',
            passportExpiry: DateTime(2029, 8, 20),
            seatId: 'seat_A2',
          ),
        ],
        totalAmount: 250.0,
        status: BookingStatus.completed,
        paymentInfo: PaymentInfo(
          id: 'payment_001',
          method: 'credit_card',
          amount: 250.0,
          currency: 'USD',
          status: PaymentStatus.completed,
          transactionId: 'TXN123456',
          paidAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Booking(
        id: 'booking_002',
        userId: 'user_123',
        tripId: 'trip_002',
        selectedSeatIds: ['seat_B3'],
        travelers: [
          Traveler(
            id: 'traveler_003',
            firstName: 'Alice',
            lastName: 'Smith',
            gender: 'Female',
            dateOfBirth: DateTime(1985, 12, 10),
            nationality: 'British',
            passportNumber: 'GB123456789',
            passportExpiry: DateTime(2028, 12, 10),
            seatId: 'seat_B3',
          ),
        ],
        totalAmount: 150.0,
        status: BookingStatus.pending,
        paymentInfo: PaymentInfo(
          id: 'payment_002',
          method: 'bank_transfer',
          amount: 150.0,
          currency: 'USD',
          status: PaymentStatus.pending,
          transactionId: 'TXN789012',
          paidAt: null,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Booking(
        id: 'booking_003',
        userId: 'user_123',
        tripId: 'trip_003',
        selectedSeatIds: ['seat_C1'],
        travelers: [
          Traveler(
            id: 'traveler_004',
            firstName: 'Bob',
            lastName: 'Johnson',
            gender: 'Male',
            dateOfBirth: DateTime(1978, 3, 25),
            nationality: 'Canadian',
            passportNumber: 'CA123456789',
            passportExpiry: DateTime(2027, 3, 25),
            seatId: 'seat_C1',
          ),
        ],
        totalAmount: 180.0,
        status: BookingStatus.confirmed,
        paymentInfo: PaymentInfo(
          id: 'payment_003',
          method: 'credit_card',
          amount: 180.0,
          currency: 'USD',
          status: PaymentStatus.completed,
          transactionId: 'TXN345678',
          paidAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
    
    // Restart animation
    listAnimationController.reset();
    listAnimationController.forward();
  }

  void _applyFilter() {
    if (selectedFilter.value == 'all') {
      filteredBookings.value = allBookings;
    } else {
      final status = BookingStatus.values.firstWhere(
        (s) => s.name == selectedFilter.value,
        orElse: () => BookingStatus.pending,
      );
      filteredBookings.value = allBookings.where((booking) => booking.status == status).toList();
    }
  }

  void viewBookingDetails(Booking booking) {
    Get.dialog(
      AlertDialog(
        title: Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking ID: ${booking.id}'),
              SizedBox(height: 8),
              Text('Status: ${booking.status.name.toUpperCase()}'),
              SizedBox(height: 8),
              Text('Amount: \$${booking.totalAmount.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Travelers: ${booking.travelers.length}'),
              SizedBox(height: 8),
              Text('Created: ${DateFormat('MMM dd, yyyy').format(booking.createdAt)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void cancelBooking(Booking booking) {
    if (booking.status != BookingStatus.pending && booking.status != BookingStatus.confirmed) {
      Get.snackbar(
        'Cannot Cancel',
        'This booking cannot be cancelled',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performCancellation(booking);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _performCancellation(Booking booking) {
    // Update booking status
    final updatedBooking = Booking(
      id: booking.id,
      userId: booking.userId,
      tripId: booking.tripId,
      selectedSeatIds: booking.selectedSeatIds,
      travelers: booking.travelers,
      totalAmount: booking.totalAmount,
      status: BookingStatus.cancelled,
      paymentInfo: booking.paymentInfo,
      createdAt: booking.createdAt,
      updatedAt: DateTime.now(),
    );

    // Update in list
    final index = allBookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      allBookings[index] = updatedBooking;
      _applyFilter();
    }

    Get.snackbar(
      'Booking Cancelled',
      'Your booking has been cancelled successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Color getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.refunded:
        return Colors.purple;
    }
  }

  IconData getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.hourglass_empty;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.completed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.refunded:
        return Icons.money_off;
    }
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  void onClose() {
    listAnimationController.dispose();
    super.onClose();
  }
}