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

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'] as int,
      firstName: json['prenom'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      lastName: json['nom'] as String,
      favoriteCuisines: List<String>.from(json['favorite_cuisines'] ?? []),
      favoriteRestaurants: List<int>.from(json['favorite_restaurants'] ?? []),
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