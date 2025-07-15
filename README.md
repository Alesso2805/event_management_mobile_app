# 🎉 Event Management App

Una aplicación móvil completa para la gestión de eventos desarrollada en Flutter con integración a backend Spring Boot.

## 📱 Características

### 🔐 Autenticación
- **Login/Registro**: Sistema completo de autenticación con validación
- **JWT Authentication**: Integración segura con backend Spring Boot
- **Modo Mock**: Funcionalidad de prueba sin backend
- **Recuperación de contraseña**: Flujo completo de recuperación

### 👤 Gestión de Perfil
- **Perfil completo**: Visualización y edición de datos personales
- **Foto de perfil**: Con iniciales automáticas
- **Información detallada**: Nombre, email, teléfono, biografía
- **Estado de cuenta**: Información de registro y estado activo

### 🎪 Gestión de Eventos
- **Lista de eventos**: Visualización de eventos disponibles
- **Detalles de evento**: Información completa de cada evento
- **Categorías**: Organización por tipos de evento

### 🎫 Gestión de Tickets
- **Mis tickets**: Visualización de tickets adquiridos
- **QR Scanner**: Escaneo de códigos QR para tickets
- **Estados de ticket**: Seguimiento completo del estado

### 🎨 Diseño Moderno
- **Material Design 3**: Interfaz moderna y elegante
- **Tema claro/oscuro**: Soporte automático según sistema
- **Animaciones fluidas**: Transiciones suaves
- **Responsive**: Adaptable a diferentes tamaños de pantalla

## 🛠️ Tecnologías Utilizadas

### Frontend (Flutter)
- **Flutter**: 3.6+
- **Dart**: 3.2+
- **BLoC**: Gestión de estado reactiva
- **Go Router**: Navegación declarativa
- **Dio**: Cliente HTTP para API calls
- **Flutter Secure Storage**: Almacenamiento seguro de tokens

### Backend Integration
- **Spring Boot**: API REST
- **JWT**: Autenticación basada en tokens
- **MySQL/PostgreSQL**: Base de datos compatible

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  go_router: ^12.1.3
  dio: ^5.3.3
  flutter_secure_storage: ^9.0.0
  equatable: ^2.0.5
  mobile_scanner: ^3.5.6
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
```

## 🚀 Instalación y Configuración

### Prerequisitos
- Flutter SDK 3.6+
- Android Studio / VS Code
- Android SDK (para desarrollo Android)
- Xcode (para desarrollo iOS)

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd event_management
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar variables de entorno**
```bash
# Crear archivo .env en la raíz del proyecto
API_BASE_URL=http://localhost:8080/api
MOCK_MODE=true
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

## ⚙️ Configuración

### Configuración de API
Edita `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://your-api-url.com/api';
  static const bool mockMode = false; // true para pruebas
  static const int timeoutSeconds = 30;
}
```

### Configuración de Android
Para funcionalidad completa en Android, asegúrate de tener:
- Android NDK 27.0.12077973
- Permisos de red configurados
- ProGuard rules para release

## 📁 Estructura del Proyecto

```
lib/
├── blocs/              # Gestión de estado con BLoC
│   ├── auth/           # Autenticación
│   └── events/         # Eventos
├── config/             # Configuración
│   ├── api_config.dart
│   └── routes.dart
├── models/             # Modelos de datos
│   ├── user.dart
│   └── event.dart
├── screens/            # Pantallas de la aplicación
│   ├── auth/           # Autenticación
│   ├── home/           # Inicio
│   ├── profile/        # Perfil
│   └── navigation/     # Navegación
├── services/           # Servicios
│   ├── auth_service.dart
│   └── api_service.dart
├── theme/              # Tema y estilos
│   └── app_theme.dart
├── widgets/            # Componentes reutilizables
│   ├── custom_button.dart
│   └── custom_text_field.dart
└── main.dart           # Punto de entrada
```

## 🔧 Modo de Desarrollo

### Modo Mock
Para desarrollo sin backend:
```dart
// En api_config.dart
static const bool mockMode = true;
```

### Testing
```bash
# Ejecutar tests
flutter test

# Ejecutar tests con coverage
flutter test --coverage
```

## 🚀 Despliegue

### Android
```bash
# Generar APK
flutter build apk --release

# Generar AAB para Play Store
flutter build appbundle --release
```

### iOS
```bash
# Generar IPA
flutter build ios --release
```

## 📚 Funcionalidades Implementadas

- ✅ **Autenticación completa** con JWT
- ✅ **Gestión de perfil** con edición
- ✅ **Navegación** con bottom navigation
- ✅ **Tema personalizado** claro/oscuro
- ✅ **Validación de formularios**
- ✅ **Gestión de errores** y loading states
- ✅ **Almacenamiento seguro** de tokens
- ✅ **Modo offline** para desarrollo

## 🔮 Próximas Características

- 🔄 **Gestión completa de eventos**
- 🎫 **Sistema de tickets avanzado**
- 📱 **Notificaciones push**
- 🌍 **Localización** (múltiples idiomas)
- 📊 **Analytics** y métricas
- 🔍 **Búsqueda avanzada**
- 💳 **Integración de pagos**

## 🤝 Contribución

1. Fork el proyecto
2. Crear feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit los cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Equipo de Desarrollo

- **Desarrollador Principal**: [Tu Nombre]
- **Backend**: Spring Boot API
- **Frontend**: Flutter Mobile App

## 📞 Soporte

Para soporte técnico o preguntas:
- Email: support@eventmanagement.com
- Issues: [GitHub Issues](https://github.com/your-repo/issues)
- Documentación: [Wiki](https://github.com/your-repo/wiki)

---

**Desarrollado con ❤️ usando Flutter**
