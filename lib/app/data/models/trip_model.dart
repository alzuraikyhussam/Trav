class Trip {
  final String id;
  final String carrierId;
  final String carrierName;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int totalSeats;
  final int availableSeats;
  final String vehicleType;
  final List<String> amenities;
  final List<Seat> seats;

  Trip({
    required this.id,
    required this.carrierId,
    required this.carrierName,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.vehicleType,
    required this.amenities,
    required this.seats,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id']?.toString() ?? '',
      carrierId: json['carrier_id']?.toString() ?? '',
      carrierName: json['carrier_name'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      price: (json['price'] ?? 0).toDouble(),
      totalSeats: json['total_seats'] ?? 0,
      availableSeats: json['available_seats'] ?? 0,
      vehicleType: json['vehicle_type'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      seats: (json['seats'] as List?)
          ?.map((seat) => Seat.fromJson(seat))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carrier_id': carrierId,
      'carrier_name': carrierName,
      'origin': origin,
      'destination': destination,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'price': price,
      'total_seats': totalSeats,
      'available_seats': availableSeats,
      'vehicle_type': vehicleType,
      'amenities': amenities,
      'seats': seats.map((seat) => seat.toJson()).toList(),
    };
  }

  Duration get duration {
    return arrivalTime.difference(departureTime);
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  String toString() {
    return 'Trip(id: $id, origin: $origin, destination: $destination, price: $price)';
  }
}

class Seat {
  final String id;
  final String seatNumber;
  final SeatType type;
  final SeatStatus status;
  final double? price;
  final int row;
  final int column;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.type,
    required this.status,
    this.price,
    required this.row,
    required this.column,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id']?.toString() ?? '',
      seatNumber: json['seat_number'] ?? '',
      type: SeatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SeatType.regular,
      ),
      status: SeatStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SeatStatus.available,
      ),
      price: json['price']?.toDouble(),
      row: json['row'] ?? 0,
      column: json['column'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seat_number': seatNumber,
      'type': type.name,
      'status': status.name,
      'price': price,
      'row': row,
      'column': column,
    };
  }

  bool get isAvailable => status == SeatStatus.available;
  bool get isOccupied => status == SeatStatus.occupied;
  bool get isSelected => status == SeatStatus.selected;

  @override
  String toString() {
    return 'Seat(id: $id, number: $seatNumber, status: $status)';
  }
}

enum SeatType {
  regular,
  premium,
  vip,
}

enum SeatStatus {
  available,
  occupied,
  selected,
  blocked,
}