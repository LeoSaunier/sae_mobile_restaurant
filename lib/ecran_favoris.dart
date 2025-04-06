import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/favorites_viewmodel.dart';
import '../widgets/restaurant_card.dart';

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
              Tab(icon: Icon(Icons.restaurant), text: 'Restaurants'),
              Tab(icon: Icon(Icons.fastfood), text: 'Cuisines'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet Restaurants
            favoritesVM.favorites.isEmpty
                ? const Center(child: Text('Aucun restaurant favori'))
                : ListView.builder(
              itemCount: favoritesVM.favorites.length,
              itemBuilder: (ctx, index) => RestaurantCard(
                restaurant: favoritesVM.favorites[index],
              ),
            ),

            // Onglet Cuisines
            favoritesVM.favoriteCuisines.isEmpty
                ? const Center(child: Text('Aucune cuisine favorite'))
                : ListView.builder(
              itemCount: favoritesVM.favoriteCuisines.length,
              itemBuilder: (ctx, index) => ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text(favoritesVM.favoriteCuisines[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => favoritesVM.toggleCuisineFavorite(
                    favoritesVM.favoriteCuisines[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}