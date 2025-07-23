import 'package:flutter/material.dart';
import 'package:proser/utils/color.dart';

class FetchLocationBottomSheet extends StatelessWidget {
  final Function(String) onLocationSelected;

  const FetchLocationBottomSheet({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locations = [
      'SS Plaza, Greenland Colony, Madhava Reddy Colony, Gachibowli, Hyderabad, Telangana 500032',
      'SS Plaza, Greenland Colony, Madhava Reddy Colony, Gachibowli, Hyderabad, Telangana 500032',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
              Chip(label: Text('Edit'), backgroundColor: primaryGreen, labelStyle: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          ...locations.asMap().entries.map((entry) {
            final selected = entry.key == 0; // Highlight the first one
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFD6DFFF) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 14))),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onLocationSelected(locations[0]); // Return selected location
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
  'Choose Location',
  style: TextStyle(
    fontSize: 16,
    color: Colors.white,
  ),
),

          ),
        ],
      ),
    );
  }
}
