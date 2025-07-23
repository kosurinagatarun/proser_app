import 'package:flutter/material.dart';
import 'package:proser/screens/register_screen.dart';
import 'package:proser/utils/color.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseFontSize = screenWidth * 0.035;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          // Overlay to dim background slightly
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),

                // App Name
                Text(
                  'Proser',
                  style: TextStyle(
                    fontSize: baseFontSize * 5, // ~70
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: screenHeight * 0.2), // ~180

                // Main Title
                Text(
                  'Discover your\nDream property',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: baseFontSize * 3.3, // ~46
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: screenHeight * 0.09), // ~85

                // Subtitle
                Text(
                  "Agree and click on Let’s start to create your account to explore various options",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: baseFontSize, // ~16
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05), // ~40

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => RegisterScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.22, // ~100
                      vertical: screenHeight * 0.02, // ~20
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: baseFontSize * 1.5, // ~22
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.025), // ~20

                // Terms and Conditions
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Your safety matters to us. ",
                    style: TextStyle(
                      fontSize: baseFontSize * 0.9, // ~14
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: "Terms and conditions applied",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                            "\nThat’s why we require you to add authentic details",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
