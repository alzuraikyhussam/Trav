import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../storage/storage_service.dart';
import 'api_service.dart';
import '../../data/models/user_model.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isLoading = false.obs;

  // Getters
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  // Check authentication state on app start
  void _checkAuthState() {
    final token = _storageService.getAuthToken();
    final userData = _storageService.getUserData();
    final isLoggedIn = _storageService.isLoggedIn();

    if (token != null && userData != null && isLoggedIn) {
      _currentUser.value = User.fromJson(userData);
      _isLoggedIn.value = true;
    }
  }

  // Login with phone and password
  Future<ApiResponse<User>> login(String phone, String password) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['user']);
        final token = data['access_token'];
        final refreshToken = data['refresh_token'];

        // Save authentication data
        await _storageService.saveAuthToken(token);
        await _storageService.saveRefreshToken(refreshToken);
        await _storageService.saveUserData(user.toJson());
        await _storageService.setLoggedIn(true);

        // Update state
        _currentUser.value = user;
        _isLoggedIn.value = true;

        return ApiResponse<User>(
          success: true,
          data: user,
          message: data['message'] ?? 'Login successful',
        );
      }

      return ApiResponse<User>(
        success: false,
        message: response.data['message'] ?? 'Login failed',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Register new user
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String phone,
    required String password,
    required String name,
    required String email,
  }) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        data: {
          'phone': phone,
          'password': password,
          'name': name,
          'email': email,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          data: response.data,
          message: response.data['message'] ?? 'Registration successful',
        );
      }

      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: response.data['message'] ?? 'Registration failed',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Verify OTP
  Future<ApiResponse<User>> verifyOtp(String phone, String otp) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.post(
        AppConstants.verifyOtpEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['user']);
        final token = data['access_token'];
        final refreshToken = data['refresh_token'];

        // Save authentication data
        await _storageService.saveAuthToken(token);
        await _storageService.saveRefreshToken(refreshToken);
        await _storageService.saveUserData(user.toJson());
        await _storageService.setLoggedIn(true);

        // Update state
        _currentUser.value = user;
        _isLoggedIn.value = true;

        return ApiResponse<User>(
          success: true,
          data: user,
          message: data['message'] ?? 'OTP verification successful',
        );
      }

      return ApiResponse<User>(
        success: false,
        message: response.data['message'] ?? 'OTP verification failed',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Resend OTP
  Future<ApiResponse<String>> resendOtp(String phone) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.post(
        '${AppConstants.verifyOtpEndpoint}/resend',
        data: {'phone': phone},
      );

      if (response.statusCode == 200) {
        return ApiResponse<String>(
          success: true,
          message: response.data['message'] ?? 'OTP sent successfully',
        );
      }

      return ApiResponse<String>(
        success: false,
        message: response.data['message'] ?? 'Failed to send OTP',
      );
    } catch (e) {
      return ApiResponse<String>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      // await _apiService.post('/auth/logout');
      
      // Clear local data
      await _storageService.clearTokens();
      await _storageService.clearUserData();
      await _storageService.setLoggedIn(false);

      // Update state
      _currentUser.value = null;
      _isLoggedIn.value = false;

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Update user profile
  Future<ApiResponse<User>> updateProfile(Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.put(
        AppConstants.profileEndpoint,
        data: userData,
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['user']);
        
        // Save updated user data
        await _storageService.saveUserData(user.toJson());
        _currentUser.value = user;

        return ApiResponse<User>(
          success: true,
          data: user,
          message: response.data['message'] ?? 'Profile updated successfully',
        );
      }

      return ApiResponse<User>(
        success: false,
        message: response.data['message'] ?? 'Profile update failed',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Change password
  Future<ApiResponse<String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.put(
        '${AppConstants.profileEndpoint}/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse<String>(
          success: true,
          message: response.data['message'] ?? 'Password changed successfully',
        );
      }

      return ApiResponse<String>(
        success: false,
        message: response.data['message'] ?? 'Password change failed',
      );
    } catch (e) {
      return ApiResponse<String>(
        success: false,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });
}