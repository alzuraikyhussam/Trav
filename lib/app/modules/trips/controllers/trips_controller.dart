import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/trip_model.dart';

class TripsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final RxList<Trip> trips = <Trip>[].obs;
  final RxList<Trip> filteredTrips = <Trip>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTimeFilter = 'All Times'.obs;
  final RxString selectedSortOption = 'Departure Time'.obs;
  
  // Carrier information passed from previous screen
  final RxString carrierName = ''.obs;
  final RxString carrierRoute = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _loadTrips();
  }

  void _getArguments() {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    carrierName.value = arguments['carrierName'] ?? 'Selected Carrier';
    carrierRoute.value = arguments['route'] ?? 'All Routes';
  }

  Future<void> _loadTrips() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      // final response = await _apiService.get('/trips', queryParameters: {
      //   'carrier_id': carrierId,
      // });
      
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final mockTrips = _generateMockTrips();
      trips.value = mockTrips;
      filteredTrips.value = mockTrips;
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trips: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchTrips(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setTimeFilter(String filter) {
    selectedTimeFilter.value = filter;
    _applyFilters();
  }

  void setSortOption(String option) {
    selectedSortOption.value = option;
    _applySorting();
  }

  void _applyFilters() {
    var filtered = trips.toList();
    
    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((trip) {
        return trip.origin.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               trip.destination.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               trip.vehicleType.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    // Apply time filter
    if (selectedTimeFilter.value != 'All Times') {
      filtered = filtered.where((trip) {
        final departureHour = _extractHour(trip.departureTime);
        
        switch (selectedTimeFilter.value) {
          case 'Morning':
            return departureHour >= 6 && departureHour < 12;
          case 'Afternoon':
            return departureHour >= 12 && departureHour < 18;
          case 'Evening':
            return departureHour >= 18 && departureHour < 24;
          default:
            return true;
        }
      }).toList();
    }
    
    filteredTrips.value = filtered;
    _applySorting();
  }

  void _applySorting() {
    var sorted = filteredTrips.toList();
    
    switch (selectedSortOption.value) {
      case 'Price (Low to High)':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (High to Low)':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Departure Time':
        sorted.sort((a, b) => _extractHour(a.departureTime).compareTo(_extractHour(b.departureTime)));
        break;
      case 'Duration':
        sorted.sort((a, b) => a.duration.inMinutes.compareTo(b.duration.inMinutes));
        break;
      case 'Availability':
        sorted.sort((a, b) => b.availableSeats.compareTo(a.availableSeats));
        break;
    }
    
    filteredTrips.value = sorted;
  }

  int _extractHour(DateTime dateTime) {
    return dateTime.hour;
  }

  void selectTrip(Trip trip) {
    Get.snackbar(
      'Trip Selected!',
      'Proceeding to seat selection for ${trip.origin} → ${trip.destination}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    
    // TODO: Navigate to trip details/seat selection
    // Get.toNamed(Routes.tripDetails, arguments: {
    //   'trip': trip,
    //   'carrier': carrierName.value,
    // });
  }

  Future<void> refreshTrips() async {
    await _loadTrips();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedTimeFilter.value = 'All Times';
    selectedSortOption.value = 'Departure Time';
    _applyFilters();
  }

  List<Trip> _generateMockTrips() {
    final now = DateTime.now();
    
    return [
      Trip(
        id: '1',
        carrierId: 'carrier_1',
        carrierName: carrierName.value,
        origin: 'New York',
        destination: 'Boston',
        departureTime: DateTime(now.year, now.month, now.day, 8, 30),
        arrivalTime: DateTime(now.year, now.month, now.day, 12, 15),
        price: 45.0,
        totalSeats: 40,
        availableSeats: 12,
        vehicleType: 'Express Bus',
        amenities: ['WiFi', 'AC', 'USB Charging', 'Reclining Seats'],
        seats: _generateMockSeats(40, 12),
      ),
      Trip(
        id: '2',
        carrierId: 'carrier_1',
        carrierName: carrierName.value,
        origin: 'New York',
        destination: 'Boston',
        departureTime: DateTime(now.year, now.month, now.day, 14, 0),
        arrivalTime: DateTime(now.year, now.month, now.day, 17, 30),
        price: 42.0,
        totalSeats: 35,
        availableSeats: 8,
        vehicleType: 'Standard Bus',
        amenities: ['WiFi', 'AC', 'Reclining Seats'],
        seats: _generateMockSeats(35, 8),
      ),
      Trip(
        id: '3',
        carrierId: 'carrier_1',
        carrierName: carrierName.value,
        origin: 'New York',
        destination: 'Boston',
        departureTime: DateTime(now.year, now.month, now.day, 18, 45),
        arrivalTime: DateTime(now.year, now.month, now.day, 22, 15),
        price: 38.0,
        totalSeats: 45,
        availableSeats: 15,
        vehicleType: 'Economy Bus',
        amenities: ['WiFi', 'AC'],
        seats: _generateMockSeats(45, 15),
      ),
      Trip(
        id: '4',
        carrierId: 'carrier_1',
        carrierName: carrierName.value,
        origin: 'New York',
        destination: 'Boston',
        departureTime: DateTime(now.year, now.month, now.day, 23, 0),
        arrivalTime: DateTime(now.year, now.month, now.day + 1, 2, 45),
        price: 35.0,
        totalSeats: 50,
        availableSeats: 20,
        vehicleType: 'Night Express',
        amenities: ['WiFi', 'AC', 'Blankets', 'Reclining Seats'],
        seats: _generateMockSeats(50, 20),
      ),
      Trip(
        id: '5',
        carrierId: 'carrier_1',
        carrierName: carrierName.value,
        origin: 'New York',
        destination: 'Boston',
        departureTime: DateTime(now.year, now.month, now.day, 10, 15),
        arrivalTime: DateTime(now.year, now.month, now.day, 14, 0),
        price: 48.0,
        totalSeats: 30,
        availableSeats: 5,
        vehicleType: 'Premium Bus',
        amenities: ['WiFi', 'AC', 'USB Charging', 'Reclining Seats', 'Snacks', 'Entertainment'],
        seats: _generateMockSeats(30, 5),
      ),
    ];
  }

  List<Seat> _generateMockSeats(int totalSeats, int availableSeats) {
    final seats = <Seat>[];
    final occupiedSeats = totalSeats - availableSeats;
    
    for (int i = 1; i <= totalSeats; i++) {
      final isOccupied = i <= occupiedSeats;
      
      seats.add(Seat(
        seatNumber: i.toString().padLeft(2, '0'),
        type: i <= 4 ? SeatType.premium : SeatType.regular,
        status: isOccupied ? SeatStatus.occupied : SeatStatus.available,
        price: i <= 4 ? 10.0 : 0.0, // Premium seats have extra cost
      ));
    }
    
    return seats;
  }

  String getFormattedDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String getFormattedTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  Color getAvailabilityColor(int availableSeats) {
    if (availableSeats > 10) {
      return const Color(0xFF4CAF50); // Green
    } else if (availableSeats > 5) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  String getAvailabilityText(int availableSeats) {
    if (availableSeats > 10) {
      return 'Good Availability';
    } else if (availableSeats > 5) {
      return 'Limited Seats';
    } else if (availableSeats > 0) {
      return 'Few Seats Left';
    } else {
      return 'Sold Out';
    }
  }
}