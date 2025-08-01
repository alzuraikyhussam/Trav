import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/custom_widgets.dart';
import '../controllers/trips_controller.dart';

class TripsView extends GetView<TripsController> {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),
            
            // Filters Section
            _buildFiltersSection(),
            
            // Trips List
            Expanded(
              child: _buildTripsList(),
            ),
          ],
        ),
      ),
      // Floating Action Button for Quick Filters
      floatingActionButton: AnimatedFAB(
        icon: Icons.tune,
        tooltip: 'Advanced Filters',
        backgroundColor: AppColors.secondary,
        onPressed: () => _showAdvancedFilters(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final carrierName = arguments['carrierName'] ?? 'Selected Carrier';
    final route = arguments['route'] ?? 'All Routes';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Top Row with Back Button
          Row(
            children: [
              AnimatedIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () => Get.back(),
                backgroundColor: AppColors.whiteWithOpacity(0.2),
                color: AppColors.white,
                tooltip: 'Back to Carriers',
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const Spacer(),
              
              AnimatedIconButton(
                icon: Icons.favorite_outline,
                backgroundColor: AppColors.whiteWithOpacity(0.2),
                color: AppColors.white,
                tooltip: 'Favorites',
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Favorites feature will be available soon!',
                    backgroundColor: AppColors.info,
                    colorText: Colors.white,
                  );
                },
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.3, end: 0),
            ],
          ),
          
          const Gap(20),
          
          // Title and Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Trips',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0)
                  .then(delay: 200.ms)
                  .shimmer(duration: 1000.ms, color: AppColors.white.withOpacity(0.3)),
              
              const Gap(8),
              
              Row(
                children: [
                  Icon(
                    Icons.directions_bus,
                    color: AppColors.whiteWithOpacity(0.8),
                    size: 16,
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.5, 0.5)),
                  
                  const Gap(8),
                  
                  Expanded(
                    child: Text(
                      '$carrierName • $route',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteWithOpacity(0.8),
                      ),
                    )
                        .animate(delay: 600.ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: 0.2, end: 0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Quick Filters Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AnimatedChip(
                  label: 'All Times',
                  icon: Icons.schedule,
                  isSelected: true,
                  onTap: () {},
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Morning',
                  icon: Icons.wb_sunny,
                  onTap: () {},
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Afternoon',
                  icon: Icons.wb_sunny_outlined,
                  onTap: () {},
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Evening',
                  icon: Icons.nightlight_round,
                  onTap: () {},
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Express',
                  icon: Icons.speed,
                  selectedColor: AppColors.secondary,
                  onTap: () {},
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: -0.5, end: 0),
          
          const Gap(16),
          
          // Search and Sort Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AnimatedTextField(
                  labelText: 'Search trips...',
                  hintText: 'Destination, time, etc.',
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    // Implement search logic
                  },
                ),
              ),
              const Gap(12),
              AnimatedIconButton(
                icon: Icons.sort,
                backgroundColor: AppColors.lightGrey,
                onPressed: () => _showSortOptions(context),
                tooltip: 'Sort Options',
              ),
            ],
          )
              .animate(delay: 1000.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildTripsList() {
    // Mock trip data for demonstration
    final trips = _getMockTrips();

    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildTripCard(trip, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedCard(
        onTap: () => _selectTrip(trip),
        child: Column(
          children: [
            // Trip Header
            Row(
              children: [
                // Route Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          )
                              .animate()
                              .scale(begin: const Offset(0, 0), duration: 400.ms)
                              .then()
                              .animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              )
                              .scaleXY(end: 1.2, duration: 2000.ms),
                          
                          const Gap(8),
                          
                          Expanded(
                            child: Text(
                              '${trip['origin']} → ${trip['destination']}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: 0.2, end: 0),
                          ),
                        ],
                      ),
                      
                      const Gap(4),
                      
                      Text(
                        trip['vehicle_type'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.accentGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '\$${trip['price']}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    .animate()
                    .scale(begin: const Offset(0.8, 0.8), duration: 300.ms)
                    .then()
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(duration: 3000.ms, color: AppColors.white.withOpacity(0.3)),
              ],
            ),
            
            const Gap(16),
            
            // Time and Duration Info
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    'Departure',
                    trip['departure_time'],
                    Icons.schedule,
                    AppColors.primary,
                  ),
                ),
                
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Container(
                    width: 20,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .slideX(begin: -1, end: 1, duration: 2000.ms),
                ),
                
                Expanded(
                  child: _buildTimeInfo(
                    'Arrival',
                    trip['arrival_time'],
                    Icons.flag,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
            
            const Gap(16),
            
            // Trip Features
            Row(
              children: [
                _buildFeature(Icons.airline_seat_recline_normal, '${trip['available_seats']} seats'),
                const Gap(16),
                _buildFeature(Icons.access_time, trip['duration']),
                const Gap(16),
                _buildFeature(Icons.wifi, 'WiFi'),
                const Spacer(),
                
                AnimatedSecondaryButton(
                  text: 'Book Now',
                  icon: Icons.event_seat,
                  width: 120,
                  onPressed: () => _selectTrip(trip),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideX(begin: 0.3, end: 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color)
                .animate()
                .scale(begin: const Offset(0, 0), duration: 300.ms),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Gap(4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        )
            .animate()
            .scale(begin: const Offset(0, 0), duration: 200.ms),
        const Gap(4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _selectTrip(Map<String, dynamic> trip) {
    Get.snackbar(
      'Trip Selected!',
      'Proceeding to seat selection for ${trip['origin']} → ${trip['destination']}',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Navigate to trip details/seat selection
    // Get.toNamed(Routes.tripDetails, arguments: trip);
  }

  void _showSortOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort Trips By',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.3, end: 0),
            
            const Gap(20),
            
            ...['Price (Low to High)', 'Price (High to Low)', 'Departure Time', 'Duration', 'Availability']
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final option = entry.value;
              
              return AnimatedCard(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Sorting',
                    'Trips sorted by $option',
                    backgroundColor: AppColors.info,
                    colorText: Colors.white,
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      _getSortIcon(index),
                      color: AppColors.primary,
                    ),
                    const Gap(16),
                    Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )
                  .animate(delay: (100 * index).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.3, end: 0);
            }).toList(),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 1, end: 0);
  }

  void _showAdvancedFilters(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Advanced Filters',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.3, end: 0),
              
              const Gap(20),
              
              // Filter options would go here
              const Text('Filter options coming soon!')
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms),
              
              const Gap(24),
              
              Row(
                children: [
                  Expanded(
                    child: AnimatedSecondaryButton(
                      text: 'Reset',
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AnimatedPrimaryButton(
                      text: 'Apply',
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8)),
    );
  }

  IconData _getSortIcon(int index) {
    switch (index) {
      case 0:
      case 1:
        return Icons.attach_money;
      case 2:
        return Icons.schedule;
      case 3:
        return Icons.timer;
      case 4:
        return Icons.event_seat;
      default:
        return Icons.sort;
    }
  }

  List<Map<String, dynamic>> _getMockTrips() {
    return [
      {
        'id': '1',
        'origin': 'New York',
        'destination': 'Boston',
        'departure_time': '08:30 AM',
        'arrival_time': '12:15 PM',
        'duration': '3h 45m',
        'price': 45,
        'available_seats': 12,
        'vehicle_type': 'Express Bus',
      },
      {
        'id': '2',
        'origin': 'New York',
        'destination': 'Boston',
        'departure_time': '02:00 PM',
        'arrival_time': '05:30 PM',
        'duration': '3h 30m',
        'price': 42,
        'available_seats': 8,
        'vehicle_type': 'Standard Bus',
      },
      {
        'id': '3',
        'origin': 'New York',
        'destination': 'Boston',
        'departure_time': '06:45 PM',
        'arrival_time': '10:15 PM',
        'duration': '3h 30m',
        'price': 38,
        'available_seats': 15,
        'vehicle_type': 'Economy Bus',
      },
      {
        'id': '4',
        'origin': 'New York',
        'destination': 'Boston',
        'departure_time': '11:00 PM',
        'arrival_time': '02:45 AM',
        'duration': '3h 45m',
        'price': 35,
        'available_seats': 20,
        'vehicle_type': 'Night Express',
      },
    ];
  }
}