import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Restaurant.dart';
import '../database/database_service.dart';
import '../viewModel/favorites_viewmodel.dart';
import '../widgets/restaurant_card.dart';

class CuisineRestaurantsScreen extends StatelessWidget {
  final String cuisine;

  const CuisineRestaurantsScreen({super.key, required this.cuisine});

  @override
  Widget build(BuildContext context) {
    final favoritesVM = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants - $cuisine"),
        actions: [
          IconButton(
            icon: Icon(
              favoritesVM.isCuisineFavorite(cuisine)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => favoritesVM.toggleCuisineFavorite(cuisine),
          ),
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: DatabaseService().getRestaurantsByCuisine(cuisine),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun restaurant pour cette cuisine"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final restaurant = snapshot.data![index];
              return RestaurantCard(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}