import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:proser/screens/components/constant.dart';
import 'package:proser/screens/hot_locality_model.dart';

class LocalityService {
  static Future<HotLocalityDetail> fetchHotLocalityDetail(String slug) async {
    final url = Uri.parse("${AppConstants.baseUrl1}/api/v1/hot-localities/$slug");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return HotLocalityDetail.fromJson(jsonData['data']);
      } else {
        throw Exception("Invalid response structure");
      }
    } else {
      throw Exception("Failed to load hot locality detail");
    }
  }
}
