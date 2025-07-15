import 'package:equatable/equatable.dart';
import 'user.dart';
import 'event.dart';

class Ticket extends Equatable {
  final int id;
  final String qrCode;
  final User user;
  final Event event;
  final TicketType ticketType;
  final double price;
  final TicketStatus status;
  final DateTime purchaseDate;
  final DateTime? usedDate;
  final String? transactionId;
  final String? paymentMethod;
  final bool isRefundable;
  final DateTime? refundDate;
  final double? refundAmount;

  const Ticket({
    required this.id,
    required this.qrCode,
    required this.user,
    required this.event,
    required this.ticketType,
    required this.price,
    required this.status,
    required this.purchaseDate,
    this.usedDate,
    this.transactionId,
    this.paymentMethod,
    required this.isRefundable,
    this.refundDate,
    this.refundAmount,
  });

  bool get isUsed => status == TicketStatus.USED;
  bool get isValid => status == TicketStatus.VALID;
  bool get isCancelled => status == TicketStatus.CANCELLED;
  bool get isRefunded => status == TicketStatus.REFUNDED;
  bool get canBeUsed => isValid && event.isUpcoming;

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      qrCode: json['qrCode'],
      user: User.fromJson(json['user']),
      event: Event.fromJson(json['event']),
      ticketType: TicketType.fromJson(json['ticketType']),
      price: json['price']?.toDouble() ?? 0.0,
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.VALID,
      ),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      usedDate: json['usedDate'] != null 
          ? DateTime.parse(json['usedDate'])
          : null,
      transactionId: json['transactionId'],
      paymentMethod: json['paymentMethod'],
      isRefundable: json['isRefundable'] ?? false,
      refundDate: json['refundDate'] != null 
          ? DateTime.parse(json['refundDate'])
          : null,
      refundAmount: json['refundAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCode': qrCode,
      'user': user.toJson(),
      'event': event.toJson(),
      'ticketType': ticketType.toJson(),
      'price': price,
      'status': status.name,
      'purchaseDate': purchaseDate.toIso8601String(),
      'usedDate': usedDate?.toIso8601String(),
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'isRefundable': isRefundable,
      'refundDate': refundDate?.toIso8601String(),
      'refundAmount': refundAmount,
    };
  }

  Ticket copyWith({
    int? id,
    String? qrCode,
    User? user,
    Event? event,
    TicketType? ticketType,
    double? price,
    TicketStatus? status,
    DateTime? purchaseDate,
    DateTime? usedDate,
    String? transactionId,
    String? paymentMethod,
    bool? isRefundable,
    DateTime? refundDate,
    double? refundAmount,
  }) {
    return Ticket(
      id: id ?? this.id,
      qrCode: qrCode ?? this.qrCode,
      user: user ?? this.user,
      event: event ?? this.event,
      ticketType: ticketType ?? this.ticketType,
      price: price ?? this.price,
      status: status ?? this.status,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      usedDate: usedDate ?? this.usedDate,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRefundable: isRefundable ?? this.isRefundable,
      refundDate: refundDate ?? this.refundDate,
      refundAmount: refundAmount ?? this.refundAmount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        qrCode,
        user,
        event,
        ticketType,
        price,
        status,
        purchaseDate,
        usedDate,
        transactionId,
        paymentMethod,
        isRefundable,
        refundDate,
        refundAmount,
      ];
}

enum TicketStatus {
  VALID,
  USED,
  CANCELLED,
  REFUNDED,
}

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.VALID:
        return 'Válido';
      case TicketStatus.USED:
        return 'Usado';
      case TicketStatus.CANCELLED:
        return 'Cancelado';
      case TicketStatus.REFUNDED:
        return 'Reembolsado';
    }
  }
}
