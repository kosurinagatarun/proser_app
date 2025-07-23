import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proser/screens/components/constant.dart';

class Property {
  final String title;
  final String builder;
  final String coverImage;
  final String logo;
  final String possession;
  final String projectSize;
  final int noOfUnits;
  final String configuration;
  final String sizeAvailable;
  final String basePrice;
  final List<String> galleryImages;
  final String geoLatitude;
  final String geoLongitude;
  final String geoAddress;
  final String aboutText;
  final String knowAboutBuilder;
  final List<String> whyPoints;
  final List<String> offers;
  final Map<String, String> details;
  final List<Map<String, String>> gallery;
  final List<Map<String, String>> configurations;
  final List<Map<String, String>> amenities;
  final String specifications;
  final List<Map<String, String>> reviews;
  final List<Map<String, String>> keyHighlights;
  final List<Map<String, String>> hotspots;
  final List<Map<String, String>> loans;
  final List<Map<String, String>> videos;
  final String brochureUrl;

  // ✅ Newly added
  final List<String> elevationImages;
  final List<String> masterPlans;
  final List<String> floorPlans;
  final List<String> towerPlans;
  final List<String> clubhouseImages;
  final List<String> amenitiesImages;
  final List<String> siteMapImages;

  Property({
    required this.title,
    required this.builder,
    required this.coverImage,
    required this.logo,
    required this.possession,
    required this.projectSize,
    required this.noOfUnits,
    required this.configuration,
    required this.sizeAvailable,
    required this.basePrice,
    required this.galleryImages,
    required this.geoLatitude,
    required this.geoLongitude,
    required this.geoAddress,
    required this.aboutText,
    required this.knowAboutBuilder,
    required this.whyPoints,
    required this.offers,
    required this.details,
    required this.gallery,
    required this.configurations,
    required this.amenities,
    required this.specifications,
    required this.reviews,
    required this.keyHighlights,
    required this.hotspots,
    required this.loans,
    required this.videos,
    required this.brochureUrl,
    required this.elevationImages,
    required this.masterPlans,
    required this.floorPlans,
    required this.towerPlans,
    required this.clubhouseImages,
    required this.amenitiesImages,
    required this.siteMapImages,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final apartment = json['apartment'];
    final about = json['about'];

    // ✅ galleryImages from cover_images_gallery
    List<String> gallery = [];
    if (apartment != null && apartment['cover_images_gallery'] != null) {
      try {
        final raw = apartment['cover_images_gallery'];
        final decoded = raw is String ? jsonDecode(raw) : raw;
        gallery = List<String>.from((decoded as List).map((e) => "${AppConstants.baseUrl1}/$e"));
      } catch (e) {
        debugPrint("❌ Gallery decode failed: $e");
      }
    }

    // ✅ parseImageList handles both String and List
    List<String> parseImageList(dynamic rawJson) {
      if (rawJson == null) return [];

      try {
        final List decoded = rawJson is String ? jsonDecode(rawJson) : rawJson;
        return decoded.map<String>((e) => "${AppConstants.baseUrl1}/$e").toList();
      } catch (e) {
        debugPrint("❌ parseImageList error: $e");
        return [];
      }
    }

    final nestedGallery = (json['gallery'] as List<dynamic>?)?.isNotEmpty == true
        ? json['gallery'][0] as Map<String, dynamic>
        : null;

    return Property(
      title: json['project']?['title'] ?? '',
      builder: json['project']?['user']?['username'] ?? '',
      coverImage: apartment?['cover_image'] != null
          ? "${AppConstants.baseUrl1}/${apartment?['cover_image']}"
          : '',
      logo: json['project']?['logo'] != null
          ? "${AppConstants.baseUrl1}/${json['project']?['logo']}"
          : '',
      possession: apartment?['possession_by'] ?? '',
      projectSize: apartment?['project_size']?.toString() ?? '',
      noOfUnits: apartment?['no_of_units'] ?? 0,
      configuration: apartment?['configurations'] ?? '',
      sizeAvailable: apartment?['available_sizes'] ?? '',
      basePrice: apartment?['base_price'] ?? '',
      galleryImages: gallery,
      geoLatitude: json['project']?['geo_latitude'] ?? '',
      geoLongitude: json['project']?['geo_longitude'] ?? '',
      geoAddress: json['project']?['geo_address'] ?? '',
      aboutText: about?['about'] ?? '',
      knowAboutBuilder: about?['know_about_builder'] ?? '',
      whyPoints: (json['why'] as List<dynamic>?)
              ?.map((e) => e['description']?.toString() ?? '')
              .toList() ??
          [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => e['offer_text']?.toString() ?? '')
              .toList() ??
          [],
      details: (json['details'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value?.toString() ?? '')) ??
          {},
      gallery: [], // Reserved for future use

      configurations: (json['configurations'] as List<dynamic>?)
              ?.map((e) => {
                    "configuration_type": e['configuration_type']?.toString() ?? "",
                    "size": e['size']?.toString() ?? "",
                    "facing": e['facing']?.toString() ?? "",
                    "price_label": e['price_label']?.toString() ?? "",
                    "image_url": e['image_url'] != null
                        ? "${AppConstants.baseUrl1}/${e['image_url']}"
                        : "null",
                  })
              .toList() ??
          [],
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => {
                    "name": e['name']?.toString() ?? "",
                    "icon_url": e['icon_url'] != null
                        ? "${AppConstants.baseUrl1}/${e['icon_url']}"
                        : "",
                  })
              .toList() ??
          [],
      specifications: json['specifications']?['content'] ?? '',
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => {
                    "rating": e['rating']?.toString() ?? "",
                    "comment": e['comment']?.toString() ?? "",
                    "date": e['reviewed_at']?.toString() ?? "",
                  })
              .toList() ??
          [],
      keyHighlights: (json['key_highlights'] as List<dynamic>?)
              ?.map((e) => {
                    "category": e['category']?.toString() ?? "",
                    "title": e['title']?.toString() ?? "",
                    "distance": e['distance']?.toString() ?? "",
                  })
              .toList() ??
          [],
      hotspots: (json['hotspots'] as List<dynamic>?)
              ?.map((e) => {
                    "category": e['category']?.toString() ?? "",
                    "title": e['title']?.toString() ?? "",
                    "distance": e['distance']?.toString() ?? "",
                    "icon_url": e['icon_url'] != null
                        ? "${AppConstants.baseUrl1}/${e['icon_url']}"
                        : "",
                    "latitude": e['latitude']?.toString() ?? "",
                    "longitude": e['longitude']?.toString() ?? "",
                  })
              .toList() ??
          [],
      loans: (json['loans'] as List<dynamic>?)
              ?.map((e) => {
                    "interest_rate": e['interest_rate_label']?.toString() ?? "",
                    "bank_name": e['bank']?['name']?.toString() ?? "",
                    "bank_logo": e['bank']?['logo_url'] != null
                        ? "${AppConstants.baseUrl1}/${e['bank']?['logo_url']}"
                        : "",
                  })
              .toList() ??
          [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => {
                    "type": e['type']?.toString() ?? "",
                    "title": e['title']?.toString() ?? "",
                    "video_url": e['video_url']?.toString() ?? "",
                  })
              .toList() ??
          [],
      brochureUrl: json['brochure']?['brochure_url'] != null
          ? "${AppConstants.baseUrl1}/${json['brochure']?['brochure_url']}"
          : '',
      elevationImages: parseImageList(nestedGallery?['elevation_images']),
      masterPlans: parseImageList(nestedGallery?['master_plans']),
      floorPlans: parseImageList(nestedGallery?['floor_plans']),
      towerPlans: parseImageList(nestedGallery?['tower_plans']),
      clubhouseImages: parseImageList(nestedGallery?['clubhouse_images']),
      amenitiesImages: parseImageList(nestedGallery?['amenities_images']),
      siteMapImages: parseImageList(nestedGallery?['site_map_images']),
    );
  }
}
