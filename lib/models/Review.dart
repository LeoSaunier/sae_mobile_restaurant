import 'package:sae_restaurant/models/Restaurant.dart';
import 'package:sae_restaurant/models/User.dart';

class Review {
  final int id;
  final int Idrestaurant;
  final int Iduser;
  final double rating;
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

  // Convertir un objet Review en Map (utile pour la base de données ou API)
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

  // Créer un objet Review à partir d'une Map (utile pour la base de données ou API)
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['review_id'],
      Idrestaurant: map['restaurant_id'],
      Iduser: map['user_id'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }
}