import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Restaurant.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Restaurant>> getRestaurants({int limit = 30}) async {
    try {
      final data = await _supabase
          .from('Restaurants')
          .select()
      .limit(limit);

      print(data);

      List<Restaurant> restaurants = [];
      for (var restaurantData in data as List) {
        final cuisines = await getCuisinesForRestaurant(restaurantData['restaurant_id']);
        restaurants.add(Restaurant.fromJson(restaurantData, cuisines));
      }
      return restaurants;
    } catch (e) {
      throw Exception('Failed to fetch restaurants: $e');
    }
  }

  Future<List<String>> getCuisinesForRestaurant(int restaurantId) async {
    try {
      final data = await _supabase
          .from('Restaurants_Cuisines')
          .select('Cuisines(name)')
          .eq('restaurant_id', restaurantId);

      return (data as List).map((c) => c['Cuisines']['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch cuisines for restaurant: $e');
    }
  }

  Future<List<String>> getCuisines() async {
    try {
      final data = await _supabase
          .from('Cuisines')
          .select('name');

      return (data as List).map((c) => c['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch cuisines: $e');
    }
  }

  Future<Map<String, dynamic>?> getRestaurant(int restaurantId) async {
    final response = await _supabase
        .from('Restaurants')
        .select()
        .eq('restaurant_id', restaurantId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    final cuisinesResponse = await _supabase
        .from('Restaurants_Cuisines')
        .select('Cuisines(name)')
        .eq('restaurant_id', restaurantId);

    response['cuisines'] = cuisinesResponse.map((c) => c['Cuisines']['name']).toList();

    return response;
  }


}
