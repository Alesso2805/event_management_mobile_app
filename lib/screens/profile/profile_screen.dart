import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _biographyController = TextEditingController();

  bool _isEditing = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Verificar el estado actual de autenticación
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUser = authState.user;
      _updateControllers();
    } else {
      // Si no hay usuario autenticado, verificar autenticación
      context.read<AuthBloc>().add(AuthCheckRequested());
    }
  }

  void _updateControllers() {
    if (_currentUser != null) {
      _firstNameController.text = _currentUser!.firstName;
      _lastNameController.text = _currentUser!.lastName;
      _emailController.text = _currentUser!.email;
      _phoneController.text = _currentUser!.phoneNumber ?? '';
      _biographyController.text = _currentUser!.biography ?? '';
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí implementarías la lógica para actualizar el perfil
      // Por ahora, solo simularemos que se guarda
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado exitosamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _currentUser = state.user;
            _updateControllers();
          } else if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header con foto de perfil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Foto de perfil
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          backgroundImage: _currentUser?.profilePicture != null
                              ? NetworkImage(_currentUser!.profilePicture!)
                              : null,
                          child: _currentUser?.profilePicture == null
                              ? Text(
                                  _currentUser != null 
                                      ? '${_currentUser!.firstName[0]}${_currentUser!.lastName[0]}'
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        if (_isEditing)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Nombre completo
                    Text(
                      _currentUser?.fullName ?? 'Usuario',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Email
                    Text(
                      _currentUser?.email ?? 'email@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Rol
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentUser?.role.name ?? 'USER',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Formulario de datos
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Fila de nombres
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              labelText: 'Nombre',
                              prefixIcon: Icons.person,
                              readOnly: !_isEditing,
                              validator: _isEditing ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                return null;
                              } : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              labelText: 'Apellido',
                              prefixIcon: Icons.person_outline,
                              readOnly: !_isEditing,
                              validator: _isEditing ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu apellido';
                                }
                                return null;
                              } : null,
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
                        readOnly: true, // El email no se puede cambiar
                        keyboardType: TextInputType.emailAddress,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Teléfono
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Teléfono',
                        prefixIcon: Icons.phone,
                        readOnly: !_isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Biografía
                      CustomTextField(
                        controller: _biographyController,
                        labelText: 'Biografía',
                        prefixIcon: Icons.info_outline,
                        readOnly: !_isEditing,
                        maxLines: 3,
                        hintText: _isEditing ? 'Cuéntanos sobre ti...' : null,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Acciones
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Acciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomButton(
                      text: 'Cambiar contraseña',
                      onPressed: () {
                        // Navegar a pantalla de cambio de contraseña
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función en desarrollo'),
                          ),
                        );
                      },
                      isSecondary: true,
                      icon: Icons.lock_outline,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    CustomButton(
                      text: 'Cerrar sesión',
                      onPressed: _logout,
                      isSecondary: true,
                      icon: Icons.logout,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Información adicional
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Miembro desde:',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),                          Text(
                            _currentUser?.createdAt != null
                                ? '${_currentUser!.createdAt.day}/${_currentUser!.createdAt.month}/${_currentUser!.createdAt.year}'
                                : 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estado:',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (_currentUser?.isActive ?? false) ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            (_currentUser?.isActive ?? false) ? 'Activo' : 'Inactivo',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }
}
