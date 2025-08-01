class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.travelbooking.com';
  static const String apiVersion = '/v1';
  static const String fullApiUrl = baseUrl + apiVersion;
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String carriersEndpoint = '/carriers';
  static const String tripsEndpoint = '/trips';
  static const String bookingEndpoint = '/bookings';
  static const String paymentEndpoint = '/payments';
  static const String profileEndpoint = '/profile';
  
  // App Configuration
  static const int httpTimeout = 30000; // 30 seconds
  static const int otpResendTime = 60; // 60 seconds
  static const int splashDuration = 3000; // 3 seconds
  
  // Animation Durations
  static const int defaultAnimationDuration = 300;
  static const int pageTransitionDuration = 250;
  static const int splashAnimationDuration = 2000;
  
  // Validation
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  static const int passwordMinLength = 6;
}