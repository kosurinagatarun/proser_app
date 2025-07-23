import 'package:flutter/material.dart';
import 'package:proser/screens/navigation_screen.dart';
import 'package:proser/utils/color.dart';

class PropertyTypeScreen extends StatelessWidget {
  final bool isBuySelected;

  const PropertyTypeScreen({super.key, required this.isBuySelected});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseFontSize = screenWidth * 0.035;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Triggers slide-right animation
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back & Title
              Stack(
                children: [
                  Center(
                    child: Text(
                      'Proser',
                      style: TextStyle(
                        fontSize: baseFontSize * 2.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: baseFontSize * 1.5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              Center(
                child: Text(
                  'Select Property Type',
                  style: TextStyle(
                    fontSize: baseFontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                    shadows: [
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Cards
              if (isBuySelected) ...[
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/apartments.jpg',
                  title: 'Apartments',
                  subtitle: 'Luxury Living in stunning apartments',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.22,
                ),
                SizedBox(height: screenHeight * 0.04),
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/villas.jpg',
                  title: 'Villas',
                  subtitle: 'Luxurious Villas and upscale properties',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.22,
                ),
                SizedBox(height: screenHeight * 0.04),
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/plots.jpg',
                  title: 'Plots',
                  subtitle: 'List your property with ease.',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.22,
                ),
                
                
              ] else ...[
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/studio_apartment.jpg',
                  title: 'Studio Apartments',
                  subtitle: 'Compact, modern living spaces.',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.26,
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/duplex.jpg',
                  title: 'Duplex Houses',
                  subtitle: 'Spacious and luxurious rental homes.',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.26,
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildOptionCard(
                  context,
                  imagePath: 'assets/images/shared_housing.jpg',
                  title: 'Shared Housing',
                  subtitle: 'Affordable co-living spaces.',
                  baseFontSize: baseFontSize,
                  cardHeight: screenHeight * 0.26,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(
      BuildContext context, int selectedIndex, String pageType) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NavigationScreen(
          selectedIndex: selectedIndex,
          initialPageType: pageType,
        ),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
  }

  Widget _buildOptionCard(
  BuildContext context, {
  required String imagePath,
  required String title,
  required String subtitle,
  required double baseFontSize,
  required double cardHeight,
}) {
  return GestureDetector(
    onTap: () {
      final titleLower = title.toLowerCase();
      if (titleLower == 'villas') {
        _navigateToHome(context, 0, 'villas');
      } else if (titleLower == 'plots') {
        _navigateToHome(context, 0, 'plots');
      } else {
        _navigateToHome(context, 0, 'apartments');
      }
    },
    child: Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay from bottom to top
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top-right Arrow
          Positioned(
            top: 15,
            right: 15,
            child: Icon(
              Icons.arrow_outward_rounded,
              size: baseFontSize * 1.8,
              color: Colors.white,
            ),
          ),

          // Bottom-left Text
          Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: EdgeInsets.only(bottom: baseFontSize * 1),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: baseFontSize * 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        SizedBox(height: baseFontSize * 0.3),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: baseFontSize * 1.1,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

        ],
      ),
    ),
  );
}
}