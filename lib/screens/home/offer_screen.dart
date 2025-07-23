import 'package:flutter/material.dart';

class OfferScreen {
  static void showOfferPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOfferContent(context),
    );
  }

  static Widget _buildOfferContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 15,
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/exclusive_badge.png",
                        width: 30), // Offer Icon
                    SizedBox(width: 8),
                    Text(
                      "Exclusive Offer!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Offer Details
                _buildOfferItem(
                  "Book your flat before Jan 26th and avail gold coins worth ₹50,000",
                ),
                _buildOfferItem(
                  "Book your home before Feb 13th and enjoy an instant cash discount of ₹1,00,000",
                ),
                _buildOfferItem(
                  "Get ₹1,00,000 cashback on booking your dream home today!",
                ),
                _buildOfferItem(
                  "Move in now, pay later! Avail zero down payment offer on select flats.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Offer List Item
  static Widget _buildOfferItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🎁 ", style: TextStyle(fontSize: 16)), // Gift icon
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
