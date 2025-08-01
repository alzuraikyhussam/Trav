import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
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
            
            // Search Bar
            _buildSearchBar(),
            
            // Carriers List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                ),
                const Gap(4),
                Text(
                  'Select from our trusted transport partners',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteWithOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout, color: AppColors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: controller.searchCarriers,
        decoration: const InputDecoration(
          hintText: 'Search carriers...',
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCarrierCard(BuildContext context, Carrier carrier, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shadowColor: AppColors.blackWithOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => controller.selectCarrier(carrier),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                        color: AppColors.primaryGradient[index % 2],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                    
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
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.accent,
                                size: 16,
                              ),
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
                    
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
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
                ),
                
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
                      ),
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
                ),
              ],
            ),
          ),
        ),
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
          ),
          const Gap(16),
          Text(
            'No carriers found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}