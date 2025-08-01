import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trips_controller.dart';

class TripsView extends GetView<TripsController> {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Trips'),
      ),
      body: const Center(
        child: Text(
          'Trips View - Coming Soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}