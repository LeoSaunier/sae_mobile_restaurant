class Utilisateur {
  final int id;
  final String firstName;
  final String email;
  final String passwordHash;
  final String lastName;
  final List<String> favoriteCuisines;
  final List<String> favoriteRestaurants;

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
  factory Utilisateur.fromJson(Map<String, dynamic> json, List<String> cuisines, List<String> restaurants) {
    return Utilisateur(
      id: json['id'],
      firstName: json['prenom'],
      email: json['email'],
      passwordHash: json['password_hash'],
      lastName: json['nom'],
      favoriteCuisines: cuisines,
      favoriteRestaurants: restaurants,
    );
  }
}