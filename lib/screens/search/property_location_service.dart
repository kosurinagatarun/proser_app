import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proser/screens/components/constant.dart';

import 'package:proser/screens/search/property_location_model.dart'; // adjust path if needed


class LocationPremiumService {
  static Future<List<LocationPremiumModel>> fetchByLocation(String location) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl1}/api/v1/location-premiums"),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        return data
            .map((json) => LocationPremiumModel.fromJson(json))
            .where((model) => model.location.toLowerCase() == location.toLowerCase())
            .toList();
      } else {
        throw Exception('Failed to load location premiums');
      }
    } catch (e) {
      print("LocationPremiumService error: $e");
      rethrow;
    }
  }
}

class LocationPremiumService1 {
  static Future<List<LocationPremiumBanner2>> fetchByLocation(String location) async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl1}/api/v1/location-premium-banner2"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data
          .map((json) => LocationPremiumBanner2.fromJson(json))
          .where((model) => model.location.toLowerCase() == location.toLowerCase())
          .toList();
    } else {
      throw Exception('Failed to load location premium banner 2');
    }
  }
}

class NewLaunchService {
  static const String _endpoint = "/api/v1/new-launches";

  static Future<List<NewLaunchProperty>> fetchByLocation(String location) async {
    final String url = "${AppConstants.baseUrl1}$_endpoint";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List launches = data['data'];

        return launches
            .map((e) => NewLaunchProperty.fromJson(e))
            .where((e) => e.location.toLowerCase().contains(location.toLowerCase()))
            .toList();
      } else {
        throw Exception('Failed to load new launches');
      }
    } catch (e) {
      throw Exception('Error fetching new launches: $e');
    }
  }
}


class EditorChoiceService {
  static const String _endpoint = "/api/v1/editor-choice-location";

  static Future<List<EditorChoiceLocation>> fetchByLocation(String location) async {
    final String url = "${AppConstants.baseUrl1}$_endpoint";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data
            .map((e) => EditorChoiceLocation.fromJson(e))
            .where((e) => e.location.toLowerCase().contains(location.toLowerCase()))
            .toList();
      } else {
        throw Exception('Failed to load editor choice locations');
      }
    } catch (e) {
      throw Exception('Error fetching editor choice locations: $e');
    }
  }
}

class UltraLuxuryHomeService {
  static const String _endpoint = "/api/v1/ultra-luxury-homes-locality";

  static Future<List<UltraLuxuryHome>> fetchByLocation(String location) async {
    final String url = "${AppConstants.baseUrl1}$_endpoint";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List allHomes = data['data'];
        return allHomes
            .map((e) => UltraLuxuryHome.fromJson(e))
            .where((home) =>
                home.location.toLowerCase() == location.toLowerCase())
            .toList();
      } else {
        throw Exception('Failed to load ultra luxury homes');
      }
    } catch (e) {
      throw Exception('Error fetching ultra luxury homes: $e');
    }
  }
}



class AgentPropertyService {
  static Future<List<AgentPostedProperty>> fetchAgentPostedProperties() async {
    final url = Uri.parse('${AppConstants.baseUrl1}/api/v1/agent-posted-properties');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => AgentPostedProperty.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load agent posted properties');
    }
  }
}
