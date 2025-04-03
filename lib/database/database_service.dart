import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Restaurant.dart';
import '../models/Review.dart';
import '../models/User.dart';

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
        final cuisines = await getCuisinesForRestaurant(
            restaurantData['restaurant_id']);
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

      return (data as List)
          .map((c) => c['Cuisines']['name'] as String)
          .toList();
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

  Future<Restaurant?> getRestaurant(int restaurantId) async {
    try {
      // Requête : Récupérer les détails du restaurant et les cuisines associées via la jointure.
      final response = await _supabase
          .from('Restaurants')
          .select('*, Restaurants_Cuisines(cuisine_id), Cuisines(name)')
          .eq('restaurant_id', restaurantId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      // Récupérer les noms des cuisines depuis la réponse
      final cuisinesResponse = response['Restaurants_Cuisines'] as List<
          dynamic>;
      final cuisinesNames = cuisinesResponse
          .map((c) => c['cuisine_id'])
          .toList();

      final cuisineNamesResponse = response['Cuisines'] as List<dynamic>;
      final cuisines = cuisineNamesResponse
          .map((c) => c['name'] as String)
          .toList();

      // Retourner un restaurant avec les cuisines récupérées
      return Restaurant.fromJson(response, cuisines);
    } catch (error) {
      print('Erreur lors de la récupération du restaurant: $error');
      return null;
    }
  }

  Future<List<Restaurant>> getRestaurantsByCuisine(String cuisine) async {
    try {
      // 1ère requête : Récupérer les restaurants ayant la cuisine spécifiée
      final response = await _supabase
          .from('Restaurants')
          .select('*, Restaurants_Cuisines(cuisine_id), Cuisines(name)')
          .eq('Cuisines.name', cuisine);

      if (response.isEmpty) {
        return [];
      }

      List<Restaurant> restaurants = [];

      // Parcourir la réponse et extraire les informations des restaurants et des cuisines
      for (var restaurantData in response) {
        final cuisinesResponse = restaurantData['Cuisines'] as List<dynamic>;
        final cuisines = cuisinesResponse
            .map((c) => c['name'] as String)
            .toList();

        // Créer un objet Restaurant avec les données récupérées
        final restaurant = Restaurant.fromJson(restaurantData, cuisines);
        restaurants.add(restaurant);
      }

      return restaurants;
    } catch (error) {
      print('Erreur lors de la récupération des restaurants: $error');
      return [];
    }
  }

  Future<bool> _verifyPassword(String password, String hashedPassword) async {
    // Utiliser bcrypt pour comparer le mot de passe avec le hash
    return BCrypt.checkpw(password, hashedPassword);
  }

  Future<Utilisateur?> getUser(String email, String password) async {
    try {
      // 1. Requête pour récupérer l'utilisateur avec l'email
      final response = await _supabase
          .from('Utilisateur')
          .select('*')
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        // Aucun utilisateur trouvé avec cet email
        return null;
      }

      // 2. Récupérer le mot de passe haché de l'utilisateur
      final passwordHash = response['password_hash'];

      // 3. Vérifier si le mot de passe correspond au hachage
      if (!await _verifyPassword(password, passwordHash)) {
        // Si le mot de passe ne correspond pas
        return null;
      }

      // 4. Récupérer les cuisines et restaurants favoris de l'utilisateur
      final cuisinesResponse = await _supabase
          .from('Cuisines')
          .select('name')
          .eq('id', response['favorite_cuisines']);

      final cuisines = cuisinesResponse.map<String>((
          cuisine) => cuisine['name']).toList();

      final restaurantsResponse = await _supabase
          .from('Restaurants')
          .select('name')
          .eq('id', response['favorite_restaurants']);

      final restaurants = restaurantsResponse.map<String>((
          restaurant) => restaurant['name']).toList();

      // Créer l'objet User avec les cuisines et restaurants favoris
      return Utilisateur.fromJson(response, cuisines, restaurants);
    } catch (error) {
      print('Erreur lors de la récupération de l\'utilisateur: $error');
      return null;
    }
  }

  Future<Utilisateur?> registerUser(String prenom, String nom, String email,
      String password) async {
    try {
      // 1. Hachage du mot de passe (vous pouvez aussi utiliser une méthode de hachage côté serveur si nécessaire)
      final hashedPassword = await hashPassword(password);

      // 2. Insertion de l'utilisateur dans la base de données Supabase
      final response = await _supabase.from('Utilisateur').insert([
        {
          'prenom': prenom,
          'nom': nom,
          'email': email,
          'password_hash': hashedPassword,
        }
      ]);

      if (response.error != null) {
        print('Erreur lors de l\'insertion de l\'utilisateur: ${response.error
            ?.message}');
        return null;
      }

      // 3. Récupérer les informations de l'utilisateur
      return await getUser(email, password);
    } catch (error) {
      print('Erreur lors de l\'enregistrement de l\'utilisateur: $error');
      return null;
    }
  }

  Future<String> hashPassword(String password) async {
    // bcrypt pour générer le hash du mot de passe
    final salt = BCrypt.gensalt(); // Générer un salt
    final hashedPassword = BCrypt.hashpw(
        password, salt); // Hacher le mot de passe avec le salt
    return hashedPassword;
  }

  Future<double?> getRestaurantRating(int restaurantId) async {
    final response = await _supabase
        .from('Reviews')
        .select('rating')
        .eq('restaurant_id', restaurantId);

    if (response.isEmpty) {
      return null; // Pas de notes pour ce restaurant
    }

    // Calculer la moyenne des ratings
    double sum = 0;
    for (var review in response) {
      sum += (review['rating'] as num).toDouble();
    }

    return sum / response.length;
  }

  Future<Utilisateur?> getUserById(int userId) async {
    final response = await _supabase
        .from('Utilisateur')
        .select('id, prenom, email, nom')
        .eq('id', userId)
        .single();

    if (response == null) return null;

    return Utilisateur(
      id: response['id'],
      firstName: response['prenom'],
      email: response['email'],
      passwordHash: '',
      // Optionnel : Ne pas stocker le hash dans l'objet
      lastName: response['nom'],
      favoriteCuisines: [],
      favoriteRestaurants: [],
    );
  }

  // Fonction pour récupérer les avis d'un restaurant
  Future<List<Review>> getRestaurantReviews(int restaurantId) async {
    // Récupérer les avis du restaurant
    final response = await _supabase
        .from('Reviews')
        .select('reviews_id, user_id, rating, comment, created_at')
        .eq('restaurant_id', restaurantId);

    if (response.isEmpty) return [];

    List<Review> reviewsList = [];


    // Parcourir les avis et récupérer les utilisateurs associés
    for (var reviewJson in response) {
      // Créer l'objet Review et l'ajouter à la liste
      reviewsList.add(Review(
        id: reviewJson['reviews_id'],
        Idrestaurant: reviewJson['restaurant_id'],
        Iduser: reviewJson['user_id'],
        rating: reviewJson['rating'],
        comment: reviewJson['comment'],
        date: DateTime.parse(reviewJson['created_at']),
      ));
    }

    return reviewsList;
  }

  // Fonction pour récupérer tous les avis d'un utilisateur en se basant uniquement sur les ids
  Future<List<Review>> getReviewsUser(int userId) async {
    final response = await _supabase
        .from('Reviews')
        .select('reviews_id, restaurant_id, rating, comment, created_at')
        .eq('user_id', userId);

    if (response.isEmpty) return [];

    List<Review> reviewsList = [];

    for (var reviewJson in response) {
      // Créer l'objet Review et l'ajouter à la liste
      reviewsList.add(Review(
        id: reviewJson['reviews_id'],
        Idrestaurant: reviewJson['restaurant_id'],
        Iduser: userId,
        rating: reviewJson['rating'],
        comment: reviewJson['comment'],
        date: DateTime.parse(reviewJson['created_at']),
      ));
    }

    return reviewsList;
  }

  Future<void> addReview(int restaurantId, int userId, double rating,
      String comment) async {
    final response = await _supabase
        .from('Reviews')
        .insert([
      {
        'restaurant_id': restaurantId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'created_at': DateTime.now().toIso8601String()
        // Optionnel si tu veux définir la date
      }
    ]);

    if (response.error != null) {
      throw Exception('Failed to add review: ${response.error!.message}');
    }
  }

  Future<List<String>> getFavoriteCuisines(int userId) async {
    List<String> favoriteCuisines = [];

    try {
      // Effectuer une requête pour récupérer les noms des cuisines favorites
      final response = await _supabase
          .from('Cuisines_Favoris')
          .select('Cuisines(name)') // Sélectionner le nom de la cuisine
          .eq('user_id', userId); // Filtrer par user_id

      // Extraire les noms des cuisines à partir de la réponse
      for (var cuisine in response) {
        favoriteCuisines.add(cuisine['name']);
      }
    } catch (e) {
      // Gérer l'exception
      throw Exception(
          'Erreur lors de la récupération des cuisines favorites : ${e}');
      // Vous pouvez également afficher un message à l'utilisateur ou effectuer d'autres actions
    }

    return favoriteCuisines;
  }

  Future<void> addCuisineFavorite(int userId, String cuisineName) async {
    try {
      // 1. Récupérer l'ID de la cuisine à partir de son nom
      final cuisineResponse = await _supabase
          .from('Cuisines')
          .select('cuisine_id')
          .eq('name', cuisineName)
          .maybeSingle();

      if (cuisineResponse == null) {
        print('Cuisine non trouvée');
        return;
      }

      final cuisineId = cuisineResponse['cuisine_id'];

      // 2. Ajouter la cuisine aux favoris de l'utilisateur
      final response = await _supabase.from('Cuisines_Favoris').insert([
        {
          'user_id': userId,
          'cuisine_id': cuisineId,
        }
      ]);

      if (response.error != null) {
        print('Erreur lors de l\'ajout de la cuisine aux favoris : ${response
            .error?.message}');
      } else {
        print('Cuisine ajoutée avec succès aux favoris');
      }
    } catch (error) {
      print('Erreur lors de l\'ajout de la cuisine aux favoris: $error');
    }
  }

  Future<void> deleteCuisineFavorite(int userId, String cuisineName) async {
    try {
      // 1. Récupérer l'ID de la cuisine en fonction du nom
      final cuisineResponse = await _supabase
          .from('Cuisines')
          .select('cuisine_id')
          .eq('name', cuisineName)
          .maybeSingle();

      if (cuisineResponse == null) {
        print('Cuisine non trouvée');
        return;
      }

      final cuisineId = cuisineResponse['cuisine_id'];

      // 2. Supprimer l'entrée correspondante dans Cuisines_Favoris
      final deleteResponse = await _supabase
          .from('Cuisines_Favoris')
          .delete()
          .eq('user_id', userId)
          .eq('cuisine_id', cuisineId);

      if (deleteResponse.error != null) {
        print('Erreur lors de la suppression : ${deleteResponse.error?.message}');
      } else {
        print('Cuisine favorite supprimée avec succès');
      }
    } catch (error) {
      print('Erreur lors de la suppression de la cuisine favorite : $error');
    }
  }

  Future<List<Restaurant>> getRestaurantsFavorite(int userId) async {
    try {
      // 1. Récupérer les IDs des restaurants favoris de l'utilisateur
      final favoritesResponse = await _supabase
          .from('Restaurant_Favoris')
          .select('restaurant_id')
          .eq('user_id', userId);

      if (favoritesResponse.isEmpty) {
        return []; // Aucun restaurant favori trouvé
      }

      // 2. Récupérer les détails des restaurants favoris
      final restaurantIds = favoritesResponse.map<int>((
          fav) => fav['restaurant_id'] as int).toList();
      final restaurantsResponse = await _supabase
          .from('Restaurants')
          .select('*')
          .inFilter('restaurant_id', restaurantIds);

      if (restaurantsResponse.isEmpty) {
        return []; // Aucun détail de restaurant trouvé
      }

      // 3. Récupérer les cuisines associées à chaque restaurant
      List<Restaurant> favoriteRestaurants = [];
      for (var restaurantData in restaurantsResponse) {
        final restaurantId = restaurantData['restaurant_id'] as int;

        // Récupérer les cuisines associées au restaurant
        final cuisinesResponse = await _supabase
            .from('Restaurants_Cuisines')
            .select('cuisine_id')
            .eq('restaurant_id', restaurantId);

        List<String> cuisines = [];
        for (var cuisineData in cuisinesResponse) {
          final cuisineId = cuisineData['cuisine_id'] as int;
          final cuisineDetailResponse = await _supabase
              .from('Cuisines')
              .select('name')
              .eq('cuisine_id', cuisineId)
              .maybeSingle();

          if (cuisineDetailResponse != null) {
            cuisines.add(cuisineDetailResponse['name'] as String);
          }
        }

        // Créer un objet Restaurant avec les données récupérées
        Restaurant restaurant = Restaurant(
          restaurantId: restaurantData['restaurant_id'] as int,
          name: restaurantData['name'] as String,
          address: restaurantData['address'] as String,
          cuisines: cuisines,
          // Ajouter d'autres champs selon la structure de votre table Restaurants
        );

        favoriteRestaurants.add(restaurant);
      }

      return favoriteRestaurants;
    } catch (error) {
      print('Erreur lors de la récupération des restaurants favoris : $error');
      return [];
    }
  }

  Future<void> addRestaurantFavorite(int userId, int restaurantId) async {
    try {
      final response = await _supabase.from('Restaurant_Favoris').upsert([
        {
          'user_id': userId,
          'restaurant_id': restaurantId,
        }
      ]);

      if (response.error != null) {
        print('Erreur lors de l\'ajout aux favoris : ${response.error?.message}');
      } else {
        print('Restaurant ajouté aux favoris avec succès');
      }
    } catch (error) {
      print('Erreur lors de l\'ajout du restaurant aux favoris : $error');
    }
  }

  Future<void> removeRestaurantFavorite(int userId, int restaurantId) async {
    try {
      final response = await _supabase
          .from('Restaurant_Favoris')
          .delete()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId);

      if (response.error != null) {
        print('Erreur lors de la suppression des favoris : ${response.error?.message}');
      } else {
        print('Restaurant supprimé des favoris avec succès');
      }
    } catch (error) {
      print('Erreur lors de la suppression du restaurant des favoris : $error');
    }
  }



}

