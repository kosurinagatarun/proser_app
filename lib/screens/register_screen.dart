import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proser/screens/selection_screen.dart';
import 'package:proser/utils/color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseFontSize = screenWidth * 0.035;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // Default back with animation
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Stack for Background & Skip Button
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.22,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/images/top_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.015,
                    right: screenWidth * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder: (_, __, ___) => SelectionScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              final tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenHeight * 0.01,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: baseFontSize,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.015,
                    left: screenWidth * 0.05,
                    child: Text(
                      'Proser',
                      style: TextStyle(
                        fontSize: baseFontSize * 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Main Content Box
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: baseFontSize * 1.7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Agree and click on Let's start to create your account to explore various options",
                          style: TextStyle(
                            fontSize: baseFontSize,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        _buildInputField(Icons.person, 'Full name', baseFontSize),
                        _buildInputField(Icons.email, 'Valid email', baseFontSize),
                        _buildInputField(Icons.phone, 'Phone number', baseFontSize),
                        _buildInputField(Icons.lock, 'Strong Password',
                            baseFontSize, obscureText: true),

                        SizedBox(height: screenHeight * 0.02),

                        ElevatedButton(
                          onPressed: () {
                            // Handle Sign Up
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: baseFontSize * 1.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 1, color: Colors.grey[400])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR",
                                  style: TextStyle(fontSize: baseFontSize)),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1, color: Colors.grey[400])),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIcon(FontAwesomeIcons.whatsapp, Colors.green,
                                baseFontSize),
                            SizedBox(width: screenWidth * 0.05),
                            _socialIcon(FontAwesomeIcons.google, Colors.red,
                                baseFontSize),
                            SizedBox(width: screenWidth * 0.05),
                            _socialIcon(FontAwesomeIcons.linkedin, Colors.blue,
                                baseFontSize),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ",
                                style: TextStyle(fontSize: baseFontSize)),
                            GestureDetector(
                              onTap: () {
                                // Navigate to Login Screen
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: baseFontSize,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input Field
  Widget _buildInputField(IconData icon, String hintText, double fontSize,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: fontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  // Social Icon
  Widget _socialIcon(IconData icon, Color color, double fontSize) {
    return CircleAvatar(
      radius: fontSize * 1.4,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color, size: fontSize * 1.5),
    );
  }
}
