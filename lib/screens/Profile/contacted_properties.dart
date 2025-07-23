import 'package:flutter/material.dart';

class ContactedPropertiesScreen extends StatefulWidget {
  @override
  _ContactedPropertiesScreenState createState() =>
      _ContactedPropertiesScreenState();
}

class _ContactedPropertiesScreenState extends State<ContactedPropertiesScreen> {
  String _selectedSort = "Date";

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
                  padding: EdgeInsets.only(left: 20, top: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      Text(
                        "Contacted properties",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Sort Button (Right-Aligned Below Title)
                Padding(
                  padding: EdgeInsets.only(right: 20, top: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildSortButton(),
                  ),
                ),

                SizedBox(height: 10),

                // Contacted Properties List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      _buildPropertyCard(),
                      _buildPropertyCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Sort Button
  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(value: "Date", child: Text("Date")),
        PopupMenuItem(value: "Price", child: Text("Price")),
        PopupMenuItem(value: "Location", child: Text("Location")),
        PopupMenuItem(value: "Type", child: Text("Type")),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sort by: $_selectedSort",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  // Property Card
  Widget _buildPropertyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Property Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/property1.jpg', // Replace with actual property image
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),

            // Property Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marvella",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("By Brick Infra  |  Tellapur",
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 5),
                  Text("2 BHK  -  1250 sq.ft",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("28/01/2025  -  2 hrs ago",
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),

            // Actions (WhatsApp, Call, Share)
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.black),
                  onPressed: () {
                    // Share Action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.green),
                  onPressed: () {
                    // WhatsApp Action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.blue),
                  onPressed: () {
                    // Call Action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
