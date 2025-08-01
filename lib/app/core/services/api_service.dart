import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../constants/app_constants.dart';
import '../storage/storage_service.dart';

class ApiService extends getx.GetxService {
  late Dio _dio;
  final StorageService _storageService = getx.Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.fullApiUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.httpTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.httpTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.httpTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  // Auth Interceptor
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storageService.getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final refreshToken = _storageService.getRefreshToken();
          if (refreshToken != null) {
            try {
              final response = await _dio.post(
                AppConstants.refreshTokenEndpoint,
                data: {'refresh_token': refreshToken},
              );
              
              if (response.statusCode == 200) {
                final newToken = response.data['access_token'];
                await _storageService.saveAuthToken(newToken);
                
                // Retry the original request
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                final cloneReq = await _dio.fetch(opts);
                handler.resolve(cloneReq);
                return;
              }
            } catch (e) {
              // Refresh failed, logout user
              await _logout();
            }
          } else {
            // No refresh token, logout user
            await _logout();
          }
        }
        handler.next(error);
      },
    );
  }

  // Logging Interceptor
  LogInterceptor _loggingInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) {
        // In production, you might want to use a proper logging service
        print(obj);
      },
    );
  }

  // Error Interceptor
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String errorMessage = 'An unexpected error occurred';
        
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Connection timeout. Please try again.';
        } else if (error.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        } else if (error.response != null) {
          switch (error.response!.statusCode) {
            case 400:
              errorMessage = error.response!.data['message'] ?? 'Bad request';
              break;
            case 401:
              errorMessage = 'Unauthorized access';
              break;
            case 403:
              errorMessage = 'Access forbidden';
              break;
            case 404:
              errorMessage = 'Resource not found';
              break;
            case 500:
              errorMessage = 'Server error. Please try again later.';
              break;
            default:
              errorMessage = 'Something went wrong. Please try again.';
          }
        }

        error.error = errorMessage;
        handler.next(error);
      },
    );
  }

  // Logout helper
  Future<void> _logout() async {
    await _storageService.clearTokens();
    await _storageService.clearUserData();
    await _storageService.setLoggedIn(false);
    getx.Get.offAllNamed('/login');
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Cancel requests
  void cancelRequests() {
    _dio.interceptors.requestLock.clear();
    _dio.interceptors.responseLock.clear();
    _dio.interceptors.errorLock.clear();
  }
}