import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/ticket_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/services/api_service.dart';

class TicketController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final ApiService _apiService = Get.find<ApiService>();

  // Ticket data
  final Rx<Ticket?> ticket = Rx<Ticket?>(null);
  final Rx<TicketApproval?> approval = Rx<TicketApproval?>(null);
  final Rx<Trip?> trip = Rx<Trip?>(null);
  final RxList<Map<String, dynamic>> travelers = <Map<String, dynamic>>[].obs;

  // State management
  final RxBool isLoading = true.obs;
  final RxBool isGeneratingTicket = false.obs;
  final RxString error = ''.obs;
  final RxBool showQRCode = false.obs;

  // Animation controllers
  late AnimationController ticketAnimationController;
  late AnimationController approvalAnimationController;
  late AnimationController qrAnimationController;
  
  late Animation<double> ticketSlideAnimation;
  late Animation<double> approvalPulseAnimation;
  late Animation<double> qrScaleAnimation;

  // Booking data from payment
  Map<String, dynamic>? bookingData;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _loadTicketData();
  }

  void _initializeAnimations() {
    // Ticket slide animation
    ticketAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    ticketSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: ticketAnimationController,
      curve: Curves.elasticOut,
    ));

    // Approval pulse animation
    approvalAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    approvalPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: approvalAnimationController,
      curve: Curves.easeInOut,
    ));

    // QR code animation
    qrAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    qrScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: qrAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start approval pulse animation if needed
    approvalAnimationController.repeat(reverse: true);
  }

  Future<void> _loadTicketData() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get data from arguments
      final arguments = Get.arguments;
      if (arguments != null) {
        bookingData = arguments['booking'];
        trip.value = arguments['trip'];
        travelers.value = List<Map<String, dynamic>>.from(arguments['travelers']);
      }

      // Check if this is a new booking or existing ticket
      if (bookingData != null) {
        await _checkBookingApproval();
      } else {
        // Load existing ticket
        await _loadExistingTicket();
      }

    } catch (e) {
      error.value = 'Failed to load ticket data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkBookingApproval() async {
    // Simulate checking approval status
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock approval data - in real app, fetch from API
    final bookingId = bookingData!['id'];
    approval.value = TicketApproval(
      id: 'approval_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      status: ApprovalStatus.pending, // Change to approved for testing
      createdAt: DateTime.now(),
    );

    // Simulate approval process
    await _simulateApprovalProcess();
  }

  Future<void> _simulateApprovalProcess() async {
    // Simulate pending state for a few seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate approval
    approval.value = TicketApproval(
      id: approval.value!.id,
      bookingId: approval.value!.bookingId,
      status: ApprovalStatus.approved,
      reviewedBy: 'System Admin',
      reviewedAt: DateTime.now(),
      notes: 'Payment verified. Booking approved.',
      createdAt: approval.value!.createdAt,
    );

    // Show approval animation
    approvalAnimationController.stop();
    approvalAnimationController.reset();
    
    // Auto-generate ticket after approval
    await Future.delayed(const Duration(seconds: 1));
    await generateTicket();
  }

  Future<void> _loadExistingTicket() async {
    // Mock loading existing ticket
    await Future.delayed(const Duration(seconds: 1));
    // This would typically load from API based on ticket ID
  }

  Future<void> generateTicket() async {
    if (approval.value?.status != ApprovalStatus.approved) {
      Get.snackbar(
        'Cannot Generate Ticket',
        'Booking must be approved before generating ticket',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isGeneratingTicket.value = true;

      // Simulate ticket generation
      await Future.delayed(const Duration(seconds: 2));

      // Create ticket from booking data
      final ticketData = await _createTicketFromBooking();
      ticket.value = Ticket.fromJson(ticketData);

      // Start ticket animation
      ticketAnimationController.forward();

      Get.snackbar(
        'Ticket Generated',
        'Your travel ticket has been successfully generated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      error.value = 'Failed to generate ticket: ${e.toString()}';
      Get.snackbar(
        'Generation Failed',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGeneratingTicket.value = false;
    }
  }

  Future<Map<String, dynamic>> _createTicketFromBooking() async {
    final random = Random();
    final pnr = _generatePNR();
    final qrCode = _generateQRCode();

    // Convert travelers to ticket passengers
    final passengers = travelers.map((traveler) {
      final seatId = traveler['seat_id'] as String;
      final seat = trip.value!.seats.firstWhere((s) => s.id == seatId);
      
      return {
        'id': 'passenger_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(1000)}',
        'first_name': traveler['first_name'],
        'last_name': traveler['last_name'],
        'seat_number': seat.seatNumber,
        'seat_type': seat.type.name,
        'gender': traveler['gender'],
        'date_of_birth': traveler['date_of_birth'],
        'nationality': traveler['nationality'],
        'passport_number': traveler['passport_number'],
      };
    }).toList();

    return {
      'id': 'ticket_${DateTime.now().millisecondsSinceEpoch}',
      'booking_id': bookingData!['id'],
      'trip_id': trip.value!.id,
      'user_id': bookingData!['user_id'],
      'passengers': passengers,
      'status': 'valid',
      'issue_date': DateTime.now().toIso8601String(),
      'valid_until': trip.value!.departureTime.add(const Duration(hours: 24)).toIso8601String(),
      'qr_code': qrCode,
      'pnr': pnr,
      'total_amount': bookingData!['total_amount'],
      'currency': 'USD',
    };
  }

  String _generatePNR() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))
    ));
  }

  String _generateQRCode() {
    // In real app, this would generate actual QR code data
    return 'QR_${DateTime.now().millisecondsSinceEpoch}';
  }

  void toggleQRCode() {
    showQRCode.value = !showQRCode.value;
    if (showQRCode.value) {
      qrAnimationController.forward();
    } else {
      qrAnimationController.reverse();
    }
  }

  void downloadTicket() {
    // Simulate ticket download
    Get.snackbar(
      'Download Started',
      'Ticket is being saved to your device',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void shareTicket() {
    // Simulate ticket sharing
    Get.snackbar(
      'Share Ticket',
      'Ticket sharing options opened',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void goToBookingHistory() {
    Get.offAllNamed('/booking-history');
  }

  void goHome() {
    Get.offAllNamed('/carriers');
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String getFormattedTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String getFormattedDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - HH:mm').format(date);
  }

  Color getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.valid:
        return Colors.green;
      case TicketStatus.used:
        return Colors.blue;
      case TicketStatus.cancelled:
        return Colors.red;
      case TicketStatus.expired:
        return Colors.orange;
    }
  }

  IconData getStatusIcon(TicketStatus status) {
    switch (status) {
      case TicketStatus.valid:
        return Icons.check_circle;
      case TicketStatus.used:
        return Icons.done_all;
      case TicketStatus.cancelled:
        return Icons.cancel;
      case TicketStatus.expired:
        return Icons.access_time;
    }
  }

  @override
  void onClose() {
    ticketAnimationController.dispose();
    approvalAnimationController.dispose();
    qrAnimationController.dispose();
    super.onClose();
  }
}