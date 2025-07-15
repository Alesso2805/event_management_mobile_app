import 'package:equatable/equatable.dart';
import 'user.dart';
import 'category.dart';

class Event extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime? eventEndDate;
  final String location;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final bool isVirtual;
  final String? virtualUrl;
  final int maxCapacity;
  final int currentAttendees;
  final EventStatus status;
  final User organizer;
  final Category category;
  final List<TicketType> ticketTypes;
  final bool isFree;
  final double? minPrice;
  final double? maxPrice;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.eventEndDate,
    required this.location,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.imageUrl,
    required this.isVirtual,
    this.virtualUrl,
    required this.maxCapacity,
    required this.currentAttendees,
    required this.status,
    required this.organizer,
    required this.category,
    required this.ticketTypes,
    required this.isFree,
    this.minPrice,
    this.maxPrice,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isOngoing => 
      DateTime.now().isAfter(eventDate) && 
      (eventEndDate == null || DateTime.now().isBefore(eventEndDate!));
  bool get isPast => eventEndDate != null 
      ? DateTime.now().isAfter(eventEndDate!)
      : DateTime.now().isAfter(eventDate);
  bool get hasAvailableTickets => currentAttendees < maxCapacity;
  int get availableTickets => maxCapacity - currentAttendees;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      eventEndDate: json['eventEndDate'] != null 
          ? DateTime.parse(json['eventEndDate'])
          : null,
      location: json['location'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      imageUrl: json['imageUrl'],
      isVirtual: json['isVirtual'] ?? false,
      virtualUrl: json['virtualUrl'],
      maxCapacity: json['maxCapacity'],
      currentAttendees: json['currentAttendees'] ?? 0,
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.DRAFT,
      ),
      organizer: User.fromJson(json['organizer']),
      category: Category.fromJson(json['category']),
      ticketTypes: (json['ticketTypes'] as List<dynamic>?)
          ?.map((e) => TicketType.fromJson(e))
          .toList() ?? [],
      isFree: json['isFree'] ?? false,
      minPrice: json['minPrice']?.toDouble(),
      maxPrice: json['maxPrice']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'eventEndDate': eventEndDate?.toIso8601String(),
      'location': location,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'isVirtual': isVirtual,
      'virtualUrl': virtualUrl,
      'maxCapacity': maxCapacity,
      'currentAttendees': currentAttendees,
      'status': status.name,
      'organizer': organizer.toJson(),
      'category': category.toJson(),
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
      'isFree': isFree,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? eventDate,
    DateTime? eventEndDate,
    String? location,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    String? imageUrl,
    bool? isVirtual,
    String? virtualUrl,
    int? maxCapacity,
    int? currentAttendees,
    EventStatus? status,
    User? organizer,
    Category? category,
    List<TicketType>? ticketTypes,
    bool? isFree,
    double? minPrice,
    double? maxPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      location: location ?? this.location,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      isVirtual: isVirtual ?? this.isVirtual,
      virtualUrl: virtualUrl ?? this.virtualUrl,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      status: status ?? this.status,
      organizer: organizer ?? this.organizer,
      category: category ?? this.category,
      ticketTypes: ticketTypes ?? this.ticketTypes,
      isFree: isFree ?? this.isFree,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        eventDate,
        eventEndDate,
        location,
        city,
        state,
        country,
        latitude,
        longitude,
        imageUrl,
        isVirtual,
        virtualUrl,
        maxCapacity,
        currentAttendees,
        status,
        organizer,
        category,
        ticketTypes,
        isFree,
        minPrice,
        maxPrice,
        createdAt,
        updatedAt,
      ];
}

enum EventStatus {
  DRAFT,
  PUBLISHED,
  CANCELLED,
  COMPLETED,
}

extension EventStatusExtension on EventStatus {
  String get displayName {
    switch (this) {
      case EventStatus.DRAFT:
        return 'Borrador';
      case EventStatus.PUBLISHED:
        return 'Publicado';
      case EventStatus.CANCELLED:
        return 'Cancelado';
      case EventStatus.COMPLETED:
        return 'Completado';
    }
  }
}

class TicketType extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int soldTickets;
  final bool isActive;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;

  const TicketType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.soldTickets,
    required this.isActive,
    this.saleStartDate,
    this.saleEndDate,
  });

  bool get isAvailable => 
      isActive && 
      soldTickets < quantity &&
      (saleStartDate == null || DateTime.now().isAfter(saleStartDate!)) &&
      (saleEndDate == null || DateTime.now().isBefore(saleEndDate!));

  int get availableTickets => quantity - soldTickets;

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'],
      soldTickets: json['soldTickets'] ?? 0,
      isActive: json['isActive'] ?? true,
      saleStartDate: json['saleStartDate'] != null 
          ? DateTime.parse(json['saleStartDate'])
          : null,
      saleEndDate: json['saleEndDate'] != null 
          ? DateTime.parse(json['saleEndDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'soldTickets': soldTickets,
      'isActive': isActive,
      'saleStartDate': saleStartDate?.toIso8601String(),
      'saleEndDate': saleEndDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        quantity,
        soldTickets,
        isActive,
        saleStartDate,
        saleEndDate,
      ];
}
