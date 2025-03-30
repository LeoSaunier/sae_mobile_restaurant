class User {
  final int id;
  final String prenom;
  final String email;
  final String password;
  final String nom;

  User({
    required this.id,
    required this.prenom,
    required this.email,
    required this.password,
    required this.nom,
  });

  // Convertir un objet User en Map (utile pour la base de données ou API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prenom': prenom,
      'email': email,
      'password': password,
      'nom': nom,
    };
  }

  // Créer un objet User à partir d'une Map (utile pour la base de données ou API)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      prenom: map['prenom'],
      email: map['email'],
      password: map['password'],
      nom: map['nom'],
    );
  }
}