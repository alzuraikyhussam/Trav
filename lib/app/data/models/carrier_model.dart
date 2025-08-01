class Carrier {
  final String id;
  final String name;
  final String description;
  final String logo;
  final double rating;
  final int totalTrips;
  final List<String> amenities;
  final bool isActive;

  Carrier({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.rating,
    required this.totalTrips,
    required this.amenities,
    required this.isActive,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalTrips: json['total_trips'] ?? 0,
      amenities: List<String>.from(json['amenities'] ?? []),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'rating': rating,
      'total_trips': totalTrips,
      'amenities': amenities,
      'is_active': isActive,
    };
  }

  @override
  String toString() {
    return 'Carrier(id: $id, name: $name, rating: $rating)';
  }
}