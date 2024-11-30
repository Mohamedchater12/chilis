class MenuItem {
  final int idItem;
  final String nom;
  final String description;
  final double prix;
  final String imageUrl;
  final int categoryId;

  MenuItem({
    required this.idItem,
    required this.nom,
    required this.description,
    required this.prix,
    required this.imageUrl, // Renamed field
    required this.categoryId,
  });

  // Factory constructor to create a MenuItem from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      idItem: json['idItem'],
      nom: json['nom'],
      description: json['description'],
      prix: json['prix'],
      imageUrl: json['image'], // Map JSON 'image' to 'imageUrl' field
      categoryId: json['category']['idCategorie'],
    );
  }
}
