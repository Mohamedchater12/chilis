class Banner {
  final String idBanner;
  final String image;
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
