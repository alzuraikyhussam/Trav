class Ticket {
  final String id;
  final String bookingId;
  final String tripId;
  final String userId;
  final List<TicketPassenger> passengers;
  final TicketStatus status;
  final DateTime issueDate;
  final DateTime validUntil;
  final String qrCode;
  final String pnr; // Passenger Name Record
  final double totalAmount;
  final String currency;

  Ticket({
    required this.id,
    required this.bookingId,
    required this.tripId,
    required this.userId,
    required this.passengers,
    required this.status,
    required this.issueDate,
    required this.validUntil,
    required this.qrCode,
    required this.pnr,
    required this.totalAmount,
    required this.currency,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      tripId: json['trip_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      passengers: (json['passengers'] as List?)
          ?.map((passenger) => TicketPassenger.fromJson(passenger))
          .toList() ?? [],
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.valid,
      ),
      issueDate: DateTime.parse(json['issue_date']),
      validUntil: DateTime.parse(json['valid_until']),
      qrCode: json['qr_code'] ?? '',
      pnr: json['pnr'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'trip_id': tripId,
      'user_id': userId,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'status': status.name,
      'issue_date': issueDate.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'qr_code': qrCode,
      'pnr': pnr,
      'total_amount': totalAmount,
      'currency': currency,
    };
  }

  bool get isValid => status == TicketStatus.valid && DateTime.now().isBefore(validUntil);
  bool get isExpired => DateTime.now().isAfter(validUntil);
  bool get isCancelled => status == TicketStatus.cancelled;
  bool get isUsed => status == TicketStatus.used;

  @override
  String toString() {
    return 'Ticket(id: $id, pnr: $pnr, status: $status)';
  }
}

class TicketPassenger {
  final String id;
  final String firstName;
  final String lastName;
  final String seatNumber;
  final String seatType;
  final String gender;
  final DateTime dateOfBirth;
  final String nationality;
  final String passportNumber;

  TicketPassenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.seatNumber,
    required this.seatType,
    required this.gender,
    required this.dateOfBirth,
    required this.nationality,
    required this.passportNumber,
  });

  factory TicketPassenger.fromJson(Map<String, dynamic> json) {
    return TicketPassenger(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      seatNumber: json['seat_number'] ?? '',
      seatType: json['seat_type'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      nationality: json['nationality'] ?? '',
      passportNumber: json['passport_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'seat_number': seatNumber,
      'seat_type': seatType,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'nationality': nationality,
      'passport_number': passportNumber,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'TicketPassenger(name: $fullName, seat: $seatNumber)';
  }
}

enum TicketStatus {
  valid,
  used,
  cancelled,
  expired,
}

class TicketApproval {
  final String id;
  final String bookingId;
  final ApprovalStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? notes;
  final DateTime createdAt;

  TicketApproval({
    required this.id,
    required this.bookingId,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.notes,
    required this.createdAt,
  });

  factory TicketApproval.fromJson(Map<String, dynamic> json) {
    return TicketApproval(
      id: json['id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      status: ApprovalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApprovalStatus.pending,
      ),
      reviewedBy: json['reviewed_by'],
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at']) 
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'status': status.name,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isPending => status == ApprovalStatus.pending;
  bool get isApproved => status == ApprovalStatus.approved;
  bool get isRejected => status == ApprovalStatus.rejected;

  @override
  String toString() {
    return 'TicketApproval(id: $id, status: $status)';
  }
}

enum ApprovalStatus {
  pending,
  approved,
  rejected,
}