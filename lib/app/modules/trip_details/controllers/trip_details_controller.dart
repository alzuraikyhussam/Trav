import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/services/api_service.dart';

class TripDetailsController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final ApiService _apiService = Get.find<ApiService>();

  // Trip data
  final Rx<Trip?> trip = Rx<Trip?>(null);
  final RxList<Seat> seats = <Seat>[].obs;
  final RxList<String> selectedSeatIds = <String>[].obs;
  final RxDouble totalAmount = 0.0.obs;

  // UI State
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxBool showSeatMap = false.obs;

  // Animation Controllers
  late AnimationController seatMapAnimationController;
  late AnimationController selectedSeatsAnimationController;
  late Animation<double> seatMapSlideAnimation;
  late Animation<double> selectedSeatsScaleAnimation;

  // Seat map configuration
  final int seatsPerRow = 4;
  final double seatSpacing = 8.0;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _loadTripDetails();
  }

  void _initializeAnimations() {
    // Seat map slide animation
    seatMapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    seatMapSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: seatMapAnimationController,
      curve: Curves.elasticOut,
    ));

    // Selected seats animation
    selectedSeatsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    selectedSeatsScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: selectedSeatsAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _loadTripDetails() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get trip ID from arguments
      final String? tripId = Get.arguments?['tripId'];
      if (tripId == null) {
        error.value = 'Trip ID not provided';
        return;
      }

      // Load trip data (Mock for now - replace with actual API call)
      await Future.delayed(const Duration(seconds: 1));
      trip.value = _mockTripData(tripId);
      seats.value = trip.value?.seats ?? [];
      
    } catch (e) {
      error.value = 'Failed to load trip details: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data - replace with actual API call
  Trip _mockTripData(String tripId) {
    return Trip(
      id: tripId,
      carrierId: '1',
      carrierName: 'Swift Travel',
      origin: 'Cairo',
      destination: 'Alexandria',
      departureTime: DateTime.now().add(const Duration(days: 1)),
      arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      price: 50.0,
      totalSeats: 40,
      availableSeats: 25,
      vehicleType: 'Bus',
      amenities: ['WiFi', 'AC', 'Charging Port', 'Snacks'],
      seats: _generateMockSeats(),
    );
  }

  List<Seat> _generateMockSeats() {
    List<Seat> mockSeats = [];
    for (int row = 1; row <= 10; row++) {
      for (int col = 1; col <= 4; col++) {
        String seatNumber = '${row}${String.fromCharCode(64 + col)}';
        SeatStatus status = SeatStatus.available;
        
        // Randomly make some seats occupied
        if ((row + col) % 7 == 0) status = SeatStatus.occupied;
        
        SeatType type = SeatType.regular;
        if (row <= 2) type = SeatType.premium;
        if (row == 1) type = SeatType.vip;

        mockSeats.add(Seat(
          id: '${row}_$col',
          seatNumber: seatNumber,
          type: type,
          status: status,
          price: _getSeatPrice(type),
          row: row,
          column: col,
        ));
      }
    }
    return mockSeats;
  }

  double _getSeatPrice(SeatType type) {
    switch (type) {
      case SeatType.vip:
        return 80.0;
      case SeatType.premium:
        return 65.0;
      case SeatType.regular:
        return 50.0;
    }
  }

  void toggleSeatSelection(Seat seat) {
    if (seat.status == SeatStatus.occupied) return;

    if (selectedSeatIds.contains(seat.id)) {
      // Deselect seat
      selectedSeatIds.remove(seat.id);
      _updateSeatStatus(seat.id, SeatStatus.available);
    } else {
      // Select seat (max 4 seats)
      if (selectedSeatIds.length < 4) {
        selectedSeatIds.add(seat.id);
        _updateSeatStatus(seat.id, SeatStatus.selected);
        _animateSelectedSeat();
      } else {
        Get.snackbar(
          'Maximum Seats',
          'You can select up to 4 seats only',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
    _calculateTotalAmount();
  }

  void _updateSeatStatus(String seatId, SeatStatus newStatus) {
    final seatIndex = seats.indexWhere((seat) => seat.id == seatId);
    if (seatIndex != -1) {
      final oldSeat = seats[seatIndex];
      seats[seatIndex] = Seat(
        id: oldSeat.id,
        seatNumber: oldSeat.seatNumber,
        type: oldSeat.type,
        status: newStatus,
        price: oldSeat.price,
        row: oldSeat.row,
        column: oldSeat.column,
      );
    }
  }

  void _animateSelectedSeat() {
    selectedSeatsAnimationController.forward().then((_) {
      selectedSeatsAnimationController.reverse();
    });
  }

  void _calculateTotalAmount() {
    double total = 0.0;
    for (String seatId in selectedSeatIds) {
      final seat = seats.firstWhere((s) => s.id == seatId);
      total += seat.price ?? 0.0;
    }
    totalAmount.value = total;
  }

  void toggleSeatMap() {
    showSeatMap.value = !showSeatMap.value;
    if (showSeatMap.value) {
      seatMapAnimationController.forward();
    } else {
      seatMapAnimationController.reverse();
    }
  }

  void proceedToTravelerInfo() {
    if (selectedSeatIds.isEmpty) {
      Get.snackbar(
        'No Seats Selected',
        'Please select at least one seat to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to traveler info with selected data
    Get.toNamed('/traveler-info', arguments: {
      'trip': trip.value,
      'selectedSeatIds': selectedSeatIds.toList(),
      'totalAmount': totalAmount.value,
    });
  }

  // Helper methods for UI
  Color getSeatColor(Seat seat) {
    switch (seat.status) {
      case SeatStatus.available:
        return Colors.green.shade300;
      case SeatStatus.selected:
        return Colors.blue.shade600;
      case SeatStatus.occupied:
        return Colors.red.shade300;
      case SeatStatus.blocked:
        return Colors.grey.shade400;
    }
  }

  IconData getSeatIcon(SeatType type) {
    switch (type) {
      case SeatType.vip:
        return Icons.airline_seat_individual_suite;
      case SeatType.premium:
        return Icons.airline_seat_legroom_extra;
      case SeatType.regular:
        return Icons.airline_seat_legroom_normal;
    }
  }

  String getSeatTypeLabel(SeatType type) {
    switch (type) {
      case SeatType.vip:
        return 'VIP';
      case SeatType.premium:
        return 'Premium';
      case SeatType.regular:
        return 'Regular';
    }
  }

  @override
  void onClose() {
    seatMapAnimationController.dispose();
    selectedSeatsAnimationController.dispose();
    super.onClose();
  }
}