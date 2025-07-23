import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proser/screens/Profile/contacted_properties.dart';
import 'package:proser/screens/Profile/savedProperty_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_screen.dart'; // Import Notification Screen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Load Profile Image from SharedPreferences
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImage =
          prefs.getString('profile_image') ?? 'assets/images/profile.png';
    });
  }

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);

      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Back Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Profile Avatar with Edit Button
                Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? (_profileImage!.startsWith('assets/')
                                      ? AssetImage(_profileImage!)
                                      : FileImage(File(_profileImage!)))
                                  as ImageProvider
                              : AssetImage('assets/images/profile.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kollapudi Nihith",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "+91 703230****",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

                // Menu Items
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(Icons.info_outline, "About Company",
                          "Get to know about our company", context, null),
                      _buildMenuItem(
                          Icons.notifications_none,
                          "Notifications",
                          "Notifications",
                          context,
                          NotificationScreen()), // Navigate to Notification Screen
                      _buildMenuItem(
                          Icons.contact_page_outlined,
                          "Contacted Properties",
                          "Review your previous properties",
                          context,
                          ContactedPropertiesScreen()), // Navigate to Contacted Properties Screen

                      _buildMenuItem(
                          Icons.bookmark_border,
                          "Saved Properties",
                          "Review your previous properties",
                          context,
                          SavedPropertiesScreen()),
                      _buildMenuItem(
                          Icons.upload_file_outlined,
                          "Post Property",
                          "Review your previous properties",
                          context,
                          null),
                      _buildMenuItem(
                          Icons.question_answer_outlined,
                          "FAQ's",
                          "Ask any questions related to our company",
                          context,
                          null),
                      _buildMenuItem(
                          Icons.report_gmailerrorred_outlined,
                          "Report an issue",
                          "Raise an issue encountered by you and get solution",
                          context,
                          null),
                      _buildMenuItem(Icons.phone_in_talk_outlined, "Contact Us",
                          "Get in touch with our company", context, null),
                      _buildMenuItem(Icons.person_outline, "My Account",
                          "My account details", context, null),
                      _buildMenuItem(Icons.logout, "Logout",
                          "Logout from the app", context, null),
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

  // Function to create menu items with Navigation
  Widget _buildMenuItem(IconData icon, String title, String subtitle,
      BuildContext context, Widget? screen) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
    );
  }
}
