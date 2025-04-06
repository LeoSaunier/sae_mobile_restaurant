class Review {
  final int restaurantId;
  final int userId;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.restaurantId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Convertir un objet Review en Map (utile pour la base de données ou API)
  Map<String, dynamic> toMap() {
    return {
      'restaurant': restaurantId,
      'user': userId,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  // Créer un objet Review à partir d'une Map (utile pour la base de données ou API)
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      restaurantId: map['restaurant'],
      userId: map['user'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }
}