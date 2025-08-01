import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/carriers/bindings/carriers_binding.dart';
import '../modules/carriers/views/carriers_view.dart';
import '../modules/trips/bindings/trips_binding.dart';
import '../modules/trips/views/trips_view.dart';
import '../modules/trip_details/bindings/trip_details_binding.dart';
import '../modules/trip_details/views/trip_details_view.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => const OtpVerificationView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.carriers,
      page: () => const CarriersView(),
      binding: CarriersBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.trips,
      page: () => const TripsView(),
      binding: TripsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.tripDetails,
      page: () => const TripDetailsView(),
      binding: TripDetailsBinding(),
      transition: Transition.cupertino,
    ),
  ];
}