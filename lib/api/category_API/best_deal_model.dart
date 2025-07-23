class BestDealModel {
  final String title;
  final String username;
  final String propertyType;
  final String availability;
  final String city;
  final String priceFrom;
  final String priceTo;
  final String coverImage;
  final String builderLogo;

  BestDealModel({
    required this.title,
    required this.username,
    required this.propertyType,
    required this.availability,
    required this.city,
    required this.priceFrom,
    required this.priceTo,
    required this.coverImage,
    required this.builderLogo,
  });

  factory BestDealModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    final apartment = json['apartment'];
    final user = project['user'];

    return BestDealModel(
      title: project['title'] ?? '',
      username: user['username'] ?? '',
      propertyType: project['project_category'] ?? '',
      availability: project['possession_by'] ?? '',
      city: project['city'] ?? '',
      priceFrom: apartment['price_from'] ?? '',
      priceTo: apartment['price_to'] ?? '',
      coverImage: apartment['cover_image'] ?? '',
      builderLogo: user['company_logo'] ?? '',
    );
  }
}
