import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String address;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('projectPin'),
                position: location,
                infoWindow: InfoWindow(title: address),
              ),
            },
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                address,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
