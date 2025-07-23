import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  static const String _apiUrl =
      "https://iproser.digitali360.tech/api/v1/projects/apartment-buy";

  static Future<Map<String, dynamic>> loadAll() async {
    final response = await http.get(Uri.parse(_apiUrl));

    final List<String> locations = [];
    final List<String> pincodes = [];
    final List<Map<String, String>> projects = [];

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data['data']) {
        final project = item['project'];
        final apartment = item['apartment'];

        if (project == null) continue;

        // Collect locations from geo_address
        final geo = project['geo_address'];
        if (geo != null) {
          final split = geo
              .toString()
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.length > 3)
              .toList();

          for (final part in split) {
            if (RegExp(r'^\d{6}$').hasMatch(part)) {
              pincodes.add(part);
            } else if (!['india', 'telangana', 'hyderabad']
                .contains(part.toLowerCase())) {
              locations.add(part);
            }
          }
        }

        // Add enriched project data
        projects.add({
          'title': project['title'] ?? '',
          'slug': project['slug'] ?? '',
          'byLabel': "By ${project['user']?['username'] ?? 'Developer'}",
          'validatedImageUrl':
              "${apartment?['cover_image'] ?? ''}".isNotEmpty
                  ? "https://iproser.digitali360.tech/${apartment['cover_image']}"
                  : '',
          'validatedLogoUrl':
              "${project['logo'] ?? ''}".isNotEmpty
                  ? "https://iproser.digitali360.tech/${project['logo']}"
                  : '',
        });
      }

      return {
        'locations': locations.toSet().toList(),
        'pincodes': pincodes.toSet().toList(),
        'projects': projects,
      };
    }

    return {
      'locations': [],
      'pincodes': [],
      'projects': [],
    };
  }

  static List<String> fuzzyMatch(String query, List<String> options) {
    query = query.toLowerCase();
    return options
        .where((option) =>
            option.toLowerCase().startsWith(query) ||
            option.toLowerCase().contains(query))
        .toList();
  }
}

