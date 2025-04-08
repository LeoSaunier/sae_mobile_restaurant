import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/Restaurant.dart';
import '../models/Review.dart';
import '../database/database_service.dart';
import '../viewModel/favorites_viewmodel.dart';
import '../providers/user_provider.dart';

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

    if (restaurantId == null || userId == null) return;

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la soumission: ${e.toString()}')),
      );
    }
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
                          onSelected: (selected) => favoritesVM.toggleCuisineFavorite(cuisine),
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
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _loadReviewsWithUsernames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Aucun avis disponible."));
                      }
                      
                      return Column(
                        children: snapshot.data!.map((entry) {
                          final review = entry['review'] as Review;
                          final username = entry['username'] as String;

                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: review.rating ?? 0.0,
                                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(review.comment)),
                                  ],
                                ),
                                Text("${review.date.toLocal()}".split(' ')[0]),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
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