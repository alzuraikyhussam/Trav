import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/custom_widgets.dart';
import '../controllers/carriers_controller.dart';
import '../../../data/models/carrier_model.dart';

class CarriersView extends GetView<CarriersController> {
  const CarriersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Search Bar with Filters
            _buildSearchSection(),
            
            // Carriers List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.filteredCarriers.isEmpty) {
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.refreshCarriers(),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.filteredCarriers.length,
                      itemBuilder: (context, index) {
                        final carrier = controller.filteredCarriers[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildCarrierCard(context, carrier, index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // Animated FAB
      floatingActionButton: AnimatedFAB(
        icon: Icons.filter_list,
        tooltip: 'Filters',
        onPressed: () {
          _showFiltersDialog(context);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Carrier',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0)
                    .then(delay: 200.ms)
                    .shimmer(duration: 1000.ms, color: AppColors.white.withOpacity(0.3)),
                const Gap(4),
                Text(
                  'Select from our trusted transport partners',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteWithOpacity(0.8),
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.2, end: 0),
              ],
            ),
          ),
          AnimatedIconButton(
            icon: Icons.logout,
            onPressed: controller.logout,
            tooltip: 'Logout',
            backgroundColor: AppColors.whiteWithOpacity(0.2),
            color: AppColors.white,
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Field
          AnimatedTextField(
            onChanged: controller.searchCarriers,
            labelText: 'Search carriers...',
            hintText: 'Enter carrier name or service type',
            prefixIcon: Icons.search,
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: -0.3, end: 0),
          
          const Gap(16),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AnimatedChip(
                  label: 'All',
                  icon: Icons.all_inclusive,
                  isSelected: true,
                  onTap: () {
                    // Filter logic
                  },
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Premium',
                  icon: Icons.star,
                  onTap: () {
                    // Filter logic
                  },
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Budget',
                  icon: Icons.money_off,
                  onTap: () {
                    // Filter logic
                  },
                ),
                const Gap(8),
                AnimatedChip(
                  label: 'Fast',
                  icon: Icons.speed,
                  onTap: () {
                    // Filter logic
                  },
                ),
              ],
            ),
          )
              .animate(delay: 800.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildCarrierCard(BuildContext context, Carrier carrier, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedCard(
        onTap: () => controller.selectCarrier(carrier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Carrier Logo Placeholder
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGradient[index % 2],
                        AppColors.secondaryGradient[index % 2],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGradient[index % 2].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: AppColors.white,
                    size: 30,
                  ),
                )
                    .animate()
                    .scale(begin: const Offset(0.8, 0.8), duration: 400.ms)
                    .then()
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(end: 1.05, duration: 2000.ms),
                
                const Gap(16),
                
                // Carrier Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carrier.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0),
                      const Gap(4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          )
                              .animate()
                              .scale(begin: const Offset(0, 0), duration: 300.ms)
                              .then()
                              .animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              )
                              .rotate(duration: 3000.ms),
                          const Gap(4),
                          Text(
                            '${carrier.rating}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '(${carrier.totalTrips} trips)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                AnimatedIconButton(
                  icon: Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  backgroundColor: Colors.transparent,
                  size: 16,
                  onPressed: () => controller.selectCarrier(carrier),
                ),
              ],
            ),
            
            const Gap(16),
            
            // Description
            Text(
              carrier.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
            
            const Gap(16),
            
            // Amenities
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 16,
                  )
                      .animate()
                      .scale(begin: const Offset(0, 0), duration: 400.ms)
                      .then()
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .scaleXY(end: 1.1, duration: 1500.ms),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      controller.getAmenitiesText(carrier.amenities),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .scaleY(begin: 0.8, end: 1.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 1000.ms)
              .then()
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(end: 1.2, duration: 800.ms),
          const Gap(16),
          Text(
            'Loading carriers...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(begin: 0.5, end: 1.0, duration: 1000.ms),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          )
              .animate()
              .scale(begin: const Offset(0.5, 0.5), duration: 600.ms)
              .then()
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(end: 1.1, duration: 2000.ms),
          const Gap(16),
          Text(
            'No carriers found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          const Gap(8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
          const Gap(24),
          AnimatedPrimaryButton(
            text: 'Refresh',
            icon: Icons.refresh,
            onPressed: controller.refreshCarriers,
            width: 200,
          )
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
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
                'Filter Carriers',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.3, end: 0),
              const Gap(20),
              
              // Filter Options
              Column(
                children: [
                  _buildFilterOption('Rating', '4.0+'),
                  _buildFilterOption('Price Range', '\$20 - \$100'),
                  _buildFilterOption('Amenities', 'WiFi, AC'),
                ],
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
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

  Widget _buildFilterOption(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}