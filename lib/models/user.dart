import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;  // Cambiar de int a String
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? biography;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.biography,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',  // Convertir a String
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      biography: json['biography'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.USER,
      ),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'biography': biography,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? biography,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      biography: biography ?? this.biography,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        profilePicture,
        biography,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}

enum UserRole {
  USER,
  ORGANIZER,
  ADMIN,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.USER:
        return 'Usuario';
      case UserRole.ORGANIZER:
        return 'Organizador';
      case UserRole.ADMIN:
        return 'Administrador';
    }
  }
}
