class Booking {
  final String id;
  final String userId;
  final String tripId;
  final List<String> selectedSeatIds;
  final List<Traveler> travelers;
  final double totalAmount;
  final BookingStatus status;
  final PaymentInfo? paymentInfo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.selectedSeatIds,
    required this.travelers,
    required this.totalAmount,
    required this.status,
    this.paymentInfo,
    required this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      tripId: json['trip_id']?.toString() ?? '',
      selectedSeatIds: List<String>.from(json['selected_seat_ids'] ?? []),
      travelers: (json['travelers'] as List?)
          ?.map((traveler) => Traveler.fromJson(traveler))
          .toList() ?? [],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentInfo: json['payment_info'] != null 
          ? PaymentInfo.fromJson(json['payment_info']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'trip_id': tripId,
      'selected_seat_ids': selectedSeatIds,
      'travelers': travelers.map((t) => t.toJson()).toList(),
      'total_amount': totalAmount,
      'status': status.name,
      'payment_info': paymentInfo?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Booking(id: $id, status: $status, amount: $totalAmount)';
  }
}

class Traveler {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String nationality;
  final String passportNumber;
  final DateTime? passportExpiry;
  final String seatId;

  Traveler({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.nationality,
    required this.passportNumber,
    this.passportExpiry,
    required this.seatId,
  });

  factory Traveler.fromJson(Map<String, dynamic> json) {
    return Traveler(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      nationality: json['nationality'] ?? '',
      passportNumber: json['passport_number'] ?? '',
      passportExpiry: json['passport_expiry'] != null 
          ? DateTime.parse(json['passport_expiry']) 
          : null,
      seatId: json['seat_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'nationality': nationality,
      'passport_number': passportNumber,
      'passport_expiry': passportExpiry?.toIso8601String(),
      'seat_id': seatId,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'Traveler(name: $fullName, passport: $passportNumber)';
  }
}

class PaymentInfo {
  final String id;
  final String method;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? receiptImageUrl;
  final String? transactionId;
  final DateTime? paidAt;

  PaymentInfo({
    required this.id,
    required this.method,
    required this.amount,
    required this.currency,
    required this.status,
    this.receiptImageUrl,
    this.transactionId,
    this.paidAt,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id']?.toString() ?? '',
      method: json['method'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      receiptImageUrl: json['receipt_image_url'],
      transactionId: json['transaction_id'],
      paidAt: json['paid_at'] != null 
          ? DateTime.parse(json['paid_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'receipt_image_url': receiptImageUrl,
      'transaction_id': transactionId,
      'paid_at': paidAt?.toIso8601String(),
    };
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  refunded,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}