import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNumber;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, phoneNumber ?? ''];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object> get props => [token, newPassword];
}

class AuthChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class AuthVerifyEmailRequested extends AuthEvent {
  final String token;

  const AuthVerifyEmailRequested({required this.token});

  @override
  List<Object> get props => [token];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthPasswordResetSent extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}

class AuthPasswordChanged extends AuthState {}

class AuthEmailVerified extends AuthState {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onAuthChangePasswordRequested);
    on<AuthVerifyEmailRequested>(_onAuthVerifyEmailRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final isAuthenticated = await authService.isAuthenticated();
      
      if (isAuthenticated) {
        final user = await authService.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final result = await authService.login(event.email, event.password);
      
      if (result.isSuccess && result.user != null) {
        emit(AuthAuthenticated(user: result.user!));
      } else {
        emit(AuthError(message: result.errorMessage ?? 'Error en el inicio de sesión'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final result = await authService.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
      );
      
      if (result.isSuccess && result.user != null) {
        emit(AuthAuthenticated(user: result.user!));
      } else {
        emit(AuthError(message: result.errorMessage ?? 'Error en el registro'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      await authService.logout();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final success = await authService.forgotPassword(event.email);
      
      if (success) {
        emit(AuthPasswordResetSent());
      } else {
        emit(AuthError(message: 'Error al enviar el email de recuperación'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final success = await authService.resetPassword(
        token: event.token,
        newPassword: event.newPassword,
      );
      
      if (success) {
        emit(AuthPasswordResetSuccess());
      } else {
        emit(AuthError(message: 'Error al restablecer la contraseña'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final success = await authService.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      
      if (success) {
        emit(AuthPasswordChanged());
      } else {
        emit(AuthError(message: 'Error al cambiar la contraseña'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthVerifyEmailRequested(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
    
      final success = await authService.verifyEmail(event.token);
      
      if (success) {
        emit(AuthEmailVerified());
      } else {
        emit(AuthError(message: 'Error al verificar el email'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
