import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart' as profile;
import '../screens/navigation/main_navigation.dart';

class AppRouter {
  static GoRouter createRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) async {
        final location = state.matchedLocation;
        
        // Permitir acceso directo a splash sin verificación
        if (location == '/splash') {
          return null;
        }
        
        // Para pantallas de autenticación, no verificar autenticación
        final authPaths = ['/login', '/register', '/forgot-password'];
        if (authPaths.contains(location)) {
          return null;
        }
        
        // Solo verificar autenticación para rutas protegidas
        try {
          final isAuthenticated = await authService.isAuthenticated();
          if (!isAuthenticated) {
            return '/login';
          }
        } catch (e) {
          // En caso de error, redirigir a login
          return '/login';
        }
        
        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        
        // Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPlaceholderScreen(),
        ),
        
        // Main Navigation with Bottom Navigation Bar
        ShellRoute(
          builder: (context, state, child) {
            return MainNavigation(child: child);
          },
          routes: [
            // Home
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            
            // Events - usando las pantallas que ya están en MainNavigation
            GoRoute(
              path: '/events',
              builder: (context, state) => const EventsScreen(),
            ),
            
            // Tickets
            GoRoute(
              path: '/tickets',
              builder: (context, state) => const TicketsScreen(),
            ),
            
            // Profile
            GoRoute(
              path: '/profile',
              builder: (context, state) => const profile.ProfileScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                'Página no encontrada',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'La página que buscas no existe.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantallas placeholder temporales
class RegisterPlaceholderScreen extends StatelessWidget {
  const RegisterPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 64),
            SizedBox(height: 16),
            Text('Pantalla de Registro'),
            Text('(En desarrollo)'),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordPlaceholderScreen extends StatelessWidget {
  const ForgotPasswordPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, size: 64),
            SizedBox(height: 16),
            Text('Recuperar Contraseña'),
            Text('(En desarrollo)'),
          ],
        ),
      ),
    );
  }
}

// Rutas con nombres
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String events = '/events';
  static const String tickets = '/tickets';
  static const String profile = '/profile';
}
