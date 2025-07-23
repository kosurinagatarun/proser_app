class ProjectModel {
  final int id;
  final String title;
  final String city;
  final String state;
  final String logo;
  final String about;
  final List<String> amenities;
  final List<String> offers;
  final List<String> images;

  final String projectSize;
  final String noOfUnits;
  final String possessionBy;
  final String configurations;
  final String availableSizes;
  final String basePrice;

  ProjectModel({
    required this.id,
    required this.title,
    required this.city,
    required this.state,
    required this.logo,
    required this.about,
    required this.amenities,
    required this.offers,
    required this.images,
    required this.projectSize,
    required this.noOfUnits,
    required this.possessionBy,
    required this.configurations,
    required this.availableSizes,
    required this.basePrice,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    final about = json['about']?['about'] ?? '';
    final amenitiesList = json['amenities'] as List<dynamic>? ?? [];
    final offersList = json['offers'] as List<dynamic>? ?? [];
    final galleryList = json['gallery'] as List<dynamic>? ?? [];

    final apartment = json['apartment'];

    final projectSize = apartment['project_size']?.toString() ?? '';
    final noOfUnits = apartment['no_of_units']?.toString() ?? '';
    final possessionBy = apartment['possession_by'] ?? '';
    final configurations = apartment['configurations'] ?? '';
    final availableSizes = apartment['available_sizes'] ?? '';
    final basePrice = apartment['base_price'] ?? '';

    List<String> amenities = amenitiesList.map((e) => e['name'].toString()).toList();

    List<String> offers = offersList.map((e) => e['offer_text'].toString()).toList();

    List<String> images = [];
    for (var category in galleryList) {
      if (category is List) {
        for (var item in category) {
          images.add(item['image_url'].toString());
        }
      }
    }

    return ProjectModel(
      id: project['id'],
      title: project['title'] ?? '',
      city: project['city'] ?? '',
      state: project['state'] ?? '',
      logo: project['logo'] ?? '',
      about: about,
      amenities: amenities,
      offers: offers,
      images: images,
      projectSize: projectSize,
      noOfUnits: noOfUnits,
      possessionBy: possessionBy,
      configurations: configurations,
      availableSizes: availableSizes,
      basePrice: basePrice,
    );
  }
}
