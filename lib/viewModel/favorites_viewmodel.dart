import 'package:flutter/foundation.dart';
import '../models/Restaurant.dart';
import '../services/local_storage_service.dart';

class FavoritesViewModel with ChangeNotifier {
  final LocalStorageService _storage;
  List<Restaurant> favorites = [];
  List<String> favoriteCuisines = [];

  FavoritesViewModel(this._storage);

  Future<void> loadFavorites() async {
    final restaurantIds = await _storage.getFavoriteRestaurants();
    favoriteCuisines = await _storage.getFavoriteCuisines();
    notifyListeners();
  }

  Future<void> toggleRestaurantFavorite(Restaurant restaurant) async {
    final isFavorite = !restaurant.isFavorite;
    restaurant.isFavorite = isFavorite;

    if (isFavorite) {
      favorites.add(restaurant);
    } else {
      favorites.removeWhere((r) => r.restaurantId == restaurant.restaurantId);
    }

    await _storage.saveFavoriteRestaurants(
      favorites.map((r) => r.restaurantId!).toList(),
    );
    notifyListeners();
  }

  bool isRestaurantFavorite(int restaurantId) {
    return favorites.any((r) => r.restaurantId == restaurantId);
  }

  bool isCuisineFavorite(String cuisine) {
    return favoriteCuisines.contains(cuisine);
  }

  Future<void> toggleCuisineFavorite(String cuisine) async {
    if (favoriteCuisines.contains(cuisine)) {
      favoriteCuisines.remove(cuisine);
    } else {
      favoriteCuisines.add(cuisine);
    }
    await _storage.saveFavoriteCuisines(favoriteCuisines);
    notifyListeners();
  }
}