import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'config/routes.dart';

void main() {
  runApp(const EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  const EventManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final router = AppRouter.createRouter(authService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
      ],
      child: MaterialApp.router(
        title: 'Event Management',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
