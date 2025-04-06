import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/Restaurant.dart';
import '../models/Review.dart';
import '../viewModel/favorites_viewmodel.dart';
import '../database/database_service.dart';

class RestaurantDetail extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetail({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 3.0;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await DatabaseService().getRestaurantReviews(widget.restaurant.restaurantId!);
    setState(() {
      _reviews = reviews;
    });
  }

  void _submitReview() {
    if (_commentController.text.isEmpty) return;

    setState(() {
      _reviews.add(Review(
        restaurantId: widget.restaurant.restaurantId!,
        userId: 0, // Remplacez par l'ID utilisateur réel
        rating: _rating,
        comment: _commentController.text,
        date: DateTime.now(),
      ));
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesVM = Provider.of<FavoritesViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name ?? "Détails")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: widget.restaurant.imageUrl != null
                          ? DecorationImage(
                        image: NetworkImage(widget.restaurant.imageUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: widget.restaurant.imageUrl == null
                        ? const Center(child: Icon(Icons.restaurant, size: 80))
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.restaurant.name ?? 'Nom inconnu',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cuisines proposées:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 8,
                        children: widget.restaurant.cuisines.map((cuisine) => InputChip(
                          label: Text(cuisine),
                          selected: favoritesVM.isCuisineFavorite(cuisine),
                          onSelected: (selected) {
                            favoritesVM.toggleCuisineFavorite(cuisine);
                          },
                          selectedColor: Colors.blue[100],
                          avatar: Icon(
                            favoritesVM.isCuisineFavorite(cuisine)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    "Avis des utilisateurs",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._reviews.map((review) => Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Row(
                          children: [
                            RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(review.comment)),
                          ],
                        ),
                        subtitle: Text("${review.date.toLocal()}".split(' ')[0]),
                      ),
                      const Divider(),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Laisser un avis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) => _rating = rating,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Votre commentaire',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text("Envoyer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}