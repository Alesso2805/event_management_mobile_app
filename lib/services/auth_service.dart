import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';
  
  // Modo de prueba para testing sin servidor
  static const bool _mockMode = true; // Cambiar a false cuando el servidor esté listo

  final Dio _dio;

  AuthService() : _dio = Dio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.sendTimeout = ApiConfig.sendTimeout;
    _dio.options.headers = ApiConfig.defaultHeaders;

    // Interceptor para logging (útil para debugging)
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Interceptor para agregar el token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Manejar errores de conexión
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.connectionError) {
            // Reintentar una vez
            try {
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              // Si falla el reintento, continuar con el error original
            }
          }
          
          if (error.response?.statusCode == 401) {
            // Token expirado, intentar renovar
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Reintentar la petición original
              final options = error.requestOptions;
              final token = await getAccessToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              try {
                final response = await _dio.fetch(options);
                handler.resolve(response);
                return;
              } catch (e) {
                // Si falla el reintento, continuar con el error original
              }
            }
            // Si no se puede renovar, cerrar sesión
            await logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  // Autenticación
  Future<AuthResult> login(String email, String password) async {
    // Modo mock para testing
    if (_mockMode) {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validación básica
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.failure('Email y contraseña son requeridos');
      }
      
      if (password.length < 6) {
        return AuthResult.failure('La contraseña debe tener al menos 6 caracteres');
      }
      
      // Simular datos de usuario
      final userData = {
        'id': '1',
        'firstName': 'Usuario',
        'lastName': 'Demo',
        'email': email,
        'phoneNumber': null,
        'role': 'USER',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // Simular tokens
      const accessToken = 'mock_access_token';
      const refreshToken = 'mock_refresh_token';
      
      await _saveTokens(accessToken, refreshToken);
      await _saveUserData(userData);
      
      try {
        return AuthResult.success(User.fromJson(userData));
      } catch (e) {
        return AuthResult.failure('Error al procesar los datos del usuario: ${e.toString()}');
      }
    }
    
    // Código original para servidor real
    try {
      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userData = data['user'];

        await _saveTokens(accessToken, refreshToken);
        await _saveUserData(userData);

        return AuthResult.success(User.fromJson(userData));
      } else {
        return AuthResult.failure('Error en el inicio de sesión');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_handleDioError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    // Modo mock para testing
    if (_mockMode) {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular datos de usuario
      final userData = {
        'id': '1',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': 'USER',
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // Simular tokens
      const accessToken = 'mock_access_token';
      const refreshToken = 'mock_refresh_token';
      
      await _saveTokens(accessToken, refreshToken);
      await _saveUserData(userData);
      
      try {
        return AuthResult.success(User.fromJson(userData));
      } catch (e) {
        return AuthResult.failure('Error al procesar los datos del usuario: ${e.toString()}');
      }
    }
    
    // Código original para servidor real
    try {
      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userData = data['user'];

        await _saveTokens(accessToken, refreshToken);
        await _saveUserData(userData);

        return AuthResult.success(User.fromJson(userData));
      } else {
        return AuthResult.failure('Error en el registro');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_handleDioError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }

  // Verificar si el usuario está autenticado (versión simplificada)
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Gestión de tokens
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _tokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // Gestión de datos del usuario
  Future<User?> getCurrentUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userKey, value: jsonEncode(userData));
  }

  Future<void> _clearUserData() async {
    await _storage.delete(key: _userKey);
  }

  // Renovar token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        ApiConfig.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        await _saveTokens(newAccessToken, newRefreshToken);
        return true;
      }
    } catch (e) {
      // Error al renovar token
    }
    return false;
  }

  // Manejar errores de Dio
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado. Verifica tu conexión a internet.';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado. Verifica tu conexión a internet.';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de recepción agotado. Verifica tu conexión a internet.';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica que el servidor esté disponible.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return 'Credenciales inválidas';
        } else if (e.response?.statusCode == 403) {
          return 'Acceso prohibido';
        } else if (e.response?.statusCode == 404) {
          return 'Recurso no encontrado';
        } else if (e.response?.statusCode == 422) {
          return 'Datos inválidos. Verifica la información ingresada.';
        } else if (e.response?.statusCode == 500) {
          return 'Error interno del servidor';
        }
        return 'Error del servidor: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Petición cancelada';
      case DioExceptionType.unknown:
        if (e.message?.contains('SocketException') == true) {
          return 'No se puede conectar al servidor. Verifica tu conexión a internet.';
        }
        return 'Error de conexión desconocido';
      default:
        return 'Error inesperado: ${e.message}';
    }
  }

  // Cerrar sesión
  Future<bool> logout() async {
    try {
      await _dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      // Ignorar errores al cerrar sesión en el servidor
    }    await _clearTokens();
    await _clearUserData();
    
    return true;
  }

  // Recuperar contraseña
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiConfig.forgotPasswordEndpoint,
        data: {'email': email},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Restablecer contraseña
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.resetPasswordEndpoint,
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Cambiar contraseña
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Verificar email
  Future<bool> verifyEmail(String token) async {
    try {
      final response = await _dio.post(
        ApiConfig.verifyEmailEndpoint,
        data: {'token': token},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }
}

// Resultado de autenticación
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(User user) {
    return AuthResult._(
      isSuccess: true,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}
