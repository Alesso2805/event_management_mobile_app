class ApiConfig {
  // Configuración base de la API
  // Para emulador Android usar 10.0.2.2, para dispositivo físico usar la IP local
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String wsUrl = 'ws://10.0.2.2:8080/ws';
  
  // Configuración de timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Endpoints de autenticación
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String verifyEmailEndpoint = '/auth/verify-email';
  
  // Endpoints de usuarios
  static const String usersEndpoint = '/users';
  static const String userProfileEndpoint = '/users/profile';
  static const String updateProfileEndpoint = '/users/profile';
  static const String changePasswordEndpoint = '/users/change-password';
  static const String uploadProfilePictureEndpoint = '/users/profile-picture';
  
  // Endpoints de eventos
  static const String eventsEndpoint = '/events';
  static const String publicEventsEndpoint = '/events/public';
  static const String myEventsEndpoint = '/events/my-events';
  static const String favoriteEventsEndpoint = '/events/favorites';
  static const String searchEventsEndpoint = '/events/search';
  static const String nearbyEventsEndpoint = '/events/nearby';
  static const String eventDetailsEndpoint = '/events/{id}';
  static const String createEventEndpoint = '/events';
  static const String updateEventEndpoint = '/events/{id}';
  static const String deleteEventEndpoint = '/events/{id}';
  static const String publishEventEndpoint = '/events/{id}/publish';
  static const String cancelEventEndpoint = '/events/{id}/cancel';
  static const String addToFavoritesEndpoint = '/events/{id}/favorites';
  static const String removeFromFavoritesEndpoint = '/events/{id}/favorites';
  
  // Endpoints de categorías
  static const String categoriesEndpoint = '/categories';
  static const String activeCategoriesEndpoint = '/categories/active';
  static const String createCategoryEndpoint = '/categories';
  static const String updateCategoryEndpoint = '/categories/{id}';
  static const String deleteCategoryEndpoint = '/categories/{id}';
  
  // Endpoints de tickets
  static const String ticketsEndpoint = '/tickets';
  static const String purchaseTicketEndpoint = '/tickets/purchase';
  static const String myTicketsEndpoint = '/tickets/my-tickets';
  static const String useTicketEndpoint = '/tickets/use/{qrCode}';
  static const String cancelTicketEndpoint = '/tickets/{id}/cancel';
  static const String refundTicketEndpoint = '/tickets/{id}/refund';
  static const String ticketDetailsEndpoint = '/tickets/{id}';
  static const String validateTicketEndpoint = '/tickets/validate/{qrCode}';
  
  // Endpoints de pagos
  static const String paymentsEndpoint = '/payments';
  static const String createPaymentIntentEndpoint = '/payments/create-intent';
  static const String confirmPaymentEndpoint = '/payments/confirm';
  static const String paymentHistoryEndpoint = '/payments/history';
  static const String refundPaymentEndpoint = '/payments/{id}/refund';
  
  // Endpoints de reportes
  static const String reportsEndpoint = '/reports';
  static const String salesReportEndpoint = '/reports/sales';
  static const String eventAnalyticsEndpoint = '/reports/events/{id}/analytics';
  static const String userAnalyticsEndpoint = '/reports/users/analytics';
  
  // Endpoints de notificaciones
  static const String notificationsEndpoint = '/notifications';
  static const String markAsReadEndpoint = '/notifications/{id}/read';
  static const String markAllAsReadEndpoint = '/notifications/read-all';
  static const String deleteNotificationEndpoint = '/notifications/{id}';
  
  // Configuración de paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Configuración de cache
  static const Duration cacheExpiry = Duration(minutes: 10);
  
  // Configuración de retry
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  
  // Configuración de archivos
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
  ];
  
  // Métodos utilitarios
  static String getEventDetailsUrl(int eventId) {
    return eventDetailsEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getUpdateEventUrl(int eventId) {
    return updateEventEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getDeleteEventUrl(int eventId) {
    return deleteEventEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getPublishEventUrl(int eventId) {
    return publishEventEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getCancelEventUrl(int eventId) {
    return cancelEventEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getAddToFavoritesUrl(int eventId) {
    return addToFavoritesEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getRemoveFromFavoritesUrl(int eventId) {
    return removeFromFavoritesEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getUseTicketUrl(String qrCode) {
    return useTicketEndpoint.replaceAll('{qrCode}', qrCode);
  }
  
  static String getCancelTicketUrl(int ticketId) {
    return cancelTicketEndpoint.replaceAll('{id}', ticketId.toString());
  }
  
  static String getRefundTicketUrl(int ticketId) {
    return refundTicketEndpoint.replaceAll('{id}', ticketId.toString());
  }
  
  static String getTicketDetailsUrl(int ticketId) {
    return ticketDetailsEndpoint.replaceAll('{id}', ticketId.toString());
  }
  
  static String getValidateTicketUrl(String qrCode) {
    return validateTicketEndpoint.replaceAll('{qrCode}', qrCode);
  }
  
  static String getUpdateCategoryUrl(int categoryId) {
    return updateCategoryEndpoint.replaceAll('{id}', categoryId.toString());
  }
  
  static String getDeleteCategoryUrl(int categoryId) {
    return deleteCategoryEndpoint.replaceAll('{id}', categoryId.toString());
  }
  
  static String getEventAnalyticsUrl(int eventId) {
    return eventAnalyticsEndpoint.replaceAll('{id}', eventId.toString());
  }
  
  static String getMarkAsReadUrl(int notificationId) {
    return markAsReadEndpoint.replaceAll('{id}', notificationId.toString());
  }
  
  static String getDeleteNotificationUrl(int notificationId) {
    return deleteNotificationEndpoint.replaceAll('{id}', notificationId.toString());
  }
  
  static String getRefundPaymentUrl(int paymentId) {
    return refundPaymentEndpoint.replaceAll('{id}', paymentId.toString());
  }
}
