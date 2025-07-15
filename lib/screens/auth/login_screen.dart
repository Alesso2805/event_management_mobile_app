import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo y título
                  Container(
                    width: 100,
                    height: 100,
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
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Formulario de login
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Contraseña
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Contraseña',
                            prefixIcon: Icons.lock,
                            obscureText: _obscurePassword,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Enlace "¿Olvidaste tu contraseña?"
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.go('/forgot-password');
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Botón de login
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthAuthenticated) {
                                context.go('/home');
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Iniciar sesión',
                                onPressed: state is AuthLoading ? null : _login,
                                isLoading: state is AuthLoading,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Enlace para registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes una cuenta? ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/register');
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
