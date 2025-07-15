import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? icon;
  final String? color;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.color,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        color,
        isActive,
        createdAt,
        updatedAt,
      ];
}
