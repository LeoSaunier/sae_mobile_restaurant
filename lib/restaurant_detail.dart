import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedPhotos = [];

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

  Future<void> _pickPhotos() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (images != null) {
        setState(() {
          _selectedPhotos.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );
      if (photo != null) {
        setState(() {
          _selectedPhotos.add(photo);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur caméra : ${e.toString()}")),
      );
    }
  }

  Widget _imagePreview(XFile file) {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            );
          } else {
            return Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              child: const CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return Image.file(
        File(file.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  Future<List<String>> _uploadPhotos() async {
    List<String> uploadedUrls = [];
    for (var photo in _selectedPhotos) {
      String url = await _uploadImageToServer(photo);
      uploadedUrls.add(url);
    }
    return uploadedUrls;
  }

  Future<String> _uploadImageToServer(XFile imageFile) async {
    // Implémentez votre logique d'upload ici
    // Pour le web, utilisez imageFile.readAsBytes()
    // Pour mobile, vous pouvez utiliser File(imageFile.path)
    return "https://example.com/uploaded_image.jpg"; // URL simulée
  }

  void _submitReview() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez écrire un commentaire")),
      );
      return;
    }

    List<String> uploadedUrls = await _uploadPhotos();

    final newReview = Review(
      restaurantId: widget.restaurant.restaurantId!,
      userId: 0, // Remplacez par l'ID de l'utilisateur réel
      rating: _rating,
      comment: _commentController.text,
      date: DateTime.now(),
      photoUrls: uploadedUrls,
    );

    setState(() {
      _reviews.add(newReview);
      _selectedPhotos.clear();
      _commentController.clear();
      _rating = 3.0;
    });
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://via.placeholder.com/400x200",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported, size: 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(restaurant.name ?? 'Nom inconnu',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 5),
                      Expanded(child: Text(restaurant.address ?? 'Adresse non renseignée')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Cuisine : ${restaurant.cuisines.join(', ')}"),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Avis des utilisateurs",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      if (review.photoUrls.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: review.photoUrls.length,
                            itemBuilder: (ctx, index) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CachedNetworkImage(
                                imageUrl: review.photoUrls[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) => const CircularProgressIndicator(),
                                errorWidget: (ctx, url, err) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                const Text("Laisser un avis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickPhotos,
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Galerie"),
                    ),
                    const SizedBox(width: 10),
                    if (!kIsWeb) // Cache le bouton caméra sur le web si non supporté
                      ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Camera"),
                      ),
                  ],
                ),
                if (_selectedPhotos.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text("Photos à ajouter :"),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedPhotos.length,
                      itemBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            _imagePreview(_selectedPhotos[index]),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedPhotos.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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