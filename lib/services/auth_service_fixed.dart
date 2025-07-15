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

  // Cache para evitar llamadas repetidas a secure storage
  static bool? _isAuthenticatedCache;
  static DateTime? _lastAuthCheck;
  static const Duration _cacheExpiry = Duration(seconds: 30);

  final Dio _dio;

  AuthService() : _dio = Dio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = ApiConfig.defaultHeaders;

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

        // Actualizar caché
        _isAuthenticatedCache = true;
        _lastAuthCheck = DateTime.now();

        return AuthResult.success(User.fromJson(userData));
      } else {
        return AuthResult.failure('Error en el inicio de sesión');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_handleDioError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado: \${e.toString()}');
    }
  }

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
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

        // Actualizar caché
        _isAuthenticatedCache = true;
        _lastAuthCheck = DateTime.now();

        return AuthResult.success(User.fromJson(userData));
      } else {
        return AuthResult.failure('Error en el registro');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_handleDioError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado: \${e.toString()}');
    }
  }

  Future<bool> logout() async {
    try {
      await _dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      // Ignorar errores al cerrar sesión en el servidor
    }

    await _clearTokens();
    await _clearUserData();
    
    // Limpiar caché
    _isAuthenticatedCache = null;
    _lastAuthCheck = null;
    
    return true;
  }

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
      throw 'Error inesperado: \${e.toString()}';
    }
  }

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
      throw 'Error inesperado: \${e.toString()}';
    }
  }

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
      throw 'Error inesperado: \${e.toString()}';
    }
  }

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
      throw 'Error inesperado: \${e.toString()}';
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

  // Verificar si el usuario está autenticado con caché
  Future<bool> isAuthenticated() async {
    // Si tenemos un cache válido, usarlo
    if (_isAuthenticatedCache != null && 
        _lastAuthCheck != null && 
        DateTime.now().difference(_lastAuthCheck!) < _cacheExpiry) {
      return _isAuthenticatedCache!;
    }

    // Si no, verificar y actualizar cache
    final token = await getAccessToken();
    _isAuthenticatedCache = token != null;
    _lastAuthCheck = DateTime.now();
    
    return _isAuthenticatedCache!;
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
        return 'Timeout de conexión';
      case DioExceptionType.sendTimeout:
        return 'Timeout al enviar datos';
      case DioExceptionType.receiveTimeout:
        return 'Timeout al recibir datos';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return 'Credenciales inválidas';
        } else if (e.response?.statusCode == 403) {
          return 'Acceso prohibido';
        } else if (e.response?.statusCode == 404) {
          return 'Recurso no encontrado';
        } else if (e.response?.statusCode == 500) {
          return 'Error interno del servidor';
        }
        return 'Error del servidor: \${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Petición cancelada';
      case DioExceptionType.connectionError:
        return 'Error de conexión';
      case DioExceptionType.unknown:
        return 'Error desconocido';
      default:
        return 'Error inesperado';
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
