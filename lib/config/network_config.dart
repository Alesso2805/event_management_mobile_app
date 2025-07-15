import 'package:dio/dio.dart';

class NetworkConfig {
  static const String baseUrl = 'http://localhost:8080/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Dio createDio() {
    final dio = Dio();
    
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.sendTimeout = sendTimeout;
    dio.options.headers = defaultHeaders;
    
    // Interceptor para logging en desarrollo
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
    
    return dio;
  }
  
  // Método para verificar conectividad
  static Future<bool> checkConnectivity() async {
    try {
      final dio = createDio();
      final response = await dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
