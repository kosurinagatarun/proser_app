// wishlist_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class WishlistManager {
  static const String _key = 'wishlist_slugs';
  static Set<String> _wishlistSlugs = {};

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _wishlistSlugs = prefs.getStringList(_key)?.toSet() ?? {};
  }

  static bool isWishlisted(String slug) => _wishlistSlugs.contains(slug);

  static Future<void> toggle(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    if (_wishlistSlugs.contains(slug)) {
      _wishlistSlugs.remove(slug);
    } else {
      _wishlistSlugs.add(slug);
    }
    await prefs.setStringList(_key, _wishlistSlugs.toList());
  }

  static List<String> get all => _wishlistSlugs.toList();
}
