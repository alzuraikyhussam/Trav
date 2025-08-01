import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/carrier_model.dart';
import '../../../routes/app_routes.dart';

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
    isLoading.value = true;

    try {
      // For demo purposes, using mock data
      // In production, this would be: await _apiService.get(AppConstants.carriersEndpoint);
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final mockCarriers = [
        Carrier(
          id: '1',
          name: 'Swift Transport',
          description: 'Premium bus service with comfortable seating and excellent punctuality',
          logo: 'https://example.com/swift-logo.png',
          rating: 4.5,
          totalTrips: 150,
          amenities: ['WiFi', 'AC', 'Charging Port', 'Snacks'],
          isActive: true,
        ),
        Carrier(
          id: '2',
          name: 'Royal Express',
          description: 'Luxury travel experience with top-notch amenities and service',
          logo: 'https://example.com/royal-logo.png',
          rating: 4.8,
          totalTrips: 200,
          amenities: ['WiFi', 'AC', 'Entertainment', 'Meals', 'Blanket'],
          isActive: true,
        ),
        Carrier(
          id: '3',
          name: 'Metro Lines',
          description: 'Affordable and reliable transportation for everyday travel',
          logo: 'https://example.com/metro-logo.png',
          rating: 4.2,
          totalTrips: 300,
          amenities: ['AC', 'Music', 'Charging Port'],
          isActive: true,
        ),
        Carrier(
          id: '4',
          name: 'Golden Journey',
          description: 'Mid-range comfort with excellent value for money',
          logo: 'https://example.com/golden-logo.png',
          rating: 4.3,
          totalTrips: 120,
          amenities: ['WiFi', 'AC', 'Reading Light'],
          isActive: true,
        ),
        Carrier(
          id: '5',
          name: 'Speed Shuttle',
          description: 'Fast and efficient service for business travelers',
          logo: 'https://example.com/speed-logo.png',
          rating: 4.6,
          totalTrips: 180,
          amenities: ['WiFi', 'AC', 'Business Seats', 'Coffee'],
          isActive: true,
        ),
      ];

      carriers.value = mockCarriers;
      filteredCarriers.value = mockCarriers;

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load carriers: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchCarriers(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredCarriers.value = carriers;
    } else {
      filteredCarriers.value = carriers
          .where((carrier) =>
              carrier.name.toLowerCase().contains(query.toLowerCase()) ||
              carrier.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void selectCarrier(Carrier carrier) {
    Get.toNamed(
      Routes.trips,
      arguments: {'carrier': carrier},
    );
  }

  void refreshCarriers() {
    _loadCarriers();
  }

  void logout() {
    _authService.logout();
  }

  String getAmenitiesText(List<String> amenities) {
    if (amenities.length <= 3) {
      return amenities.join(' • ');
    } else {
      return '${amenities.take(3).join(' • ')} +${amenities.length - 3} more';
    }
  }
}