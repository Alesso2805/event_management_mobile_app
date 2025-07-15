import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/event.dart';
import '../services/auth_service.dart';

class EventService {
  final Dio _dio;
  final AuthService _authService;

  EventService(this._authService) : _dio = Dio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = ApiConfig.defaultHeaders;

    // Interceptor para agregar el token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  // Obtener eventos públicos
  Future<List<Event>> getPublicEvents({
    int page = 0,
    int size = 20,
    String? category,
    String? search,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (category != null) queryParameters['category'] = category;
      if (search != null) queryParameters['search'] = search;
      if (city != null) queryParameters['city'] = city;
      if (startDate != null) queryParameters['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParameters['endDate'] = endDate.toIso8601String();

      final response = await _dio.get(
        ApiConfig.publicEventsEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> eventsJson = data['content'] ?? data;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Obtener eventos cercanos
  Future<List<Event>> getNearbyEvents({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.nearbyEventsEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> eventsJson = data['content'] ?? data;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Obtener detalles de un evento
  Future<Event> getEventDetails(int eventId) async {
    try {
      final response = await _dio.get(
        ApiConfig.getEventDetailsUrl(eventId),
      );

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw 'No se encontró el evento';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Crear evento
  Future<Event> createEvent({
    required String title,
    required String description,
    required DateTime eventDate,
    DateTime? eventEndDate,
    required String location,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    required bool isVirtual,
    String? virtualUrl,
    required int maxCapacity,
    required int categoryId,
    File? imageFile,
    required List<CreateTicketTypeRequest> ticketTypes,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'description': description,
        'eventDate': eventDate.toIso8601String(),
        'eventEndDate': eventEndDate?.toIso8601String(),
        'location': location,
        'city': city,
        'state': state,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'isVirtual': isVirtual,
        'virtualUrl': virtualUrl,
        'maxCapacity': maxCapacity,
        'categoryId': categoryId,
        'ticketTypes': ticketTypes.map((t) => t.toJson()).toList(),
      });

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        ApiConfig.createEventEndpoint,
        data: formData,
      );

      if (response.statusCode == 201) {
        return Event.fromJson(response.data);
      }
      throw 'Error al crear el evento';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Actualizar evento
  Future<Event> updateEvent({
    required int eventId,
    String? title,
    String? description,
    DateTime? eventDate,
    DateTime? eventEndDate,
    String? location,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    bool? isVirtual,
    String? virtualUrl,
    int? maxCapacity,
    int? categoryId,
    File? imageFile,
    List<CreateTicketTypeRequest>? ticketTypes,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (eventDate != null) 'eventDate': eventDate.toIso8601String(),
        if (eventEndDate != null) 'eventEndDate': eventEndDate.toIso8601String(),
        if (location != null) 'location': location,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (isVirtual != null) 'isVirtual': isVirtual,
        if (virtualUrl != null) 'virtualUrl': virtualUrl,
        if (maxCapacity != null) 'maxCapacity': maxCapacity,
        if (categoryId != null) 'categoryId': categoryId,
        if (ticketTypes != null) 'ticketTypes': ticketTypes.map((t) => t.toJson()).toList(),
      });

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.put(
        ApiConfig.getUpdateEventUrl(eventId),
        data: formData,
      );

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw 'Error al actualizar el evento';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Eliminar evento
  Future<bool> deleteEvent(int eventId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.getDeleteEventUrl(eventId),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Publicar evento
  Future<Event> publishEvent(int eventId) async {
    try {
      final response = await _dio.post(
        ApiConfig.getPublishEventUrl(eventId),
      );

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw 'Error al publicar el evento';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Cancelar evento
  Future<Event> cancelEvent(int eventId) async {
    try {
      final response = await _dio.post(
        ApiConfig.getCancelEventUrl(eventId),
      );

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw 'Error al cancelar el evento';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Obtener mis eventos
  Future<List<Event>> getMyEvents({
    int page = 0,
    int size = 20,
    EventStatus? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (status != null) queryParameters['status'] = status.name;

      final response = await _dio.get(
        ApiConfig.myEventsEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> eventsJson = data['content'] ?? data;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Obtener eventos favoritos
  Future<List<Event>> getFavoriteEvents({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.favoriteEventsEndpoint,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> eventsJson = data['content'] ?? data;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Agregar a favoritos
  Future<bool> addToFavorites(int eventId) async {
    try {
      final response = await _dio.post(
        ApiConfig.getAddToFavoritesUrl(eventId),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Remover de favoritos
  Future<bool> removeFromFavorites(int eventId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.getRemoveFromFavoritesUrl(eventId),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Buscar eventos
  Future<List<Event>> searchEvents({
    required String query,
    int page = 0,
    int size = 20,
    String? category,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'q': query,
        'page': page,
        'size': size,
      };

      if (category != null) queryParameters['category'] = category;
      if (city != null) queryParameters['city'] = city;
      if (startDate != null) queryParameters['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParameters['endDate'] = endDate.toIso8601String();

      final response = await _dio.get(
        ApiConfig.searchEventsEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> eventsJson = data['content'] ?? data;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
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
          return 'No autorizado';
        } else if (e.response?.statusCode == 403) {
          return 'Acceso prohibido';
        } else if (e.response?.statusCode == 404) {
          return 'Recurso no encontrado';
        } else if (e.response?.statusCode == 500) {
          return 'Error interno del servidor';
        }
        return 'Error del servidor: ${e.response?.statusCode}';
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

// Clase para crear tipos de tickets
class CreateTicketTypeRequest {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;

  CreateTicketTypeRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.saleStartDate,
    this.saleEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'saleStartDate': saleStartDate?.toIso8601String(),
      'saleEndDate': saleEndDate?.toIso8601String(),
    };
  }
}
