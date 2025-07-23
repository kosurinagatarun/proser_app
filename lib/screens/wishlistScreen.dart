import 'package:flutter/material.dart';
import 'package:proser/api/homescreen_model.dart';
import 'package:proser/screens/home/home_screen.dart';
import 'wishlist_manager.dart'; // ✅ import the SharedPreferences helper


class WishlistScreen extends StatefulWidget {
  final List<ProminentBuilder> allProperties;

  const WishlistScreen({Key? key, required this.allProperties}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<ProminentBuilder> wishlisted;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() {
    setState(() {
      wishlisted = widget.allProperties
          .where((p) => WishlistManager.isWishlisted(p.projectSlug))
          .toList();
    });
  }

  void _handleToggle(String slug) async {
    await WishlistManager.toggle(slug);
    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.green.shade700,
      ),
      body: wishlisted.isEmpty
          ? const Center(child: Text("No properties in wishlist"))
          : ListView.builder(
              itemCount: wishlisted.length,
              itemBuilder: (context, index) {
                final property = wishlisted[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: buildPropertyCardDynamic(
                    context,
                    property,
                    onWishlistToggle: () => _handleToggle(property.projectSlug),
                  ),
                );
              },
            ),
    );
  }
}
