import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/components/constant.dart';
import 'package:proser/utils/color.dart';

class MapPropertyScreen extends StatefulWidget {
  final String location;

  const MapPropertyScreen({Key? key, required this.location}) : super(key: key);

  @override
  State<MapPropertyScreen> createState() => _MapPropertyScreenState();
}

class _MapPropertyScreenState extends State<MapPropertyScreen> {
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> _filteredProperties = [];
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  LatLng _initialPosition = const LatLng(17.4506, 78.3823);

  final String baseUrl = 'https://iproser.digitali360.tech/';

String getFullImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  final base = AppConstants.baseUrl1.endsWith('/') ? AppConstants.baseUrl1 : '${AppConstants.baseUrl1}/';
  return path.startsWith('http') ? path : '$base${path.startsWith('/') ? path.substring(1) : path}';
}



  @override
  void initState() {
    super.initState();
    fetchAllProperties();
  }

  Future<void> fetchAllProperties() async {
    final List<String> urls = [
      '${baseUrl}api/v1/location-premiums',
      '${baseUrl}api/v1/new-launches',
      '${baseUrl}api/v1/agent-posted-properties',
      '${baseUrl}api/v1/location-premium-banner2',
      '${baseUrl}api/v1/editor-choice-location',
      '${baseUrl}api/v1/ultra-luxury-homes-locality',
    ];

    final Set<String> seenSlugs = {};
    final List<Map<String, dynamic>> allProps = [];

    for (final url in urls) {
      try {
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final List list = data['data'];

          for (var item in list) {
            if ((item['location'] ?? '').toLowerCase() == widget.location.toLowerCase()) {
              final slug = item['slug'] ?? item['title'];
              if (!seenSlugs.contains(slug)) {
                seenSlugs.add(slug);
                final lat = double.tryParse(item['geo_latitude'] ?? '0');
                final lng = double.tryParse(item['geo_longitude'] ?? '0');
                if (lat != null && lng != null && lat != 0 && lng != 0) {
                  final property = {
                    'title': item['title'],
                    'builder': item['by_label'] ?? item['company_name'] ?? '',
                    'location': item['location'],
                    'slug': slug,
                    'image': getFullImageUrl(item['image_url']),
                    'logo': getFullImageUrl(item['logo'] ?? item['company_logo']),
                    'lat': lat,
                    'lng': lng,
                  };

                  allProps.add(property);
                  _markers.add(_buildMarker(property));
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Failed to fetch from $url: $e');
      }
    }

    if (allProps.isNotEmpty) {
      final first = allProps[0];
      _initialPosition = LatLng(first['lat'], first['lng']);
    }

    setState(() {
      _filteredProperties.clear();
      _filteredProperties.addAll(allProps);
    });
  }

  Marker _buildMarker(Map<String, dynamic> property) {
    return Marker(
      markerId: MarkerId(property['slug']),
      position: LatLng(property['lat'], property['lng']),
      infoWindow: InfoWindow(
        title: property['title'],
        snippet: property['location'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyScreen(
                slug: property['slug'],
                propertyTitle: property['title'],
                builderName: property['builder'],
                imageUrl: property['image'],
                builderLogo: property['logo'],
                
              ),
            ),
          );
        },
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  void _onCardChanged(int index) {
    final property = _filteredProperties[index];
    final latLng = LatLng(property['lat'], property['lng']);
    _googleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 210;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 13),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Top location bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_pin, color: primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.location,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Property Cards
          if (_filteredProperties.isNotEmpty)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: SizedBox(
                height: cardHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _filteredProperties.length,
                  onPageChanged: _onCardChanged,
                  itemBuilder: (context, index) {
                    final property = _filteredProperties[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                              child: Image.network(
                                property['image'],
                                width: MediaQuery.of(context).size.width * 0.42,
                                height: cardHeight,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(property['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(property['builder'], style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 14, color: primaryGreen),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text(property['location'], style: const TextStyle(fontSize: 13))),
                                      ],
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PropertyScreen(
                                              slug: property['slug'],
                                              propertyTitle: property['title'],
                                              builderName: property['builder'],
                                              imageUrl: property['image'],
                                              builderLogo: property['logo'],
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: primaryGreen,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('View Details'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Bottom Capsule Bar
          Positioned(
            bottom: 25,
            left: MediaQuery.of(context).size.width * 0.28,
            right: MediaQuery.of(context).size.width * 0.28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: const [
                        Icon(Icons.list_alt_rounded, size: 18, color: primaryGreen),
                        SizedBox(width: 4),
                        Text("List", style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.favorite_border, size: 18, color: primaryGreen),
                      SizedBox(width: 4),
                      Text("Wishlist", style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
