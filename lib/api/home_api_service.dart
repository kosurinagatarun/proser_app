import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proser/api/homescreen_model.dart';
import 'package:proser/screens/components/constant.dart';

Future<List<BestDeal>> fetchBestDeals() async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/best-deals'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final List<dynamic> data = body['data'];

    return data.map((item) {
      // Use raw image or fallback directly
      String rawImageUrl = item['image_url'] ?? '';
      item['validated_image_url'] = rawImageUrl.isNotEmpty
          ? "${AppConstants.baseUrl}${rawImageUrl}"
          : ""; // empty = will fallback in UI
      return BestDeal.fromJson(item);
    }).toList();
  } else {
    throw Exception('Failed to load best deals');
  }
}



Future<List<EditorsChoice>> fetchEditorsChoice() async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/editors-choices'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final List<dynamic> data = body['data'];

    List<EditorsChoice> validatedList = [];

    for (var item in data) {
      // reuse the same logic if you want to validate HEAD, or just directly:
      validatedList.add(EditorsChoice.fromJson(item));
    }

    return validatedList;
  } else {
    throw Exception('Failed to load editors choice');
  }
}


Future<List<ProminentBuilder>> fetchProminentBuilders() async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/prominent-builders'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    if (body['data'] == null || body['data'] is! List) {
      throw Exception("Invalid prominent builders response");
    }

    final List<dynamic> data = body['data'];
    return data.map((e) => ProminentBuilder.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load prominent builders: ${response.statusCode}');
  }
}

Future<List<SelectedProperty>> fetchSelectedProperties() async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/selected-properties'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    if (body['data'] == null || body['data'] is! List) {
      throw Exception("Invalid selected-properties response");
    }

    final List<dynamic> data = body['data'];
    return data.map((e) => SelectedProperty.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load selected properties: ${response.statusCode}');
  }
}

Future<List<LifestyleProperty>> fetchLifestyleProperties() async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/lifestyle-properties'));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);

    if (body['data'] == null || body['data'] is! List) {
      throw Exception("Invalid lifestyle-properties response");
    }

    final List<dynamic> data = body['data'];
    return data.map((e) => LifestyleProperty.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load lifestyle properties: ${response.statusCode}');
  }
}

Future<List<NewLaunchProperty>> fetchNewLaunches() async {
  const String url = "https://iproser.digitali360.tech/api/v1/new-launches";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true && data['data'] != null) {
        List<dynamic> items = data['data'];
        return items.map((item) => NewLaunchProperty.fromJson(item)).toList();
      } else {
        throw Exception("No data found");
      }
    } else {
      throw Exception("Failed to load new launches");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}

Future<List<ReadyToMoveProperty>> fetchReadyToMoveProperties() async {
  const String url = "${AppConstants.baseUrl1}/api/v1/ready-to-move-properties";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] == true && jsonData['data'] is List) {
      return (jsonData['data'] as List)
          .map((e) => ReadyToMoveProperty.fromJson(e))
          .toList();
    } else {
      throw Exception("Invalid data structure received from server.");
    }
  } else {
    throw Exception("Failed to load Ready to Move properties.");
  }
}


Future<List<LimelightProperty>> fetchLimelightProperties() async {
  const String url = "${AppConstants.baseUrl1}/api/v1/limelight-properties";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] == true && jsonData['data'] is List) {
      return (jsonData['data'] as List)
          .map((e) => LimelightProperty.fromJson(e))
          .toList();
    } else {
      throw Exception("Invalid data structure received from server.");
    }
  } else {
    throw Exception("Failed to load Limelight properties.");
  }
}

Future<List<SponsoredProperty>> fetchSponsoredProperties() async {
  const String url = "${AppConstants.baseUrl1}/api/v1/sponsored-properties";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] == true && jsonData['data'] is List) {
      return (jsonData['data'] as List)
          .map((e) => SponsoredProperty.fromJson(e))
          .toList();
    } else {
      throw Exception("Invalid data structure received from server.");
    }
  } else {
    throw Exception("Failed to load Sponsored properties.");
  }
}

Future<List<HotLocality>> fetchHotLocalities() async {
  const String url = "${AppConstants.baseUrl1}/api/v1/hot-localities";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] == true && jsonData['data'] is List) {
      return (jsonData['data'] as List)
          .map((e) => HotLocality.fromJson(e))
          .toList();
    } else {
      throw Exception("Invalid data structure received from server.");
    }
  } else {
    throw Exception("Failed to load Hot Localities.");
  }
}