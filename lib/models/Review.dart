class Review {
  final int? id;
  final int? Idrestaurant;
  final int? Iduser;
  final double? rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.Idrestaurant,
    required this.Iduser,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant': Idrestaurant,
      'user': Iduser,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    print('DEBUG: Donnée reçue du backend => $map');

    return Review(
      id: map['review_id'] ?? 0,
      Idrestaurant: map['restaurant_id'] ?? 0,
      Iduser: map['user_id'] ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      date: DateTime.tryParse(map['created_at'] ?? map['date'] ?? '') ?? DateTime.now(),
    );
  }

}
