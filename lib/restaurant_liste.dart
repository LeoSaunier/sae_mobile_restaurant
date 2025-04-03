import 'package:flutter/material.dart';
import '../models/Restaurant.dart';
import '../database/database_service.dart';
import 'widgets/restaurant_card.dart';

class RestaurantListe extends StatefulWidget {
  const RestaurantListe({super.key});

  @override
  _RestaurantListeState createState() => _RestaurantListeState();
}

class _RestaurantListeState extends State<RestaurantListe> {
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> _filteredRestaurants = [];
  late Future<List<Restaurant>> _restaurants;

  @override
  void initState() {
    super.initState();
    _restaurants = DatabaseService().getRestaurants();
  }

  void _searchRestaurants(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredRestaurants = []);
      return;
    }

    try {
      final results = await DatabaseService().rechercheRestaurant(query);
      setState(() => _filteredRestaurants = results);
    } catch (e) {
      print("Erreur lors de la recherche: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Restaurants")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un restaurant...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _searchRestaurants,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Restaurant>>(
              future: _restaurants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun restaurant trouvé"));
                }

                final displayedRestaurants = _filteredRestaurants.isNotEmpty ? _filteredRestaurants : snapshot.data!;
                
                return ListView.builder(
                  itemCount: displayedRestaurants.length,
                  itemBuilder: (context, index) {
                    return RestaurantCard(restaurant: displayedRestaurants[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
