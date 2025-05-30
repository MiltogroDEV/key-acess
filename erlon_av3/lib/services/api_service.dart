
import 'package:dio/dio.dart';
import 'package:erlon_av3/utils/local_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://7a50-2804-214-85c5-cfc7-6187-1987-3ee4-f2f9.ngrok-free.app/api/v1'));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Dio get client => _dio;
}
