class Utilisateur {
  final int id;
  final String firstName;
  final String email;
  final String passwordHash;
  final String lastName;
  List<String> favoriteCuisines;
  List<int> favoriteRestaurants;

  Utilisateur({
    required this.id,
    required this.firstName,
    required this.email,
    required this.passwordHash,
    required this.lastName,
    required this.favoriteCuisines,
    required this.favoriteRestaurants,
  });

  // Factory pour créer un utilisateur à partir de la base de données
  factory Utilisateur.fromJson(
      Map<String, dynamic> json,
      List<String> favoriteCuisines,
      List<String> favoriteRestaurants,
      ) {
    // Conversion robuste de l'ID
    final dynamic id = json['id'];
    final int finalId;

    if (id is int) {
      finalId = id;
    } else if (id is String) {
      finalId = int.tryParse(id) ?? 0;
    } else {
      finalId = 0;
    }

    return Utilisateur(
      id: finalId,
      firstName: json['prenom']?.toString() ?? '',
      lastName: json['nom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      passwordHash: json['password_hash']?.toString() ?? '',
      favoriteCuisines: favoriteCuisines,
      favoriteRestaurants: favoriteRestaurants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': firstName,
      'email': email,
      'password_hash': passwordHash,
      'nom': lastName,
      'favorite_cuisines': favoriteCuisines,
      'favorite_restaurants': favoriteRestaurants,
    };
  }
}