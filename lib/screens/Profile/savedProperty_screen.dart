import 'package:flutter/material.dart';

class SavedPropertiesScreen extends StatelessWidget {
  final List<Map<String, String>> apartments = [
    {
      "title": "Aparna Newlands",
      "image": "assets/images/property1.jpg",
      "builder": "Aparna Constructions",
      "readyBy": "Ready by Sep 2024"
    },
    {
      "title": "Prestige Towers",
      "image": "assets/images/property2.jpg",
      "builder": "Prestige Group",
      "readyBy": "Possession in 2025"
    },
    {
      "title": "Skyline Heights",
      "image": "assets/images/property3.jpg",
      "builder": "Skyline Builders",
      "readyBy": "Coming Soon"
    }
  ];

  final List<Map<String, String>> villas = [
    {
      "title": "Vessella Woods Overview",
      "image": "assets/images/villas.jpg",
      "builder": "Vessella Group",
      "readyBy": "Ready by Sep 2024"
    },
    {
      "title": "Luxury Villa Green",
      "image": "assets/images/villas.jpg",
      "builder": "Elite Villas",
      "readyBy": "Possession in 2025"
    },
    {
      "title": "Sunshine Estates",
      "image": "assets/images/villas.jpg",
      "builder": "Sunshine Developers",
      "readyBy": "Coming Soon"
    }
  ];

  final List<Map<String, String>> plots = [
    {
      "title": "Aparna Newlands",
      "image": "assets/images/plots.jpg",
      "builder": "Aparna Constructions",
      "readyBy": "Farm lands venture"
    },
    {
      "title": "Greenview Plots",
      "image": "assets/images/plots.jpg",
      "builder": "Greenview Developers",
      "readyBy": "Near Airport"
    },
    {
      "title": "Sunrise Plots",
      "image": "assets/images/plots.jpg",
      "builder": "Sunrise Estates",
      "readyBy": "Possession in 2026"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button & Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        "Saved Properties",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Apartments Section
                _buildCategorySection("Apartments", apartments),
                _buildCategorySection("Villas", villas),
                _buildCategorySection("Plots", plots),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to build category sections
  Widget _buildCategorySection(
      String title, List<Map<String, String>> properties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 180, // Set height for horizontal scrolling
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return _buildPropertyCard(properties[index]);
            },
          ),
        ),
      ],
    );
  }

  // Function to build property card
  Widget _buildPropertyCard(Map<String, String> property) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              property["image"]!,
              width: 280,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.favorite_border, color: Colors.red, size: 18),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property["title"]!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "By ${property["builder"]}",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  SizedBox(height: 2),
                  Text(
                    property["readyBy"]!,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
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
