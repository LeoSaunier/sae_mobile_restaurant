import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Restaurant.dart';
import '../viewModel/favorites_viewmodel.dart';
import '../widgets/restaurant_card.dart';
import 'cuisine_restaurants_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesVM = context.watch<FavoritesViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Favoris'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant)),
              Tab(icon: Icon(Icons.fastfood)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Restaurants favoris
            favoritesVM.favorites.isEmpty
                ? const Center(child: Text('Aucun restaurant favori'))
                : ListView.builder(
              itemCount: favoritesVM.favorites.length,
              itemBuilder: (ctx, index) => RestaurantCard(
                restaurant: favoritesVM.favorites[index],
              ),
            ),

            // Cuisines favorites
            favoritesVM.favoriteCuisines.isEmpty
                ? const Center(child: Text('Aucune cuisine favorite'))
                : ListView.builder(
              itemCount: favoritesVM.favoriteCuisines.length,
              itemBuilder: (ctx, index) => ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text(favoritesVM.favoriteCuisines[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => favoritesVM.toggleCuisineFavorite(
                    favoritesVM.favoriteCuisines[index],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CuisineRestaurantsScreen(
                        cuisine: favoritesVM.favoriteCuisines[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}