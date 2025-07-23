import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proser/api/category_API/ProjectCategory.dart';
import 'package:proser/screens/components/constant.dart';

class ProjectCategoryService {
  static Future<List<ProjectCategory>> fetchCategories() async {
    const url = "${AppConstants.baseUrl1}/api/v1/project-categories";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          List<dynamic> list = decoded['data'];
          List<ProjectCategory> categories = list.map((e) => ProjectCategory.fromJson(e)).toList();
          categories.sort((a, b) => a.id.compareTo(b.id)); // ✅ Ascending
          return categories;
        }
      }
    } catch (e) {
      print("Error fetching project categories: $e");
    }

    return [];
  }

  static Future<Map<int, ProjectCategory>> fetchCategoriesById() async {
    const url = "${AppConstants.baseUrl1}/api/v1/project-categories";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          List<dynamic> list = decoded['data'];
          List<ProjectCategory> sorted = list.map((e) => ProjectCategory.fromJson(e)).toList();
          sorted.sort((a, b) => a.id.compareTo(b.id)); // ✅ Ascending
          return {
            for (var cat in sorted) cat.id: cat,
          };
        }
      }
    } catch (e) {
      print("Error fetching categories by ID: $e");
    }

    return {};
  }
}
