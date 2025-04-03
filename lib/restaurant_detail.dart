import 'package:flutter/material.dart';
import '../models/Restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetail extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetail({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name ?? "Détails")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREgDDOHY30gdRmIt2Q5sjLTlav9OUdNMtlqKEV-QXbGFPi2W-egDo8pJU5Kw&s",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name ?? "Nom inconnu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 5),
                      Expanded(child: Text(restaurant.address ?? 'Adresse non renseignée')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.orange),
                      SizedBox(width: 5),
                      Expanded(child: Text("Cuisine: \${restaurant.cuisines.join(', ')}")),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (restaurant.phone != null)
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Text(
                            restaurant.phone!,
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  if (restaurant.website != null)
                    Row(
                      children: [
                        Icon(Icons.language, color: Colors.blue),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Text(
                            "Visiter le site web",
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
