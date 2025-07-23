import 'package:proser/screens/components/constant.dart';


class HotLocalityDetail {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String? logo;
  final String descriptionTop;
  final String descriptionBottom;
  final List<HotLocalityProject> projects;

  HotLocalityDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.logo,
    required this.descriptionTop,
    required this.descriptionBottom,
    required this.projects,
  });

  factory HotLocalityDetail.fromJson(Map<String, dynamic> json) {
    return HotLocalityDetail(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: "${AppConstants.baseUrl1}/${json['image']}",
      logo: json['logo'] != null ? "${AppConstants.baseUrl1}/${json['logo']}" : null,
      descriptionTop: json['description_top'] ?? '',
      descriptionBottom: json['description_bottom'] ?? '',
      projects: (json['projects'] as List)
          .map((item) => HotLocalityProject.fromJson(item))
          .toList(),
    );
  }
}

class HotLocalityProject {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String slug;
  final String listingType;
  final String propertyType;

  HotLocalityProject({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory HotLocalityProject.fromJson(Map<String, dynamic> json) {
    return HotLocalityProject(
      id: json['id'],
      title: json['title'],
      byLabel: json['by_label'],
      location: json['location'],
      possession: json['possession'],
      priceRange: json['price_range'],
      bhkSize: json['bhk_size'],
      bhk: json['bhk'],
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url']}",
      logo: "${AppConstants.baseUrl1}/${json['logo']}",
      slug: json['slug'],
      listingType: json['listing_type'],
      propertyType: json['property_type'],
    );
  }
}
