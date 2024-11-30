import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../models/Review.dart';
import 'ReviewDetailsScreen.dart';

// Modèle Banner
class Banner {
  final String idBanner;
  late final String image;
  final bool etatBanner;

  Banner({required this.idBanner, required this.image, required this.etatBanner});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      idBanner: json['idBanner'],
      image: json['image'],
      etatBanner: json['etatBanner'],
    );
  }
}

// Modèle Category
class Category {
  final String idCategorie;
  final String nomCategorie;
  final String imageUrl;

  Category({required this.idCategorie, required this.nomCategorie, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategorie: json['idCategorie'],
      nomCategorie: json['nomCategorie'],
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150', // Image par défaut
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Liste statique de critiques
  List<Review> staticReviews = [
    Review(title: "Great Pizza!", description: "Delicious crust and toppings.", rating: 4.5),
    Review(title: "Fresh Salad", description: "Very fresh and healthy.", rating: 4.3),
  ];

  // Fonction pour récupérer les bannières depuis l'API
  Future<List<Banner>> fetchBanners() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9092/api/banners'));

      if (response.statusCode == 200) {
        List<dynamic> bannersJson = json.decode(response.body);
        return bannersJson.map((json) => Banner.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fonction pour récupérer les catégories depuis l'API
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9092/api/categories'));

      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = json.decode(response.body);
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void navigateToCategoryDetails(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => categoryDetailsScreen(category: category),
      ),
    );
  }

  void navigateToReviewDetails(Review review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailsScreen(review: review),
      ),
    );
  }

  void navigateToViewAllCategories() {
    // Rediriger vers un écran contenant toutes les catégories
  }

  // Boîte de dialogue pour ajouter un avis
  void _showAddReviewDialog() {
    String title = '';
    String description = '';
    double rating = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating (0-5)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rating = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty && rating > 0.0 && rating <= 5.0) {
                  setState(() {
                    staticReviews.add(Review(
                      title: title,
                      description: description,
                      rating: rating,
                    ));
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chili's Tunisie"),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Barre de recherche
    TextField(
    decoration: InputDecoration(
    hintText: "Search on Coody",
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.grey[200],
    ),
    ),
    SizedBox(height: 16),

    // Bannière d'images de nourriture (avec les données de l'API)
    Container(
    height: 200,
    child: FutureBuilder<List<Banner>>(
    future: fetchBanners(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(
    child: Text('Failed to load banners: ${snapshot.error}'),
    );
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
    final banners = snapshot.data!;
    return PageView(
    children: banners
        .where((banner) => banner.etatBanner)
        .map((banner) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
    banner.image,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
    return Image.network(
    'https://via.placeholder.com/300x150?text=No+Image',
    fit: BoxFit.cover,
    );
    },
    ),
    ),
    ))
        .toList(),
    );
    } else {
    return Center(child: Text('No banners available'));
    }
    },
    ),
    ),

    SizedBox(height: 16),

    // Section des catégories sous forme d'images horizontales
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    "Popular Categories",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    TextButton(
    onPressed: navigateToViewAllCategories,
    child: Text("View All"),
    ),
    ],
    ),
    SizedBox(height: 8),
    Container(
    height: 140,
    child: FutureBuilder<List<Category>>(
    future: fetchCategories(),
    builder: (context, snapshot)                  {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Failed to load categories: ${snapshot.error}'),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final categories = snapshot.data!;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () => navigateToCategoryDetails(category),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        category.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://via.placeholder.com/100x100?text=No+Image',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      category.nomCategorie,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return Center(child: Text('No categories available'));
      }
    },
    ),
    ),

      SizedBox(height: 16),

      // Liste des critiques (statique)
      Text(
        "Latest Reviews",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: staticReviews.length,
        itemBuilder: (context, index) {
          final review = staticReviews[index];
          return GestureDetector(
            onTap: () => navigateToReviewDetails(review),
            child: Card(
              child: ListTile(
                title: Text(review.title),
                subtitle: Text(
                  review.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  review.rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),

      // Bouton pour ajouter une critique
      Center(
        child: ElevatedButton(
          onPressed: _showAddReviewDialog,
          child: Text("Add Review"),
        ),
      ),
    ],
    ),
    ),
        ),
    );
  }

  categoryDetailsScreen({required Category category}) {}
}

