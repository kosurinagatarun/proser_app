import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proser/utils/color.dart';

class AllReviewsPage extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const AllReviewsPage({Key? key, required this.reviews}) : super(key: key);

  double get averageRating {
    if (reviews.isEmpty) return 0;
    double total = reviews.fold(0.0, (sum, r) {
      return sum + (double.tryParse(r["rating"]?.toString() ?? "0") ?? 0);
    });
    return double.parse((total / reviews.length).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final tags = [
      "Amazing facilities",
      "Super-fast internet",
      "Peaceful community",
      "Great customer service",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.ios_share, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFEAEAF3),
              Color(0xFFE0F0F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Fabulous",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${reviews.length} reviews",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 10)),
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text("Write a Review"),
                          content: const TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Share your experience...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Submit"),
                            )
                          ],
                        ));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text("Write a review"),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Guest Reviews",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("Sort: Best",
                    style: TextStyle(color: primaryGreen, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            ...reviews.map(_buildReviewCard),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = double.tryParse(review["rating"]?.toString() ?? "0") ?? 0;
    final comment = review["comment"] ?? "";
    final date = review["reviewed_at"] ?? "--";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage("assets/images/user_avatar.png"),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("User",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(date,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(comment,
                    style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text("Helpful",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12)),
                    Spacer(),
                    Icon(Icons.more_horiz, size: 16)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
