import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proser/screens/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImage =
          prefs.getString('profile_image') ?? 'assets/images/profile.png';
    });
  }

  final specs = [
    "Project Name",
    "Builder Name",
    "Project Type",
    "Location",
    "Approvals",
    "Project Size",
    "Unit sizes",
    "No of units",
    "No of Floors",
    "No of Towers",
    "Open space",
    "Configurations",
    "Flats Sizes",
    "Possession",
    "Club House",
    "Base Price",
    "Price",
    "Construction",
  ];

  final compareItems = [
    {
      "Project Name": "Aparna Newlands",
      "Builder Name": "Aparna Constructions",
      "Project Type": "Fully-gated",
      "Location": "Tellapur",
      "Approvals": "RERA",
      "Project Size": "14 acres",
      "Unit sizes": "1200-2100 sq.ft",
      "No of units": "512",
      "No of Floors": "42 Floors",
      "No of Towers": "8 Towers",
      "Open space": "90%",
      "Configurations": "2, 3, 4 BHK",
      "Flats Sizes": "850 sq.ft - 2100 sq.ft",
      "Possession": "2024-09-02",
      "Club House": "45000 sq.ft",
      "Base Price": "₹8999/sq.ft",
      "Price": "₹1.44 Cr - ₹1.94 Cr",
      "Construction": "Sheer Wall",
    },
    {
      "Project Name": "My Home Bhooja",
      "Builder Name": "My Home Group",
      "Project Type": "Luxury Apartments",
      "Location": "Hitech City",
      "Approvals": "HMDA",
      "Project Size": "18.5 acres",
      "Unit sizes": "1300-3200 sq.ft",
      "No of units": "1000",
      "No of Floors": "36 Floors",
      "No of Towers": "6 Towers",
      "Open space": "85%",
      "Configurations": "2, 3, 4.5 BHK",
      "Flats Sizes": "1300 sq.ft - 3200 sq.ft",
      "Possession": "2025-06-15",
      "Club House": "60000 sq.ft",
      "Base Price": "₹10,500/sq.ft",
      "Price": "₹1.7 Cr - ₹3.5 Cr",
      "Construction": "Mivan",
    },
    {
      "Project Name": "Prestige High Fields",
      "Builder Name": "Prestige Group",
      "Project Type": "Premium Residential",
      "Location": "Financial District",
      "Approvals": "GHMC",
      "Project Size": "21 acres",
      "Unit sizes": "1350-2700 sq.ft",
      "No of units": "2240",
      "No of Floors": "34 Floors",
      "No of Towers": "10 Towers",
      "Open space": "88%",
      "Configurations": "2, 3, 4 BHK",
      "Flats Sizes": "1350 sq.ft - 2700 sq.ft",
      "Possession": "2023-12-01",
      "Club House": "50000 sq.ft",
      "Base Price": "₹9600/sq.ft",
      "Price": "₹1.3 Cr - ₹2.6 Cr",
      "Construction": "RCC",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationScreen()),
                  );
                },
              ),
              Text("Compare"),
              Spacer(),
              CircleAvatar(
                radius: 18,
                backgroundImage: _profileImage != null &&
                        _profileImage!.startsWith('assets/')
                    ? AssetImage(_profileImage!) as ImageProvider
                    : FileImage(File(_profileImage ?? '')),
              ),
              SizedBox(width: 12),
            ],
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 100,
                      alignment: Alignment.center,
                      color: Colors.grey.shade100,
                      child: Text(
                        "Project Specs",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ...compareItems.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      return Container(
                        width: 200,
                        height: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade50, Colors.blue.shade50],
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                'assets/images/property$index.jpg',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.close,
                                    size: 14, color: Colors.red),
                              ),
                            ),
                            Positioned(
                              left: 6,
                              top: 6,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1),
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(height: 5),

                // Specs Rows
                ...specs.map((specKey) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            color: Colors.grey.shade100,
                            child: Text(
                              specKey,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 5), // << SPACING BETWEEN SPEC & COMPARISON
                          ...compareItems.map((item) {
                            bool isProjectName = specKey == "Project Name";
                            return Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.shade50,
                                    Colors.blue.shade50
                                  ],
                                ),
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.white70, width: 0.5),
                                ),
                              ),
                              child: Text(
                                item[specKey] ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isProjectName ? 14 : 12,
                                  fontWeight: isProjectName
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  );
                }).toList(),

                // Contact Buttons
                Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: 150,
      color: Colors.grey.shade100,
    ),
    SizedBox(width: 12),
    ...compareItems.map((item) {
      return Container(
        width: 200,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // handle contact
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.indigo],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.call, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Color(0xFF25D366), // WhatsApp green
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 18, // adjust as needed
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  ],
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
