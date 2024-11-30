import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../models/Review.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final String apiUrlCategories = 'http://10.0.2.2:9092/api/categories';
  final String apiUrlReviews = 'http://10.0.2.2:9092/api/reviews';  // URL de l'API pour les critiques

  // Récupérer les catégories
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrlCategories));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Récupérer les critiques
  Future<List<Review>> fetchReviews() async {
    final response = await http.get(Uri.parse(apiUrlReviews));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discover Our Menu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Category>>(
                future: fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Failed to load categories"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No categories available"));
                  } else {
                    return ListView(
                      children: snapshot.data!.map((category) {
                        return _buildMenuItem(category.nomCategorie);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<Review>>(
                future: fetchReviews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Failed to load reviews"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No reviews available"));
                  } else {
                    return ListView(
                      children: snapshot.data!.map((review) {
                        return _buildReviewItem(review);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construction des éléments du menu
  Widget _buildMenuItem(String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.fastfood_outlined, color: Colors.red),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Action pour l'élément du menu
        },
      ),
    );
  }

  // Construction des éléments des avis
  Widget _buildReviewItem(Review review) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.yellow),
        title: Text(review.title, style: TextStyle(fontSize: 18)),
        subtitle: Text(review.description),
        trailing: Text(review.rating.toString(), style: TextStyle(fontSize: 16)),
        onTap: () {
          // Action pour l'élément d'avis
        },
      ),
    );
  }
}
