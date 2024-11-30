class Category {
  final int idCategorie;
  final String nomCategorie;
  final String imageUrl;

  // Constructeur
  Category({
    required this.idCategorie,
    required this.nomCategorie,
    required this.imageUrl,
  });

  // Méthode fromJson pour convertir le JSON en instance de Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategorie: json['idCategorie'], // Assurez-vous que ces clés existent dans votre JSON
      nomCategorie: json['nomCategorie'],
      imageUrl: json['imageUrl'],
    );
  }

  get name => null;

  // Méthode toJson pour convertir l'instance de Category en JSON
  Map<String, dynamic> toJson() {
    return {
      'idCategorie': idCategorie,
      'nomCategorie': nomCategorie,
      'imageUrl': imageUrl,
    };
  }
}
