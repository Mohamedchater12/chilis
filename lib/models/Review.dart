class Review {
  final String title;
  final String description;
  final double rating;

  // Constructeur
  Review({
    required this.title,
    required this.description,
    required this.rating,
  });

  // Factory pour convertir le JSON en Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      title: json['title'],
      description: json['description'],
      rating: json['rating'].toDouble(),  // Assurez-vous que la note est un nombre
    );
  }
}
