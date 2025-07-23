/*
 * LocationMapScreen
 * -----------------
 * • Shows a green “Property” pin for the main project location
 * • Shows custom hotspot pins using each hotspot’s icon_url
 * • Icons are resized to ~80 px to behave like the default red pin
 * • Icons are cached in‑memory so they download only once per URL
 * • Users can filter hotspots by category via chips
 */

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;                          // ⬅️ for image resizing

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;         // ⬅️ network download
import 'package:proser/utils/color.dart';        // primaryGreen + any brand colours

class LocationMapScreen extends StatefulWidget {
  final List<Map<String, String>> hotspots;      // parsed JSON
  final double propertyLat;                      // project latitude
  final double propertyLng;                      // project longitude
  final String geoAddress; // 👈 Add this line
  final String title;

  const LocationMapScreen({
    super.key,
    required this.hotspots,
    required this.propertyLat,
    required this.propertyLng,
    required this.geoAddress, // 👈 Add this line
    required this.title,
  });

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  String selectedCategory = 'All';

  // In‑memory cache of downloaded+resized icons
  final Map<String, BitmapDescriptor> _iconCache = {};

  /* ─────────────────────────── Helpers ── */

  /// Returns text before first comma (e.g. "Jubilee Hills, Hyderabad" → "Jubilee Hills")
  String _shortTitle(String? title) => title?.split(',').first.trim() ?? '--';

  /// Download an image from [url] and resize to targetWidth px, then convert to a BitmapDescriptor.
  Future<BitmapDescriptor> _getIconFromUrl(String url, {int size = 150}) async {
  if (_iconCache.containsKey(url)) return _iconCache[url]!;

  try {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List iconBytes = response.bodyBytes;

      // Decode original icon
      final ui.Codec iconCodec =
          await ui.instantiateImageCodec(iconBytes, targetWidth: size ~/ 2);
      final ui.FrameInfo iconFrame = await iconCodec.getNextFrame();
      final ui.Image iconImage = iconFrame.image;

      // Create new canvas
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint bgPaint = Paint()..color = Colors.white;

      // Shadow (glow)
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      final Offset center = Offset(size / 2, size / 2);
      final double radius = size / 2.2;

      // Draw shadow behind white circle
      canvas.drawCircle(center.translate(0, 2), radius, shadowPaint);

      // Draw white circle
      canvas.drawCircle(center, radius, bgPaint);

      // Draw icon on top, centered
      final double xOffset = (size - iconImage.width.toDouble()) / 2;
      final double yOffset = (size - iconImage.height.toDouble()) / 2;
      canvas.drawImage(iconImage, Offset(xOffset, yOffset), Paint());

      // Finalize to image
      final ui.Image finalImage =
          await recorder.endRecording().toImage(size, size);
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      final Uint8List finalBytes = byteData!.buffer.asUint8List();
      final descriptor = BitmapDescriptor.fromBytes(finalBytes);

      _iconCache[url] = descriptor;
      return descriptor;
    }
  } catch (e) {
    debugPrint('❌ Icon render error: $e');
  }

  // fallback
  return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
}


  /// Generates the complete marker set (hotspots + property), respecting the category filter.
  Future<Set<Marker>> _generateMarkers() async {
    final List<Map<String, String>> filtered = selectedCategory == 'All'
        ? widget.hotspots
        : widget.hotspots
            .where((e) => e['category'] == selectedCategory)
            .toList();

    final Set<Marker> markers = {};

    // ❶ hotspots
    for (final e in filtered) {
      final double lat = double.tryParse(e['latitude'] ?? '') ?? 0.0;
      final double lng = double.tryParse(e['longitude'] ?? '') ?? 0.0;

      final String iconUrl = e['icon_url'] ?? '';
      final BitmapDescriptor icon = iconUrl.isNotEmpty
          ? await _getIconFromUrl(iconUrl)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

      markers.add(
        Marker(
          markerId: MarkerId(_shortTitle(e['title'])),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: _shortTitle(e['title']),
            snippet: e['distance'] ?? '',
          ),
          icon: icon,
          anchor: const Offset(0.5, 1), // align pin tip
        ),
      );
    }

    // ❷ main Property pin
    markers.add(
  Marker(
    markerId: const MarkerId('propertyPin'),
    position: LatLng(widget.propertyLat, widget.propertyLng),
    infoWindow: InfoWindow(
      title: widget.title.isNotEmpty ? widget.title : "Property",
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    anchor: const Offset(0.5, 1),
  ),
);


    return markers;
  }

  /* ─────────────────────────── UI ── */

  @override
  Widget build(BuildContext context) {
    // Build list of category chips
    final List<String> categories = [
      'All',
      ...{...widget.hotspots.map((e) => e['category'] ?? '--').toSet()}
    ];

    final LatLng propertyLoc = LatLng(widget.propertyLat, widget.propertyLng);

    return Scaffold(
      body: FutureBuilder<Set<Marker>>(
        future: _generateMarkers(),
        builder: (context, snapshot) {
          final Set<Marker> markers = snapshot.data ?? const {};

          return Stack(
            children: [
              /* Google Map */
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: propertyLoc, zoom: 13),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (c) => _mapController.complete(c),
              ),

              /* Back button */
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              /* Draggable info sheet */
              DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.5,
                builder: (_, scrollController) {
                  final List<Map<String, String>> visibleHotspots =
                      selectedCategory == 'All'
                          ? widget.hotspots
                          : widget.hotspots
                              .where((e) => e['category'] == selectedCategory)
                              .toList();

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      children: [
                        /* drag handle */
                        Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        /* category chips */
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: categories.map((cat) {
                              final bool isSelected = selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (_) =>
                                      setState(() => selectedCategory = cat),
                                  selectedColor: primaryGreen,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 6),

                        /* hotspot list */
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: visibleHotspots.length,
                            itemBuilder: (_, i) {
                              final item = visibleHotspots[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.place,
                                        size: 18, color: Colors.black87),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _shortTitle(item['title']),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            item['distance'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
