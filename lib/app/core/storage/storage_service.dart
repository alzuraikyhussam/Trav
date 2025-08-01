import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _box = GetStorage();
  }

  // Token Management
  Future<void> saveAuthToken(String token) async {
    await _box.write(AppConstants.authTokenKey, token);
  }

  String? getAuthToken() {
    return _box.read(AppConstants.authTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _box.write(AppConstants.refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _box.read(AppConstants.refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _box.remove(AppConstants.authTokenKey);
    await _box.remove(AppConstants.refreshTokenKey);
  }

  // User Data Management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(AppConstants.userDataKey, userData);
  }

  Map<String, dynamic>? getUserData() {
    return _box.read(AppConstants.userDataKey);
  }

  Future<void> clearUserData() async {
    await _box.remove(AppConstants.userDataKey);
  }

  // Authentication State
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _box.write(AppConstants.isLoggedInKey, isLoggedIn);
  }

  bool isLoggedIn() {
    return _box.read(AppConstants.isLoggedInKey) ?? false;
  }

  // Onboarding State
  Future<void> setHasSeenOnboarding(bool hasSeen) async {
    await _box.write(AppConstants.hasSeenOnboardingKey, hasSeen);
  }

  bool hasSeenOnboarding() {
    return _box.read(AppConstants.hasSeenOnboardingKey) ?? false;
  }

  // Generic Storage Methods
  Future<void> save(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }

  // Check if key exists
  bool hasKey(String key) {
    return _box.hasData(key);
  }

  // Get all keys
  Iterable<String> getKeys() {
    return _box.getKeys();
  }

  // Get all values
  Iterable<dynamic> getValues() {
    return _box.getValues();
  }
}