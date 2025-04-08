import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/Restaurant.dart';
import '../database/database_service.dart';
import '../models/Review.dart';
import 'providers/user_provider.dart';

class RestaurantDetail extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetail({super.key, required this.restaurant});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 3.0;

  final DatabaseService _db = DatabaseService();

  Future<List<Map<String, dynamic>>> _loadReviewsWithUsernames() async {
    try {
      var reviews = await _db.getRestaurantReviews(widget.restaurant.restaurantId!);

      
      List<Map<String, dynamic>> reviewsWithUsernames = [];
      for (var review in reviews) {
        String? username = await _db.getUserNameById(review.Iduser); 
        reviewsWithUsernames.add({
          'review': review,
          'username': username ?? "Utilisateur inconnu",
        });
      }
      return reviewsWithUsernames;
    } catch (e) {
      print("Erreur lors du chargement des avis avec noms: $e");
      return [];
    }
  }

  void _submitReview() async {
    //if (_commentController.text.trim().isEmpty) {
    //  ScaffoldMessenger.of(context).showSnackBar(
    //    const SnackBar(content: Text('Veuillez entrer un commentaire')),
    //  );
    //  return;
    //}

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté pour soumettre un avis')),
      );
      return;
    }

    final restaurantId = widget.restaurant.restaurantId;
    final userId = currentUser.id;

    if (restaurantId == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de soumettre l\'avis : identifiants manquants')),
      );
      return;
    }

    try {
      await _db.addReview(
        restaurantId,
        userId,
        _rating,
        _commentController.text.trim(),
      );

      setState(() {
        _commentController.clear();
        _rating = 3.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avis soumis avec succès')),
      );

      setState(() {});
    } catch (e) {
      print('Erreur lors de la soumission de l\'avis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la soumission de l\'avis: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name ?? "Détails")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREgDDOHY30gdRmIt2Q5sjLTlav9OUdNMtlqKEV-QXbGFPi2W-egDo8pJU5Kw&s",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey,
                        child: Icon(Icons.image_not_supported, size: 100),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(restaurant.name ?? 'Nom inconnu',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 5),
                      Expanded(child: Text(restaurant.address ?? 'Adresse non renseignée')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Cuisine : ${restaurant.cuisines.join(', ')}"),
                  SizedBox(height: 20),
                  Divider(),
                  Text("Avis des utilisateurs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _loadReviewsWithUsernames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("Aucun avis disponible."));
                      } else {
                        var reviewsWithUsernames = snapshot.data!;
                        return Column(
                          children: reviewsWithUsernames.map((entry) {
                            var review = entry['review'] as Review;
                            var username = entry['username'] as String;

                            return ListTile(
                              leading: Icon(Icons.person),
                              title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: review.rating ?? 0.0,
                                        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                        itemCount: 5,
                                        itemSize: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(child: Text(review.comment)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("${review.date.toLocal()}".split(' ')[0]),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Laisser un avis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false, 
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) => _rating = rating,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Votre commentaire',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _submitReview, child: Text("Envoyer")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}