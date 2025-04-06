import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _favoriteRestaurantsKey = 'favorite_restaurants';
  static const _favoriteCuisinesKey = 'favorite_cuisines';

  Future<void> saveFavoriteRestaurants(List<int> restaurantIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoriteRestaurantsKey,
      restaurantIds.map((id) => id.toString()).toList(),
    );
  }

  Future<List<int>> getFavoriteRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoriteRestaurantsKey) ?? [];
    return ids.map(int.parse).toList();
  }

  Future<void> saveFavoriteCuisines(List<String> cuisines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCuisinesKey, cuisines);
  }

  Future<List<String>> getFavoriteCuisines() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCuisinesKey) ?? [];
  }

  Future<void> toggleRestaurantFavorite(int restaurantId, bool isFavorite) async {
    final favorites = await getFavoriteRestaurants();
    if (isFavorite) {
      favorites.add(restaurantId);
    } else {
      favorites.remove(restaurantId);
    }
    await saveFavoriteRestaurants(favorites);
  }
}