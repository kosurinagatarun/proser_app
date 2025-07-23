import 'package:flutter/material.dart';
import 'package:proser/utils/color.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isMessagesSelected = false;
  bool isUnreadSelected = false;

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
              children: [
                // Back Button & Delete Icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.delete, size: 24, color: Colors.black),
                          onPressed: () {
                            // Delete action
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle Buttons Background Container
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildToggleButton("Notification", !isMessagesSelected,
                            () {
                          setState(() {
                            isMessagesSelected = false;
                          });
                        }),
                        _buildToggleButton("Messages", isMessagesSelected, () {
                          setState(() {
                            isMessagesSelected = true;
                          });
                        }),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Show either Notifications or Messages
                isMessagesSelected
                    ? _buildMessagesScreen()
                    : _buildNotificationScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Toggle Button inside background container
  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Notifications Screen
  Widget _buildNotificationScreen() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text("Today",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildNotificationItem(
              "Sai", "Find your dream home today!", "2 hrs ago"),
          _buildNotificationItem(
              "Sai", "Find your dream home today!", "5 days ago"),
        ],
      ),
    );
  }

  // Messages Screen
  Widget _buildMessagesScreen() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
              _buildMessageFilterButton("All", !isUnreadSelected, () {
                setState(() {
                  isUnreadSelected = false;
                });
              }),
              SizedBox(width: 10),
              // _buildMessageFilterButton("Unread", isUnreadSelected, () {
              //   setState(() {
              //     isUnreadSelected = true;
              //   });
              // }),
            ],
          ),
          SizedBox(height: 15),
          Text("Today",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildMessageItem(
              "Nihith", "Find your dream home today!", "10 mins ago", 5),
          _buildMessageItem(
              "Tarun", "Find your dream home today!", "2 hrs ago", 1),
          _buildMessageItem(
              "Bhargav", "Find your dream home today!", "6 days ago", 0),
          SizedBox(height: 10),
          Text("Previous 1 week ago",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _buildMessageItem(
              "Sonu", "Find your dream home today!", "6 days ago", 0),
        ],
      ),
    );
  }

  // Message Filter Buttons
  Widget _buildMessageFilterButton(
      String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Notification Item
  Widget _buildNotificationItem(String name, String message, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
        trailing:
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }

  // Message Item with unread count
  Widget _buildMessageItem(
      String name, String message, String time, int unreadCount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
        trailing: unreadCount > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: primaryGreen,
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }
}
