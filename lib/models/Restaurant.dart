class Restaurant {
  final int? restaurantId;
  final String? name;
  final String? type;
  final String? imageUrl;
  final bool? vegetarian;
  final bool? vegan;
  final bool? delivery;
  final bool? takeaway;
  final String? phone;
  final String? website;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? openingHours;
  final bool? wheelchairAccessibility;
  final String? internetAccess;
  final bool? smokingAllowed;
  final int? capacity;
  final bool? driveThrough;
  final List<String> cuisines;
  bool isFavorite;

  Restaurant({
    this.restaurantId,
    this.name,
    this.type,
    this.imageUrl,
    this.vegetarian,
    this.vegan,
    this.delivery,
    this.takeaway,
    this.phone,
    this.website,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.wheelchairAccessibility,
    this.internetAccess,
    this.smokingAllowed,
    this.capacity,
    this.driveThrough,
    required this.cuisines,
    this.isFavorite = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json, List<String> cuisines) {
    return Restaurant(
      restaurantId: json['restaurant_id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      imageUrl: json['image_url'] as String?,
      vegetarian: json['vegetarian'] as bool?,
      vegan: json['vegan'] as bool?,
      delivery: json['delivery'] as bool?,
      takeaway: json['takeaway'] as bool?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      openingHours: json['opening_hours'] as String?,
      wheelchairAccessibility: json['wheelchair_accessibility'] as bool?,
      internetAccess: json['internet_access'] as String?,
      smokingAllowed: json['smoking_allowed'] as bool?,
      capacity: json['capacity'] as int?,
      driveThrough: json['drive_through'] as bool?,
      cuisines: cuisines,
    );
  }

  Restaurant copyWith({
    int? restaurantId,
    String? name,
    String? type,
    String? imageUrl,
    bool? vegetarian,
    bool? vegan,
    bool? delivery,
    bool? takeaway,
    String? phone,
    String? website,
    String? address,
    double? latitude,
    double? longitude,
    String? openingHours,
    bool? wheelchairAccessibility,
    String? internetAccess,
    bool? smokingAllowed,
    int? capacity,
    bool? driveThrough,
    List<String>? cuisines,
    bool? isFavorite,
  }) {
    return Restaurant(
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      vegetarian: vegetarian ?? this.vegetarian,
      vegan: vegan ?? this.vegan,
      delivery: delivery ?? this.delivery,
      takeaway: takeaway ?? this.takeaway,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      wheelchairAccessibility: wheelchairAccessibility ?? this.wheelchairAccessibility,
      internetAccess: internetAccess ?? this.internetAccess,
      smokingAllowed: smokingAllowed ?? this.smokingAllowed,
      capacity: capacity ?? this.capacity,
      driveThrough: driveThrough ?? this.driveThrough,
      cuisines: cuisines ?? this.cuisines,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
