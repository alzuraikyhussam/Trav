import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/trip_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/services/api_service.dart';

class TravelerInfoController extends GetxController with GetTickerProviderStateMixin {
  // Services
  final ApiService _apiService = Get.find<ApiService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Trip and booking data
  late Trip trip;
  late List<String> selectedSeatIds;
  late double totalAmount;

  // Form controllers for each traveler
  final RxList<TravelerFormData> travelers = <TravelerFormData>[].obs;
  final RxInt currentTravelerIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Animation controllers
  late AnimationController slideAnimationController;
  late AnimationController fadeAnimationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  // OCR and image processing
  final RxBool isProcessingOCR = false.obs;
  final RxString ocrError = ''.obs;

  // Nationality options
  final List<String> nationalities = [
    'Egyptian', 'Saudi Arabian', 'Emirati', 'Kuwaiti', 'Qatari',
    'Bahraini', 'Omani', 'Jordanian', 'Lebanese', 'Syrian',
    'Iraqi', 'Palestinian', 'Moroccan', 'Tunisian', 'Algerian',
    'Libyan', 'Sudanese', 'Yemeni', 'American', 'British',
    'Canadian', 'Australian', 'German', 'French', 'Italian',
    'Spanish', 'Dutch', 'Swedish', 'Norwegian', 'Indian',
    'Pakistani', 'Bangladeshi', 'Sri Lankan', 'Chinese',
    'Japanese', 'Korean', 'Filipino', 'Thai', 'Malaysian',
    'Indonesian', 'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _initializeAnimations();
    _setupTravelers();
  }

  void _initializeData() {
    final arguments = Get.arguments;
    if (arguments != null) {
      trip = arguments['trip'];
      selectedSeatIds = List<String>.from(arguments['selectedSeatIds']);
      totalAmount = arguments['totalAmount'];
    }
  }

  void _initializeAnimations() {
    slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.easeInOut,
    ));

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeAnimationController,
      curve: Curves.easeIn,
    ));

    fadeAnimationController.forward();
  }

  void _setupTravelers() {
    travelers.clear();
    for (int i = 0; i < selectedSeatIds.length; i++) {
      travelers.add(TravelerFormData(seatId: selectedSeatIds[i]));
    }
  }

  void nextTraveler() {
    if (currentTravelerIndex.value < travelers.length - 1) {
      if (_validateCurrentTraveler()) {
        slideAnimationController.forward().then((_) {
          currentTravelerIndex.value++;
          slideAnimationController.reverse();
        });
      }
    }
  }

  void previousTraveler() {
    if (currentTravelerIndex.value > 0) {
      slideAnimationController.forward().then((_) {
        currentTravelerIndex.value--;
        slideAnimationController.reverse();
      });
    }
  }

  bool _validateCurrentTraveler() {
    final traveler = travelers[currentTravelerIndex.value];
    
    if (traveler.firstNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter first name');
      return false;
    }
    
    if (traveler.lastNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter last name');
      return false;
    }
    
    if (traveler.selectedGender.value.isEmpty) {
      _showErrorSnackbar('Please select gender');
      return false;
    }
    
    if (traveler.selectedNationality.value.isEmpty) {
      _showErrorSnackbar('Please select nationality');
      return false;
    }
    
    if (traveler.passportController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter passport number');
      return false;
    }
    
    if (traveler.selectedDateOfBirth.value == null) {
      _showErrorSnackbar('Please select date of birth');
      return false;
    }

    return true;
  }

  Future<void> scanPassport() async {
    try {
      // Check camera permission
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        _showErrorSnackbar('Camera permission is required for passport scanning');
        return;
      }

      isProcessingOCR.value = true;
      ocrError.value = '';

      // Pick image from camera
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        // Simulate OCR processing (replace with actual OCR service)
        await Future.delayed(const Duration(seconds: 2));
        
        // Mock OCR results - replace with actual OCR implementation
        final mockOCRData = _generateMockOCRData();
        _fillFormWithOCRData(mockOCRData);
        
        Get.snackbar(
          'Success',
          'Passport information extracted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      ocrError.value = 'Failed to process passport image: ${e.toString()}';
      _showErrorSnackbar(ocrError.value);
    } finally {
      isProcessingOCR.value = false;
    }
  }

  Map<String, dynamic> _generateMockOCRData() {
    // Mock OCR data - replace with actual OCR service integration
    return {
      'firstName': 'John',
      'lastName': 'Doe',
      'passportNumber': 'A12345678',
      'nationality': 'American',
      'dateOfBirth': '1990-01-15',
      'expiryDate': '2030-01-15',
      'gender': 'Male',
    };
  }

  void _fillFormWithOCRData(Map<String, dynamic> ocrData) {
    final currentTraveler = travelers[currentTravelerIndex.value];
    
    currentTraveler.firstNameController.text = ocrData['firstName'] ?? '';
    currentTraveler.lastNameController.text = ocrData['lastName'] ?? '';
    currentTraveler.passportController.text = ocrData['passportNumber'] ?? '';
    currentTraveler.selectedNationality.value = ocrData['nationality'] ?? '';
    currentTraveler.selectedGender.value = ocrData['gender'] ?? '';
    
    if (ocrData['dateOfBirth'] != null) {
      try {
        currentTraveler.selectedDateOfBirth.value = DateTime.parse(ocrData['dateOfBirth']);
      } catch (e) {
        print('Error parsing date of birth: $e');
      }
    }
    
    if (ocrData['expiryDate'] != null) {
      try {
        currentTraveler.selectedPassportExpiry.value = DateTime.parse(ocrData['expiryDate']);
      } catch (e) {
        print('Error parsing passport expiry: $e');
      }
    }
  }

  Future<void> selectDate(BuildContext context, {required bool isDateOfBirth}) async {
    final currentTraveler = travelers[currentTravelerIndex.value];
    final initialDate = isDateOfBirth 
        ? (currentTraveler.selectedDateOfBirth.value ?? DateTime(1990))
        : (currentTraveler.selectedPassportExpiry.value ?? DateTime.now().add(const Duration(days: 365)));
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isDateOfBirth ? DateTime(1900) : DateTime.now(),
      lastDate: isDateOfBirth ? DateTime.now() : DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isDateOfBirth) {
        currentTraveler.selectedDateOfBirth.value = picked;
      } else {
        currentTraveler.selectedPassportExpiry.value = picked;
      }
    }
  }

  Future<void> proceedToPayment() async {
    if (!_validateAllTravelers()) return;

    try {
      isLoading.value = true;
      error.value = '';

      // Create booking data
      final bookingData = _createBookingData();
      
      // Navigate to payment
      Get.toNamed('/payment', arguments: {
        'trip': trip,
        'selectedSeatIds': selectedSeatIds,
        'travelers': bookingData['travelers'],
        'totalAmount': totalAmount,
      });

    } catch (e) {
      error.value = 'Failed to process traveler information: ${e.toString()}';
      _showErrorSnackbar(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateAllTravelers() {
    for (int i = 0; i < travelers.length; i++) {
      currentTravelerIndex.value = i;
      if (!_validateCurrentTraveler()) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> _createBookingData() {
    return {
      'trip_id': trip.id,
      'selected_seat_ids': selectedSeatIds,
      'total_amount': totalAmount,
      'travelers': travelers.map((traveler) => {
        'first_name': traveler.firstNameController.text.trim(),
        'last_name': traveler.lastNameController.text.trim(),
        'gender': traveler.selectedGender.value,
        'date_of_birth': traveler.selectedDateOfBirth.value?.toIso8601String(),
        'nationality': traveler.selectedNationality.value,
        'passport_number': traveler.passportController.text.trim(),
        'passport_expiry': traveler.selectedPassportExpiry.value?.toIso8601String(),
        'seat_id': traveler.seatId,
      }).toList(),
    };
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  String getSeatNumber(String seatId) {
    final seat = trip.seats.firstWhere((s) => s.id == seatId);
    return seat.seatNumber;
  }

  @override
  void onClose() {
    slideAnimationController.dispose();
    fadeAnimationController.dispose();
    for (var traveler in travelers) {
      traveler.dispose();
    }
    super.onClose();
  }
}

class TravelerFormData {
  final String seatId;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final RxString selectedNationality = ''.obs;
  final Rx<DateTime?> selectedDateOfBirth = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedPassportExpiry = Rx<DateTime?>(null);

  TravelerFormData({required this.seatId});

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passportController.dispose();
  }
}