import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Cart",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCartItem("🍔", "Burger", 2, 5.99),
                  _buildCartItem("🍕", "Pizza", 1, 8.99),
                  _buildCartItem("🍣", "Sushi", 3, 12.50),
                  // Ajouter d'autres articles ici
                ],
              ),
            ),
            Divider(),
            _buildTotalSection(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action à faire pour passer la commande
              },
              child: Text("Checkout"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String emoji, String title, int quantity, double price) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Text(
          emoji,
          style: TextStyle(fontSize: 24),
        ),
        title: Text(title, style: TextStyle(fontSize: 18)),
        subtitle: Text("Quantity: $quantity"),
        trailing: Text("\$${(price * quantity).toStringAsFixed(2)}"),
      ),
    );
  }

  Widget _buildTotalSection() {
    // Calcul du total (exemple statique ici)
    double total = (2 * 5.99) + (1 * 8.99) + (3 * 12.50);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "\$${total.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
