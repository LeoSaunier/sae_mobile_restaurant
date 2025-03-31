class Restaurant {
  final int? restaurantId;
  final String? name;
  final String? type;
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
  final String? facebook;
  final String? siret;
  final String? department;
  final String? region;
  final String? brand;
  final String? wikidata;
  final String? brandWikidata;
  final int? comInsee;
  final int? codeRegion;
  final int? codeDepartement;
  final String? commune;
  final String? comNom;
  final int? codeCommune;
  final String? osmEdit;
  final String? osmId;
  final String? operator;
  final List<String> cuisines;

  Restaurant({
    this.restaurantId,
    this.name,
    this.type,
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
    this.facebook,
    this.siret,
    this.department,
    this.region,
    this.brand,
    this.wikidata,
    this.brandWikidata,
    this.comInsee,
    this.codeRegion,
    this.codeDepartement,
    this.commune,
    this.comNom,
    this.codeCommune,
    this.osmEdit,
    this.osmId,
    this.operator,
    this.cuisines = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json, cuisines) {
    return Restaurant(
      restaurantId: json['restaurant_id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
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
      facebook: json['facebook'] as String?,
      siret: json['siret'] as String?,
      department: json['department'] as String?,
      region: json['region'] as String?,
      brand: json['brand'] as String?,
      wikidata: json['wikidata'] as String?,
      brandWikidata: json['brand_wikidata'] as String?,
      comInsee: json['com_insee'] as int?,
      codeRegion: json['code_region'] as int?,
      codeDepartement: json['code_departement'] as int?,
      commune: json['commune'] as String?,
      comNom: json['com_nom'] as String?,
      codeCommune: json['code_commune'] as int?,
      osmEdit: json['osm_edit'] as String?,
      osmId: json['osm_id'] as String?,
      operator: json['operator'] as String?,
      cuisines: cuisines ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'type': type,
      'vegetarian': vegetarian,
      'vegan': vegan,
      'delivery': delivery,
      'takeaway': takeaway,
      'phone': phone,
      'website': website,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'opening_hours': openingHours,
      'wheelchair_accessibility': wheelchairAccessibility,
      'internet_access': internetAccess,
      'smoking_allowed': smokingAllowed,
      'capacity': capacity,
      'drive_through': driveThrough,
      'facebook': facebook,
      'siret': siret,
      'department': department,
      'region': region,
      'brand': brand,
      'wikidata': wikidata,
      'brand_wikidata': brandWikidata,
      'com_insee': comInsee,
      'code_region': codeRegion,
      'code_departement': codeDepartement,
      'commune': commune,
      'com_nom': comNom,
      'code_commune': codeCommune,
      'osm_edit': osmEdit,
      'osm_id': osmId,
      'operator': operator,
      'cuisines': cuisines,
    };
  }

}
