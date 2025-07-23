import 'package:proser/screens/components/constant.dart';

class LocationPremiumModel {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String? possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String slug;
  final String listingType;
  final String propertyType;
  final int isActive;
  final int order;

  final int categoryId;
  final String categoryName;
  final String categoryImage;

  LocationPremiumModel({
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
    required this.isActive,
    required this.order,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory LocationPremiumModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? {};
    return LocationPremiumModel(
      id: json['id'],
      title: json['title'],
      byLabel: json['by_label'],
      location: json['location'],
      possession: json['possession'],
      priceRange: json['price_range'],
      bhkSize: json['bhk_size'],
      bhk: json['bhk'],
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url'] ?? ''}",
      logo: "${AppConstants.baseUrl1}/${json['logo'] ?? ''}",
      slug: json['slug'],
      listingType: json['listing_type'],
      propertyType: json['property_type'],
      isActive: json['is_active'],
      order: json['order'],
      categoryId: category['id'] ?? 0,
      categoryName: category['name'] ?? '',
      categoryImage: "${AppConstants.baseUrl1}/${category['image'] ?? ''}",
    );
  }
}


class LocationPremiumBanner2 {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String? possession;
  final String projectSize;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String slug;
  final String listingType;
  final String propertyType;
  final int isActive;
  final int order;

  LocationPremiumBanner2({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.projectSize,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.slug,
    required this.listingType,
    required this.propertyType,
    required this.isActive,
    required this.order,
  });



  factory LocationPremiumBanner2.fromJson(Map<String, dynamic> json) {
    return LocationPremiumBanner2(
      id: json['id'],
      title: json['title'],
      byLabel: json['by_label'],
      location: json['location'],
      possession: json['possession'],
      projectSize: json['project_size'],
      priceRange: json['price_range'],
      bhkSize: json['bhk_size'],
      bhk: json['bhk'] ?? '',
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url'] ?? ''}",
      logo: "${AppConstants.baseUrl1}/${json['logo'] ?? ''}",
      slug: json['slug'],
      listingType: json['listing_type'],
      propertyType: json['property_type'],
      isActive: json['is_active'],
      order: json['order'],
    );
  }
}



class NewLaunchProperty {
  final int id;
  final String title;
  final String slug;
  final String byLabel;
  final String location;
  final String? possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String companyLogo;
  final String companyName;
  final String listingType;
  final String propertyType;
  final int isActive;
  final int order;

  NewLaunchProperty({
    required this.id,
    required this.title,
    required this.slug,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.companyLogo,
    required this.companyName,
    required this.listingType,
    required this.propertyType,
    required this.isActive,
    required this.order,
  });

  factory NewLaunchProperty.fromJson(Map<String, dynamic> json) {
    return NewLaunchProperty(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      byLabel: json['by_label'] ?? '',
      location: json['location'] ?? '',
      possession: json['possession'],
      priceRange: json['price_range'] ?? '',
      bhkSize: json['bhk_size'] ?? '',
      bhk: json['bhk'] ?? '',
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url'] ?? ''}",
      logo: "${AppConstants.baseUrl1}/${json['logo'] ?? ''}",
      companyLogo: "${AppConstants.baseUrl1}/${json['company_logo'] ?? ''}",
      companyName: json['company_name'] ?? '',
      listingType: json['listing_type'] ?? '',
      propertyType: json['property_type'] ?? '',
      isActive: json['is_active'] ?? 0,
      order: json['order'] ?? 0,
    );
  }
}

class EditorChoiceLocation {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String? possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String slug;
  final String listingType;
  final String propertyType;
  final bool isActive;
  final int order;

  EditorChoiceLocation({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.slug,
    required this.listingType,
    required this.propertyType,
    required this.isActive,
    required this.order,
  });

  factory EditorChoiceLocation.fromJson(Map<String, dynamic> json) {
    return EditorChoiceLocation(
      id: json['id'],
      title: json['title'] ?? '',
      byLabel: json['by_label'] ?? '',
      location: json['location'] ?? '',
      possession: json['possession'],
      priceRange: json['price_range'] ?? '',
      bhkSize: json['bhk_size'] ?? '',
      bhk: json['bhk'] ?? '',
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url'] ?? ''}",
      logo: "${AppConstants.baseUrl1}/${json['logo'] ?? ''}",
      slug: json['slug'] ?? '',
      listingType: json['listing_type'] ?? '',
      propertyType: json['property_type'] ?? '',
      isActive: json['is_active'] == 1,
      order: json['order'] ?? 0,
    );
  }
}

class UltraLuxuryHome {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String? possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String slug;
  final String listingType;
  final String propertyType;
  final int isActive;
  final int order;

  UltraLuxuryHome({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.slug,
    required this.listingType,
    required this.propertyType,
    required this.isActive,
    required this.order,
  });

  factory UltraLuxuryHome.fromJson(Map<String, dynamic> json) {
    return UltraLuxuryHome(
      id: json['id'],
      title: json['title'],
      byLabel: json['by_label'],
      location: json['location'],
      possession: json['possession'],
      priceRange: json['price_range'],
      bhkSize: json['bhk_size'],
      bhk: json['bhk'] ?? '',
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url']}",
      logo: "${AppConstants.baseUrl1}/${json['logo']}",
      slug: json['slug'],
      listingType: json['listing_type'],
      propertyType: json['property_type'],
      isActive: json['is_active'],
      order: json['order'],
    );
  }
}


class AgentPostedProperty {
  final int id;
  final String title;
  final String role;
  final String slug;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String logo;
  final String companyLogo;
  final String companyName;
  final String listingType;
  final String propertyType;
  final int isActive;
  final int order;

  AgentPostedProperty({
    required this.id,
    required this.title,
    required this.role,
    required this.slug,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.logo,
    required this.companyLogo,
    required this.companyName,
    required this.listingType,
    required this.propertyType,
    required this.isActive,
    required this.order,
  });

  factory AgentPostedProperty.fromJson(Map<String, dynamic> json) {
    return AgentPostedProperty(
      id: json['id'],
      title: json['title'] ?? '',
      role: json['role'] ?? '',
      slug: json['slug'] ?? '',
      byLabel: json['by_label'] ?? '',
      location: json['location'] ?? '',
      possession: json['possession'] ?? '',
      priceRange: json['price_range'] ?? '',
      bhkSize: json['bhk_size'] ?? '',
      bhk: json['bhk'] ?? '',
      imageUrl: "${AppConstants.baseUrl1}/${json['image_url']}",
      logo: "${AppConstants.baseUrl1}/${json['logo']}",
      companyLogo: "${AppConstants.baseUrl1}/${json['company_logo']}",
      companyName: json['company_name'] ?? '',
      listingType: json['listing_type'] ?? '',
      propertyType: json['property_type'] ?? '',
      isActive: json['is_active'] ?? 0,
      order: json['order'] ?? 0,
    );
  }
}
