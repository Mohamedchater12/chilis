import 'package:flutter/material.dart';
import 'screens/home_screen.dart';  // Assurez-vous d'importer HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Reviews App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),  // Définir l'écran d'accueil
    );
  }
}
