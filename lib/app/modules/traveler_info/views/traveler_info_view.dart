import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/traveler_info_controller.dart';

class TravelerInfoView extends GetView<TravelerInfoController> {
  const TravelerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traveler Info')),
      body: const Center(child: Text('Traveler Info - Coming Soon!')),
    );
  }
}