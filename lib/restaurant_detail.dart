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
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() async {
    var db = DatabaseService();
    final reviews = await db.getRestaurantReviews(widget.restaurant.restaurantId!);
    setState(() {
      _reviews = reviews;
    });
  }

  void _submitReview() async {
    // Vérifier que le commentaire n'est pas vide
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un commentaire')),
      );
      return;
    }

    // Récupérer l'utilisateur connecté via le Provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    
    if (currentUser == null) {
      // Gérer le cas où aucun utilisateur n'est connecté
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez être connecté pour soumettre un avis')),
      );
      return;
    }

    try {
      // Utiliser la méthode addReview de votre DatabaseService
      await _db.addReview(
        widget.restaurant.restaurantId!,
        currentUser.id,
        _rating,
        _commentController.text.trim(),
      );

      // Mettre à jour l'interface utilisateur si la soumission a réussi
      setState(() {
        // Créer un nouvel objet Review à ajouter à votre liste locale
        final newReview = Review(
          id: 0, // L'ID sera attribué par la base de données
          Idrestaurant: widget.restaurant.restaurantId!,
          Iduser: currentUser.id,
          rating: _rating,
          comment: _commentController.text.trim(),
          date: DateTime.now(),
        );
        
        _reviews.add(newReview);
        _commentController.clear();
        _rating = 3.0;
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avis soumis avec succès')),
      );
      
      // Recharger les avis depuis la base de données
      _loadReviews();
      
    } catch (e) {
      // Gérer l'erreur
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
