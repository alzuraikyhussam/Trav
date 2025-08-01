import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/carrier_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

class CarriersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<Carrier> carriers = <Carrier>[].obs;
  final RxList<Carrier> filteredCarriers = <Carrier>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCarriers();
  }

  Future<void> _loadCarriers() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      // final response = await _apiService.get(AppConstants.carriersEndpoint);
      // final carriersList = (response.data as List)
      //     .map((json) => Carrier.fromJson(json))
      //     .toList();
      
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final mockCarriers = [
        Carrier(
          id: '1',
          name: 'Express Transit Co.',
          description: 'Premium express service with comfortable seating and onboard amenities. Experience luxury travel at affordable prices.',
          logo: 'https://example.com/logo1.png',
          rating: 4.8,
          totalTrips: 1250,
          amenities: ['WiFi', 'AC', 'USB Charging', 'Snacks', 'Entertainment'],
          isActive: true,
        ),
        Carrier(
          id: '2',
          name: 'City Link Bus Lines',
          description: 'Reliable city-to-city connections with frequent departures and competitive pricing.',
          logo: 'https://example.com/logo2.png',
          rating: 4.5,
          totalTrips: 980,
          amenities: ['WiFi', 'AC', 'Reclining Seats'],
          isActive: true,
        ),
        Carrier(
          id: '3',
          name: 'Metro Coach Services',
          description: 'Modern fleet with advanced safety features and comfortable seating for long-distance travel.',
          logo: 'https://example.com/logo3.png',
          rating: 4.6,
          totalTrips: 756,
          amenities: ['WiFi', 'AC', 'USB Charging', 'Reading Lights'],
          isActive: true,
        ),
        Carrier(
          id: '4',
          name: 'Highway Express',
          description: 'Fast and efficient highway routes with express services to major destinations.',
          logo: 'https://example.com/logo4.png',
          rating: 4.3,
          totalTrips: 642,
          amenities: ['WiFi', 'AC', 'Refreshments'],
          isActive: true,
        ),
        Carrier(
          id: '5',
          name: 'Comfort Travels',
          description: 'Luxury travel experience with premium seating and exceptional customer service.',
          logo: 'https://example.com/logo5.png',
          rating: 4.9,
          totalTrips: 1100,
          amenities: ['WiFi', 'AC', 'USB Charging', 'Premium Seats', 'Meals', 'Entertainment'],
          isActive: true,
        ),
      ];
      
      carriers.value = mockCarriers;
      filteredCarriers.value = mockCarriers;
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load carriers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchCarriers(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredCarriers.value = carriers.toList();
    } else {
      filteredCarriers.value = carriers.where((carrier) {
        return carrier.name.toLowerCase().contains(query.toLowerCase()) ||
               carrier.description.toLowerCase().contains(query.toLowerCase()) ||
               carrier.amenities.any((amenity) => 
                   amenity.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
  }

  void selectCarrier(Carrier carrier) {
    Get.snackbar(
      'Carrier Selected',
      'Loading trips for ${carrier.name}...',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
    
    // Navigate to trips with carrier information
    Get.toNamed(
      Routes.trips,
      arguments: {
        'carrierId': carrier.id,
        'carrierName': carrier.name,
        'carrierRating': carrier.rating,
        'route': 'All Routes', // This could be dynamic based on user selection
        'amenities': carrier.amenities,
      },
    );
  }

  void refreshCarriers() {
    _loadCarriers();
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _authService.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String getAmenitiesText(List<String> amenities) {
    if (amenities.isEmpty) return 'No amenities listed';
    if (amenities.length <= 3) {
      return amenities.join(', ');
    }
    return '${amenities.take(3).join(', ')} +${amenities.length - 3} more';
  }

  void filterByRating(double minRating) {
    filteredCarriers.value = carriers.where((carrier) {
      return carrier.rating >= minRating;
    }).toList();
  }

  void filterByAmenity(String amenity) {
    filteredCarriers.value = carriers.where((carrier) {
      return carrier.amenities.contains(amenity);
    }).toList();
  }

  void sortCarriers(String sortBy) {
    var sorted = filteredCarriers.toList();
    
    switch (sortBy) {
      case 'Rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Experience':
        sorted.sort((a, b) => b.totalTrips.compareTo(a.totalTrips));
        break;
      default:
        break;
    }
    
    filteredCarriers.value = sorted;
  }

  Color getRatingColor(double rating) {
    if (rating >= 4.5) {
      return const Color(0xFF4CAF50); // Green
    } else if (rating >= 4.0) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  String getRatingText(double rating) {
    if (rating >= 4.5) {
      return 'Excellent';
    } else if (rating >= 4.0) {
      return 'Good';
    } else if (rating >= 3.5) {
      return 'Average';
    } else {
      return 'Below Average';
    }
  }
}