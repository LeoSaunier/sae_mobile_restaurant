class Review {
  final int id;
  final String restaurant;
  final String user;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.restaurant,
    required this.user,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Convertir un objet Review en Map (utile pour la base de données ou API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant': restaurant,
      'user': user,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  // Créer un objet Review à partir d'une Map (utile pour la base de données ou API)
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      restaurant: map['restaurant'],
      user: map['user'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }
}