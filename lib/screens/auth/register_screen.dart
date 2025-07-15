import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim().isEmpty 
              ? null 
              : _phoneController.text.trim(),
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu $fieldName';
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
                    width: 80,
                    height: 80,
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
                    child: const Icon(
                      Icons.event,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Únete a Event Management',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Formulario de registro
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
                          // Fila de nombres
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _firstNameController,
                                  labelText: 'Nombre',
                                  prefixIcon: Icons.person,
                                  validator: (value) => _validateRequired(value, 'nombre'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  controller: _lastNameController,
                                  labelText: 'Apellido',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) => _validateRequired(value, 'apellido'),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Email
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Teléfono (opcional)
                          CustomTextField(
                            controller: _phoneController,
                            labelText: 'Teléfono (opcional)',
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
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
                          
                          const SizedBox(height: 16),
                          
                          // Confirmar contraseña
                          CustomTextField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirmar contraseña',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            validator: _validateConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Botón de registro
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
                                text: 'Crear cuenta',
                                onPressed: state is AuthLoading ? null : _register,
                                isLoading: state is AuthLoading,
                              );
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Términos y condiciones
                          Text(
                            'Al registrarte, aceptas nuestros Términos de Servicio y Política de Privacidad',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: AppTheme.fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Link para iniciar sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya tienes cuenta? ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Iniciar sesión',
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
