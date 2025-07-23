import 'package:proser/screens/components/constant.dart';

class BestDeal {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String bhk;
  final String priceRange;
  final String bhkSize;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  BestDeal({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.bhk,
    required this.priceRange,
    required this.bhkSize,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory BestDeal.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";
    return BestDeal(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      bhk: json['bhk'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class EditorsChoice {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  EditorsChoice({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory EditorsChoice.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";
    return EditorsChoice(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      bhk: json['bhk'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class ProminentBuilder {
  final int id;

  // Builder info
  final int builderId;
  final String builderName;
  final String builderLogo;
  final String validatedBuilderLogo;
  final String builderSlug; // ✅ builder.slug

  // Project info
  final int projectId;
  final String projectTitle;
  final String projectSlug; // ✅ project.slug
  final String projectCoverImage;
  final String validatedCoverImage;
  final String projectLogo;
  final String validatedProjectLogo;

  // Common info
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String listingType;
  final String propertyType;

  ProminentBuilder({
    required this.id,
    required this.builderId,
    required this.builderName,
    required this.builderLogo,
    required this.validatedBuilderLogo,
    required this.builderSlug,
    required this.projectId,
    required this.projectTitle,
    required this.projectSlug,
    required this.projectCoverImage,
    required this.validatedCoverImage,
    required this.projectLogo,
    required this.validatedProjectLogo,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.listingType,
    required this.propertyType,
  });

  factory ProminentBuilder.fromJson(Map<String, dynamic> json) {
    final builder = json['builder'] ?? {};
    final project = json['project'] ?? {};

    final builderLogoRaw = builder['company_logo'] ?? "";
    final projectCoverRaw = project['cover_image'] ?? "";
    final projectLogoRaw = project['logo'] ?? "";

    return ProminentBuilder(
      id: json['id'] ?? 0,
      builderId: builder['id'] ?? 0,
      builderName: builder['company_name'] ?? "",
      builderLogo: builderLogoRaw,
      validatedBuilderLogo: builderLogoRaw.isNotEmpty
          ? "${AppConstants.baseUrl1}/$builderLogoRaw"
          : "assets/images/builder_logo.png",
      builderSlug: builder['slug'] ?? "",

      projectId: project['id'] ?? 0,
      projectTitle: project['title'] ?? "",
      projectSlug: project['slug'] ?? "",
      projectCoverImage: projectCoverRaw,
      validatedCoverImage: projectCoverRaw.isNotEmpty
          ? "${AppConstants.baseUrl1}/$projectCoverRaw"
          : "assets/images/default.png",
      projectLogo: projectLogoRaw,
      validatedProjectLogo: projectLogoRaw.isNotEmpty
          ? "${AppConstants.baseUrl1}/$projectLogoRaw"
          : "assets/images/builder_logo.png",

      location: project['location'] ?? "",
      possession: project['possession'] ?? "",
      priceRange: project['price_range'] ?? "",
      bhkSize: project['bhk_size'] ?? "",
      bhk: project['bhk'] ?? "",
      listingType: project['listing_type'] ?? "",
      propertyType: project['property_type'] ?? "",
    );
  }
}


class SelectedProperty {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  SelectedProperty({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory SelectedProperty.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";

    return SelectedProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      bhk: json['bhk'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class LifestyleProperty {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  LifestyleProperty({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory LifestyleProperty.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";

    return LifestyleProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      bhk: json['bhk'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class NewLaunchProperty {
  final int id;
  final String title;
  final String slug;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogo;
  final String companyLogo;
  final String validatedCompanyLogo;
  final String companyName;
  final String listingType;
  final String propertyType;
  final String builderName;

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
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogo,
    required this.companyLogo,
    required this.validatedCompanyLogo,
    required this.companyName,
    required this.listingType,
    required this.propertyType,
    required this.builderName
  });

  factory NewLaunchProperty.fromJson(Map<String, dynamic> json) {
    String base = AppConstants.baseUrl1;

    String imgUrl(String path) =>
        path.isNotEmpty ? "$base/$path" : "assets/images/default.png";

    return NewLaunchProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      byLabel: json['by_label'] ?? '',
      location: json['location'] ?? '',
      possession: json['possession'] ?? '',
      priceRange: json['price_range'] ?? '',
      bhkSize: json['bhk_size'] ?? '',
      bhk: json['bhk'] ?? '',
      imageUrl: json['image_url'] ?? '',
      validatedImageUrl: imgUrl(json['image_url'] ?? ''),
      logo: json['logo'] ?? '',
      validatedLogo: imgUrl(json['logo'] ?? ''),
      companyLogo: json['company_logo'] ?? '',
      validatedCompanyLogo: imgUrl(json['company_logo'] ?? ''),
      companyName: json['company_name'] ?? '',
      listingType: json['listing_type'] ?? '',
      propertyType: json['property_type'] ?? '',
      builderName: json['by_label']??'',
    );
  }
}

class ReadyToMoveProperty {
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

  ReadyToMoveProperty({
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

  String get validatedImageUrl =>
      imageUrl.isNotEmpty ? "${AppConstants.baseUrl1}/$imageUrl" : "assets/images/default.png";

  String get validatedLogo =>
      logo.isNotEmpty ? "${AppConstants.baseUrl1}/$logo" : "assets/images/builder_logo.png";

  factory ReadyToMoveProperty.fromJson(Map<String, dynamic> json) {
    return ReadyToMoveProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      byLabel: json['by_label'] ?? '',
      location: json['location'] ?? '',
      possession: json['possession'] ?? '',
      priceRange: json['price_range'] ?? '',
      bhkSize: json['bhk_size'] ?? '',
      bhk: json['bhk'] ?? '',
      imageUrl: json['image_url'] ?? '',
      logo: json['logo'] ?? '',
      slug: json['slug'] ?? '',
      listingType: json['listing_type'] ?? '',
      propertyType: json['property_type'] ?? '',
    );
  }
}

class LimelightProperty {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  LimelightProperty({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory LimelightProperty.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";

    return LimelightProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      bhk: json['bhk'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class SponsoredProperty {
  final int id;
  final String title;
  final String byLabel;
  final String location;
  final String possession;
  final String priceRange;
  final String bhkSize;
  final String bhk;
  final String imageUrl;
  final String validatedImageUrl;
  final String logo;
  final String validatedLogoUrl;
  final String slug;
  final String listingType;
  final String propertyType;

  SponsoredProperty({
    required this.id,
    required this.title,
    required this.byLabel,
    required this.location,
    required this.possession,
    required this.priceRange,
    required this.bhkSize,
    required this.bhk,
    required this.imageUrl,
    required this.validatedImageUrl,
    required this.logo,
    required this.validatedLogoUrl,
    required this.slug,
    required this.listingType,
    required this.propertyType,
  });

  factory SponsoredProperty.fromJson(Map<String, dynamic> json) {
    final imgUrl = json['image_url'] ?? "";
    final logoUrl = json['logo'] ?? "";

    return SponsoredProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      byLabel: json['by_label'] ?? "",
      location: json['location'] ?? "",
      possession: json['possession'] ?? "",
      priceRange: json['price_range'] ?? "",
      bhkSize: json['bhk_size'] ?? "",
      bhk: json['bhk'] ?? "",
      imageUrl: imgUrl,
      validatedImageUrl: imgUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imgUrl"
          : "assets/images/default.png",
      logo: logoUrl,
      validatedLogoUrl: logoUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$logoUrl"
          : "assets/images/builder_logo.png",
      slug: json['slug'] ?? "",
      listingType: json['listing_type'] ?? "",
      propertyType: json['property_type'] ?? "",
    );
  }
}

class HotLocality {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String validatedImageUrl;
  final String? logo;
  final String shortDescription;

  HotLocality({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.validatedImageUrl,
    required this.logo,
    required this.shortDescription,
  });

  factory HotLocality.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['image'] ?? '';
    return HotLocality(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: imageUrl,
      validatedImageUrl: imageUrl.isNotEmpty
          ? "${AppConstants.baseUrl1}/$imageUrl".replaceAll('//', '/').replaceFirst(':/', '://')
          : 'assets/images/default.png',
      logo: json['logo'],
      shortDescription: json['short_description'] ?? '',
    );
  }
}