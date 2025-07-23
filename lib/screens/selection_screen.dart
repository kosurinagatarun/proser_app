import 'package:flutter/material.dart';
import 'package:proser/screens/property_type_screen.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Default back with animation
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Name
              Text(
                'Proser',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 59),

              // BUY Card
              _buildOptionCard(
                context,
                imagePath: 'assets/images/buy.png',
                title: 'BUY',
                subtitle: 'Luxurious Villas and upscale properties',
                isBuy: true,
              ),
              SizedBox(height: 10),

              // RENT Card
              _buildOptionCard(
                context,
                imagePath: 'assets/images/rent.png',
                title: 'RENT',
                subtitle: 'Luxury Living in stunning apartments',
                isBuy: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Widget
  Widget _buildOptionCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String subtitle,
    required bool isBuy,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) =>
                PropertyTypeScreen(isBuySelected: isBuy),
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
          ),
        );
      },
      child: Container(
        height: 208,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: Stack(
          children: [
            // Arrow icon
            Positioned(
              top: 15,
              right: 15,
              child: Icon(
                Icons.arrow_outward_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            // Text
            Positioned(
              left: 15,
              bottom: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
