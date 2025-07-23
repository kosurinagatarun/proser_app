import 'package:flutter/material.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/search/property_location_model.dart';
import 'package:proser/screens/search/property_location_service.dart';

import 'package:proser/utils/color.dart';

class AgentPropertiesViewAllPage extends StatelessWidget {
  const AgentPropertiesViewAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.035;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listed Properties'),
        backgroundColor: const Color.fromARGB(255, 236, 235, 235),
      ),
      body: FutureBuilder<List<AgentPostedProperty>>(
        future: AgentPropertyService.fetchAgentPostedProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading agent properties."));
          }

          final properties = snapshot.data ?? [];

          if (properties.isEmpty) {
            return const Center(child: Text("No properties found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final prop = properties[index];
              final cardWidth = screenWidth * 0.92;
              final imageHeight = cardWidth * 0.52;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyScreen(
                        slug: prop.slug,
                        propertyTitle: prop.title,
                        builderName: prop.companyName,
                        imageUrl: prop.imageUrl,
                        builderLogo: prop.companyLogo,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.network(
                              prop.imageUrl,
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                height: imageHeight,
                                child: const Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.9),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prop.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: baseFontSize * 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "By ${prop.companyName}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: baseFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 20,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                                  const SizedBox(width: 4),
                                  Text(
                                    prop.location,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: baseFontSize * 0.9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.favorite_border, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(prop.logo),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                                  const SizedBox(width: 5),
                                  Text(
                                    prop.bhk,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: baseFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("|"),
                                  const SizedBox(width: 10),
                                  Text(
                                    prop.possession,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: baseFontSize,
                                      color: primaryGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                prop.priceRange,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: baseFontSize,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.3),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: baseFontSize * 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.phone, color: Colors.white, size: baseFontSize * 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
