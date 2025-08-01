import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/constants/app_colors.dart';
import 'app/routes/app_pages.dart';
import 'app/core/storage/storage_service.dart';
import 'app/core/services/api_service.dart';
import 'app/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initServices();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(MyApp());
}

Future<void> initServices() async {
  print('Starting services...');
  
  // Initialize Storage Service first
  await Get.putAsync(() => StorageService().init());
  print('Storage Service initialized');
  
  // Initialize API Service
  Get.put(ApiService());
  print('API Service initialized');
  
  // Initialize Auth Service
  Get.put(AuthService());
  print('Auth Service initialized');
  
  print('All services started...');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'TravelEase',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        );
      },
    );
  }
}

// Extensions for the Storage Service initialization
extension StorageServiceExt on StorageService {
  Future<StorageService> init() async {
    await onInit();
    return this;
  }
}