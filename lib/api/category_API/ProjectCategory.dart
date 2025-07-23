import 'package:proser/screens/components/constant.dart';

class ProjectCategory {
  final int id;
  final String name;
  final String image;

  ProjectCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    return ProjectCategory(
      id: json['id'],
      name: json['name'],
      image: "${AppConstants.baseUrl1}/${json['image']}",
    );
  }
}
