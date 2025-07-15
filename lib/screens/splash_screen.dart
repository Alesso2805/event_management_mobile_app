import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    // Reducir tiempo de splash a 1 segundo
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.go('/login');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o icono de la aplicación
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.event,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Título de la aplicación
              const Text(
                'Event Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtítulo
              const Text(
                'Gestiona tus eventos favoritos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Indicador de carga
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Cargando...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
