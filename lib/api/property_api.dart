import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proser/screens/components/constant.dart';
import 'dart:convert';
import 'property_model.dart';

Future<Property> fetchPropertyBySlug(String slug) async {
  final url = "${AppConstants.baseUrl}/projects/apartment-buy/$slug";

  debugPrint("HITTING API: $url");

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final data = body['data']; // <-- get only data
    debugPrint("DATA JSON: ${jsonEncode(data)}"); // optional
    return Property.fromJson(data);
  } else {
    throw Exception("Failed to load property");
  }
}
