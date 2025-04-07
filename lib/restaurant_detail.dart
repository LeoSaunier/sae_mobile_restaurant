import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/Restaurant.dart';
import '../database/database_service.dart';
import '../models/Review.dart';

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
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await _db.getRestaurantReviews(widget.restaurant.restaurantId!);
    setState(() {
      _reviews = reviews;
    });
  }

  void _submitReview() async {
    // Tu devrais ici ajouter la logique pour insérer l'avis dans Supabase
    // Pour le test, on simule localement :
    var db = DatabaseService();

    if (_commentController.text.trim().isEmpty) {
      return;
    }

    final newReview = Review(
      id: (await db.getMaxId() ?? 0) + 1,
      Idrestaurant: widget.restaurant.restaurantId!,
      Iduser: 0, // à remplacer par le vrai user connecté
      rating: _rating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    setState(() {
      _reviews.add(newReview);
      _commentController.clear();
      _rating = 3.0;
    });

    // TODO: Ajoute une fonction dans DatabaseService pour insérer l’avis
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
                  ..._reviews.map((review) => ListTile(
                        leading: Icon(Icons.person),
                        title: Row(
                          children: [
                            RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                            SizedBox(width: 8),
                            Text(review.comment),
                          ],
                        ),
                        subtitle: Text("${review.date.toLocal()}".split(' ')[0]),
                      )),
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
                  allowHalfRating: true,
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
