import 'dart:io';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:proser/screens/components/fetchLocation_bottomSheet.dart';
import 'package:proser/screens/home/offer_screen.dart';
import 'package:proser/screens/hotLocalities.dart';
import 'package:proser/screens/propertynews.dart';
import 'package:proser/screens/search/search_screen.dart';
import 'package:proser/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proser/screens/Profile/profile_screen.dart';

class HomeScreenVillas extends StatefulWidget {
  @override
  _HomeScreenVillasState createState() => _HomeScreenVillasState();
}

class _HomeScreenVillasState extends State<HomeScreenVillas> {
  final PageController _pageController1 =
      PageController(viewportFraction: 0.95);
  final PageController _pageController2 =
      PageController(viewportFraction: 0.95);
  final PageController _pageController3 =
      PageController(viewportFraction: 0.95);

  int _currentPage1 = 0;
  int _currentPage2 = 0;
  int _currentPage3 = 0;
  String? _profileImage;
  Widget _buildPremiumBannerType1() {
    List<Map<String, String>> premiumDeals = [
      {
        "image": "assets/images/villa1.jpg",
        "title": "The Village",
        "builder": "By Elemental Reality",
        "availability": "Ready by Sep 2025",
        "location": "Kompally",
        "propertyType": "2, 3 BHK",
        "priceRange": "₹ 1.4 Cr - ₹ 2.50 Cr",
        "profile": "assets/images/builder_logo.png",
      },
      {
        "image": "assets/images/villa2.jpg",
        "title": "Raaga",
        "builder": "By Radhey Constructions",
        "availability": "Possession in 2024",
        "location": "Gachibowli",
        "propertyType": "3, 4 BHK",
        "priceRange": "₹ 2.0 Cr - ₹ 3.80 Cr",
        "profile": "assets/images/builder_logo.png",
      },
      {
        "image": "assets/images/villa3.jpg",
        "title": "Woods",
        "builder": "By Vesella Constructions",
        "availability": "Ongoing Project",
        "location": "Madhapur",
        "propertyType": "2, 3 BHK",
        "priceRange": "₹ 1.8 Cr - ₹ 3.20 Cr",
        "profile": "assets/images/builder_logo.png",
      }
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Best Deals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 500,
            child: PageView.builder(
              controller: _pageController1,
              itemCount: premiumDeals.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage1 = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPremiumBannerItem(context, premiumDeals[index]);
              },
            ),
          ),
          SizedBox(height: 7),
          Center(
            child: DotsIndicator(
              dotsCount: premiumDeals.length,
              position: _currentPage1.toDouble(),
              decorator: DotsDecorator(
                activeColor: primaryGreen,
                size: Size.square(8.0),
                activeSize: Size(16.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBannerType2() {
    List<Map<String, String>> editorChoices = [
      {
        "image": "assets/images/villa4.jpg",
        "title": "Pallazzo",
        "builder": "By Sunyuga Infra",
        "availability": "Ready By Sep 2025",
        "location": "Tellapur",
        "propertyType": "3, 4 BHK Villas",
        "priceRange": "₹ 96.0 L - ₹ 2.50 Cr",
        "profile": "assets/images/builder_logo.png",
      },
      {
        "image": "assets/images/villa5.jpg",
        "title": "Hedge wood",
        "builder": "By Chavala Ventures",
        "availability": "Possession in 2024",
        "location": "Hitech City",
        "propertyType": "2, 3 BHK Villas",
        "priceRange": "₹ 1.2 Cr - ₹ 3.00 Cr",
        "profile": "assets/images/builder_logo.png",
      },
      {
        "image": "assets/images/villa6.jpg",
        "title": "Bliss in woods",
        "builder": "By Nest makers",
        "availability": "Ongoing Project",
        "location": "Gachibowli",
        "propertyType": "3, 4 BHK Villas",
        "priceRange": "₹ 1.5 Cr - ₹ 3.50 Cr",
        "profile": "assets/images/builder_logo.png",
      }
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Editor's Choice",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 366,
            child: PageView.builder(
              controller: _pageController2,
              itemCount: editorChoices.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage2 = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildEditorChoiceBanner(context, editorChoices[index]);
              },
            ),
          ),
          SizedBox(height: 7),
          Center(
            child: DotsIndicator(
              dotsCount: editorChoices.length,
              position: _currentPage2.toDouble(),
              decorator: DotsDecorator(
                activeColor: primaryGreen,
                size: Size.square(8.0),
                activeSize: Size(16.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Load Profile Image from SharedPreferences
  Future<void> _loadProfileImage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _profileImage =
              prefs.getString('profile_image') ?? 'assets/images/profile.png';
        });
      }
    } catch (e) {
      debugPrint("Error loading SharedPreferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Proper system back navigation
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              // 🔼 Scrollable AppBar — hides on scroll down
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                pinned: false,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: _buildHomeAppBar(context),
              ),

              // 📌 Sticky + floating Category Section
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _FadeInHeaderDelegate(
                  minHeight: 90,
                  maxHeight: 90,
                  child: _buildCategorySectionType1(),
                ),
              ),

              // 📜 Main scrollable content
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 8),
                    _buildPremiumBannerType1(),
                    _buildPremiumBannerType2(),
                    _buildPremiumBannerType3(),
                    _buildPremiumBannerType4(),
                    //_buildPremiumBannerType5(),
                    _buildPremiumBannerType6(context),
                    _buildPremiumBannerType7(),
                    _buildPremiumBannerType8(context),
                    //_buildPremiumBannerType9(context),
                    _buildCategorySectionType2(),
                    _buildCategorySectionType3(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildPremiumBannerType10(),
                    _buildPremiumBannerType11(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Home App Bar with Dynamic Profile Image
  Widget _buildHomeAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 24, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(onLocationSelected: (String location) {  },)),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 10),
                    Expanded(
                      child: IgnorePointer(
                        // Prevents keyboard from opening automatically
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search your dream home...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
  icon: Icon(Icons.my_location, color: Colors.black54),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => FetchLocationBottomSheet(
        onLocationSelected: (location) {
          // Handle selected location here
          print("Selected Location: $location");
        },
      ),
    );
  },
),

                    SizedBox(width: 10),
                    Icon(Icons.filter_list, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              _loadProfileImage(); // Reload profile image after returning
            },
            child: CircleAvatar(
              radius: 22,
              backgroundImage: _profileImage!.startsWith('assets/')
                  ? AssetImage(_profileImage!) as ImageProvider
                  : FileImage(File(_profileImage!)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySectionType1() {
    List<Map<String, String>> categories = [
      {"title": "Themed Homes", "icon": "assets/icons/home.png"},
      {"title": "Large Living Spaces", "icon": "assets/icons/home.png"},
      {"title": "Sustainable Living Houses", "icon": "assets/icons/home.png"},
      {"title": "2.5 BHK Houses", "icon": "assets/icons/home.png"},
      {"title": "Large Balconies", "icon": "assets/icons/home.png"},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search by category",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryChip(
                  categories[index]["title"]!,
                  categories[index]["icon"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title, String iconPath) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromARGB(255, 213, 213, 213))),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 20,
            width: 20,
          ),
          SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Sliver Persistent Header with fade-in effect
class _FadeInHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _FadeInHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final opacity = 1.0 - (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    return Opacity(
      opacity: opacity,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_FadeInHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Widget _buildCategorySectionType2() {
  List<Map<String, String>> projectCategories = [
    {"name": "Mallampet", "projects": "1 Projects"},
    {"name": "Bachupally", "projects": "2 Projects"},
    {"name": "Kollur", "projects": "9 Projects"},
    {"name": "Ameenpur", "projects": "1 Projects"},
    {"name": "Gajularamaram", "projects": "1 Projects"},
    {"name": "Gachibowli", "projects": "1 Projects"},
    {"name": "Pragathi Nagar", "projects": "1 Projects"},
    {"name": "Bowrampet", "projects": "1 Projects"},
    {"name": "Kompally", "projects": "12 Projects"},
    {"name": "Narsingi", "projects": "3 Projects"},
    {"name": "Tellapur", "projects": "5 Projects"},
    {"name": "Manikonda", "projects": "4 Projects"},
    {"name": "Madhapur", "projects": "7 Projects"},
    {"name": "Jubilee Hills", "projects": "6 Projects"},
    {"name": "Kukatpally", "projects": "8 Projects"},
    {"name": "Shamshabad", "projects": "2 Projects"},
  ];

  PageController _pageController = PageController(viewportFraction: 0.99);
  int _currentPage = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      final int totalPages = (projectCategories.length / 9).ceil();
      final double gridHeight = MediaQuery.of(context).size.width * 0.60;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "Explore Villas in Hyderabad",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // PageView with Grid
            Container(
              height: gridHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  int startIndex = pageIndex * 9;
                  int endIndex =
                      (startIndex + 9).clamp(0, projectCategories.length);
                  List<Map<String, String>> gridItems =
                      projectCategories.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: gridItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.2,
                      ),
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(gridItems[index]);
                      },
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator
            const SizedBox(height: 6),
            Center(
              child: DotsIndicator(
                dotsCount: totalPages,
                position: _currentPage.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.black,
                  size: const Size.square(8.0),
                  activeSize: const Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Category Card Widget
Widget _buildCategoryCard(Map<String, String> category) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: const DecorationImage(
        image: AssetImage("assets/images/hyderabad_bg.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category["name"]!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              category["projects"]!,
              style: const TextStyle(color: Colors.white, fontSize: 11.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

//   Widget _buildCategorySectionType3() {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         bool showAll = false; // ✅ State variable inside builder

//         List<Map<String, String>> categoryCollections = [
//           {"name": "Independent House", "image": "assets/images/house1.png"},
//           {"name": "Ready to Move-in", "image": "assets/images/house1.png"},
//           {"name": "Townships", "image": "assets/images/house1.png"},
//           {"name": "Studio", "image": "assets/images/house1.png"},
//           {"name": "Affordable Houses", "image": "assets/images/house1.png"},
//           {"name": "Luxury Villas", "image": "assets/images/house1.png"},
//           {"name": "Gated Communities", "image": "assets/images/house1.png"},
//           {"name": "Serviced Apartments", "image": "assets/images/house1.png"},
//           {"name": "Farm Houses", "image": "assets/images/house1.png"},
//           {"name": "Eco-Friendly Homes", "image": "assets/images/house1.png"},
//         ];

//         int displayedCount = showAll ? categoryCollections.length : 5;
//         int remainingItems = categoryCollections.length - displayedCount;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // **Section Title**
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Text(
//                 "Collections",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 10),

//             // **Horizontal Scroll List**
//             Container(
//               height: 170,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: displayedCount + (showAll ? 0 : 1), // ✅ Fixing count
//                 padding: EdgeInsets.only(left: 15),
//                 itemBuilder: (context, index) {
//                   if (!showAll && index == 4) {
//                     return _buildMoreButton(
//                       remainingItems,
//                       () => setState(() {
//                         showAll = true; // ✅ Proper state update
//                       }),
//                     );
//                   } else if (index < categoryCollections.length) {
//                     return _buildCategoryCard1(categoryCollections[index]);
//                   } else {
//                     return SizedBox(); // ✅ Prevents out-of-bounds errors
//                   }
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

// // **Category Card**
//   Widget _buildCategoryCard1(Map<String, String> category) {
//     return Container(
//       width: 120,
//       margin: EdgeInsets.only(right: -20), // ✅ Creates overlapping effect
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         image: DecorationImage(
//           image: AssetImage(category["image"]!),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.black.withOpacity(0.4),
//         ),
//         padding: EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               category["name"]!,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 12,
//                 child: Icon(Icons.arrow_forward, color: Colors.black, size: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // **+X More Button**
//   Widget _buildMoreButton(int remainingItems, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 120,
//         margin: EdgeInsets.only(right: -20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white,
//         ),
//         child: Center(
//           child: Text(
//             "+$remainingItems More",
//             style: TextStyle(
//               color: Colors.purple,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

Widget _buildCategorySectionType3() {
  List<Map<String, String>> categoryCollections = [
    {"name": "Independent House", "image": "assets/images/house1.png"},
    {"name": "Ready to Move-in", "image": "assets/images/house2.png"},
    {"name": "Townships", "image": "assets/images/house3.png"},
    {"name": "Studio", "image": "assets/images/house4.png"},
    {"name": "Affordable Houses", "image": "assets/images/house1.png"},
    {"name": "Luxury Villas", "image": "assets/images/house2.png"},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // **Section Title**
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "Collections",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),

      // **Horizontal Scroll List**
      Container(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryCollections.length,
          padding: EdgeInsets.only(left: 15),
          itemBuilder: (context, index) {
            return _buildCategoryCard1(categoryCollections[index]);
          },
        ),
      ),
    ],
  );
}

// **Category Card**
Widget _buildCategoryCard1(Map<String, String> category) {
  return Container(
    width: 120,
    margin: EdgeInsets.only(right: 10), // Space between items
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      image: DecorationImage(
        image: AssetImage(category["image"]!),
        fit: BoxFit.cover,
      ),
    ),
    child: Stack(
      children: [
        // **Dark Overlay for Readability**
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black26, width: 2),
            //color: Colors.black.withOpacity(0.2),
          ),
        ),

        // **Text & Arrow**
        // **Text & Arrow Beside It**
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // **Category Name**
              Expanded(
                child: Text(
                  category["name"]!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // **Arrow Button**
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 8,
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerItem(BuildContext context, Map<String, String> deal) {
  double screenWidth = MediaQuery.of(context).size.width;

  // Responsive fixed height (adjusted for all mobile screens)
  double cardHeight = screenWidth * 1.25;

  return Container(
    width: screenWidth,
    height: cardHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Colors.grey.shade300.withOpacity(0.5),
        width: 2,
      ),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
        Container(
          height: cardHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(deal["image"]!),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Title, builder and logo
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(deal["profile"]!),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal["title"]!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      deal["builder"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Info box
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: screenWidth * 0.55,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(80),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal["availability"]!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, color: primaryGreen, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        deal["location"]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.home, color: primaryGreen, size: 16),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        deal["propertyType"]!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    deal["priceRange"]!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Heart icon
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
              color: Colors.white,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.favorite_border, color: Colors.red),
            ),
          ),
        ),

        // Exclusive badge
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              OfferScreen.showOfferPopup(context);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                "assets/images/exclusive_badge.png",
                width: 50,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEditorChoiceBanner(
    BuildContext context, Map<String, String> deal) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = screenWidth * 1.18;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    height: cardHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1.5,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: cardHeight * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(deal["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Price Tag
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        deal["priceRange"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(deal["profile"]!),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal["title"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                deal["builder"]!,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("  |  ",
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                deal["availability"]!,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: primaryGreen, size: 16),
                        SizedBox(width: 5),
                        Text(
                          deal["location"]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 40),
                        Icon(Icons.king_bed, color: primaryGreen, size: 16),
                        SizedBox(width: 5),
                        Text(
                          deal["propertyType"]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        // Favorite Icon
        Positioned(
          bottom: 75,
          right: 10,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.favorite_border, color: Colors.red),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerType3() {
  List<Map<String, String>> premiumProperties = [
    {
      "image": "assets/images/villa7.jpg",
      "title": "La Casa",
      "builder": "By E-Infra",
      "availability": "Ready by 2025",
      "location": "Tellapur",
      "propertyType": "2 & 4 BHK",
      "priceRange": "₹ 1.00Cr - ₹ 1.63Cr",
      "profile": "assets/images/marvella_logo.jpg",
    },
    {
      "image": "assets/images/villa8.jpg",
      "title": "Avencia",
      "builder": "By Hallmark Builders ",
      "availability": "Possession in 2026",
      "location": "Kokapet",
      "propertyType": "3 & 5 BHK",
      "priceRange": "₹ 2.50Cr - ₹ 3.75Cr",
      "profile": "assets/images/marvella_logo.jpg",
    },
    {
      "image": "assets/images/villa9.jpg",
      "title": "Ankura",
      "builder": "By Myhome Constructions",
      "availability": "Under Construction",
      "location": "Gachibowli",
      "propertyType": "2, 3 & 4 BHK",
      "priceRange": "₹ 1.20Cr - ₹ 2.80Cr",
      "profile": "assets/images/marvella_logo.jpg",
    }
  ];

  PageController _pageController3 = PageController(viewportFraction: 0.95);
  int _currentPage3 = 1;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Premium Villas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height:
                  MediaQuery.of(context).size.width * 0.85, // Responsive height
              child: PageView.builder(
                controller: _pageController3,
                itemCount: premiumProperties.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage3 = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem3(
                      context, premiumProperties[index]);
                },
              ),
            ),
            SizedBox(height: 7),
            Center(
              child: DotsIndicator(
                dotsCount: premiumProperties.length,
                position: _currentPage3.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  size: Size.square(8.0),
                  activeSize: Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerItem3(
    BuildContext context, Map<String, String> property) {
  double cardHeight = MediaQuery.of(context).size.width * 0.85;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    height: cardHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          // Background image
          Image.asset(
            property["image"]!,
            width: double.infinity,
            height: cardHeight,
            fit: BoxFit.cover,
          ),

          // Info container
          Positioned(
            bottom: 0,
            left: 0,
            right: 140,
            child: Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(80),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property["title"]!,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    property["builder"]!,
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    property["availability"]!,
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryGreen, size: 14),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          property["location"]!,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.king_bed, color: primaryGreen, size: 14),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          property["propertyType"]!,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    property["priceRange"]!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Top-right builder logo
          Positioned(
            top: 15,
            right: 15,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  property["profile"]!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPremiumBannerType4() {
  List<Map<String, String>> newLaunchProperties = [
    {
      "image": "assets/images/villa1.jpg",
      "title": "The Village",
      "builder": "Elemental Reality",
      "availability": "Ready by Sep 2024",
      "location": "Nizampet",
      "propertyType": "2, 2.5, 3 BHK",
      "priceRange": "₹ 1.00Cr - ₹ 1.63Cr",
      "profile": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa2.jpg",
      "title": "Raaga",
      "builder": "By Radhey Constructions ",
      "availability": "Possession in 2025",
      "location": "Madhapur",
      "propertyType": "3, 4 BHK",
      "priceRange": "₹ 1.80Cr - ₹ 2.90Cr",
      "profile": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa3.jpg",
      "title": "Woods",
      "builder": "By Vesella Constructions ",
      "availability": "Under Construction",
      "location": "Gachibowli",
      "propertyType": "2, 3 BHK",
      "priceRange": "₹ 90L - ₹ 2.20Cr",
      "profile": "assets/images/elite_logo.jpg",
    }
  ];

  PageController _pageController4 = PageController(viewportFraction: 0.95);
  int _currentPage4 = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "New Launches",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.47,
              child: PageView.builder(
                controller: _pageController4,
                itemCount: newLaunchProperties.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage4 = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem4(
                      context, newLaunchProperties[index]);
                },
              ),
            ),
            Center(
              child: DotsIndicator(
                dotsCount: newLaunchProperties.length,
                position: _currentPage4.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  size: Size.square(8.0),
                  activeSize: Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerItem4(
    BuildContext context, Map<String, String> property) {
  double cardHeight = MediaQuery.of(context).size.width * 0.5;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    height: cardHeight,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        // Left Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            property["image"]!,
            width: MediaQuery.of(context).size.width * 0.45,
            height: cardHeight,
            fit: BoxFit.cover,
          ),
        ),

        // Right Property Info
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          property["profile"]!,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        property["title"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                // Builder
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    property["builder"]!,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Availability
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    property["availability"]!,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 6),

                // Location
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: primaryGreen, size: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property["location"]!,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                // Property Type
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Row(
                    children: [
                      Icon(Icons.king_bed, color: primaryGreen, size: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property["propertyType"]!,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                // Price Range
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    property["priceRange"]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerType6(BuildContext context) {
  List<Map<String, dynamic>> lifestyleProperties = [
    {
      "image": "assets/images/villa1.jpg",
      "title": "The Village",
      "builder": "By Elemental Reality",
      "location": "Kompally",
      "propertyType": "2 & 3 BHK",
      "priceRange": "₹ 55.7 L - ₹ 1.04 Cr",
      "availability": "Ready by Dec 2025",
      "brandLogo": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa2.jpg",
      "title": "Raaga",
      "builder": "By Radhey Constructions",
      "location": "Madhapur",
      "propertyType": "3 & 4 BHK",
      "priceRange": "₹ 1.20 Cr - ₹ 2.50 Cr",
      "availability": "Possession in 2026",
      "brandLogo": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa3.jpg",
      "title": "Woods",
      "builder": "Vesella Constructions",
      "location": "Gachibowli",
      "propertyType": "2 & 3 BHK",
      "priceRange": "₹ 95.0 L - ₹ 2.20 Cr",
      "availability": "Under Construction",
      "brandLogo": "assets/images/elite_logo.jpg",
    }
  ];

  PageController _pageController6 = PageController(viewportFraction: 0.95);
  int _currentPage6 = 0;

  double containerHeight = MediaQuery.of(context).size.width * 0.94;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Lifestyle Properties",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: containerHeight,
              child: PageView.builder(
                controller: _pageController6,
                itemCount: lifestyleProperties.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage6 = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem6(
                      context, lifestyleProperties[index]);
                },
              ),
            ),
            Center(
              child: DotsIndicator(
                dotsCount: lifestyleProperties.length,
                position: _currentPage6.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  size: Size.square(8.0),
                  activeSize: Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerItem6(
    BuildContext context, Map<String, dynamic> property) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageHeight = screenWidth * 0.6;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(property["image"]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5),
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(property["brandLogo"]!),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property["title"]!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3),
                            Text(
                              property["builder"]!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Color.fromARGB(255, 8, 123, 123),
                                      size: 16),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      property["location"]!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.king_bed,
                                      color: Color.fromARGB(255, 8, 123, 123),
                                      size: 16),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      property["propertyType"]!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right Column
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              property["priceRange"]!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              property["availability"]!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Special Offer Badge
      Positioned(
        bottom: screenWidth * 0.25,
        right: 20,
        child: GestureDetector(
          onTap: () {
            OfferScreen.showOfferPopup(context);
          },
          child: Image.asset(
            "assets/images/exclusive_badge.png",
            width: 60,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPremiumBannerType7() {
  List<Map<String, String>> editorChoices = [
    {
      "image": "assets/images/villa4.jpg",
      "title": "Pallazzo",
      "builder": "By Sunyuga Infra",
      "availability": "Ready By Sep 2025",
      "location": "Tellapur",
      "propertyType": "3, 4 BHK Villas",
      "priceRange": "₹ 96.0 L - ₹ 2.50 Cr",
      "profile": "assets/images/builder_logo.png",
    },
    {
      "image": "assets/images/villa5.jpg",
      "title": "Hedge wood",
      "builder": "By Chavala Ventures",
      "availability": "Possession in 2024",
      "location": "Hitech City",
      "propertyType": "2, 3 BHK Villas",
      "priceRange": "₹ 1.2 Cr - ₹ 3.00 Cr",
      "profile": "assets/images/builder_logo.png",
    },
    {
      "image": "assets/images/villa6.jpg",
      "title": "Bliss in woods",
      "builder": "By Nest makers",
      "availability": "Ongoing Project",
      "location": "Gachibowli",
      "propertyType": "3, 4 BHK Villas",
      "priceRange": "₹ 1.5 Cr - ₹ 3.50 Cr",
      "profile": "assets/images/builder_logo.png",
    }
  ];
  PageController _pageController7 = PageController(viewportFraction: 0.95);
  int _currentPage7 = 0;

  double cardHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width *
          0.88;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Ready to move in Villas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: cardHeight,
              child: PageView.builder(
                controller: _pageController7,
                itemCount: editorChoices.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage7 = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildEditorBanner(context, editorChoices[index]);
                },
              ),
            ),
            SizedBox(height: 7),
            Center(
              child: DotsIndicator(
                dotsCount: editorChoices.length,
                position: _currentPage7.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  size: Size.square(8.0),
                  activeSize: Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildEditorBanner(BuildContext context, Map<String, String> deal) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageHeight = screenWidth * 0.55;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300, width: 1.5),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Image.asset(
                    deal["image"]!,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          deal["profile"]!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal["title"]!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          deal["builder"]!,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(" | "),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          deal["availability"]!,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 16),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          deal["location"]!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 0),
                      Icon(Icons.king_bed, color: Colors.blue, size: 16),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          deal["propertyType"]!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      deal["priceRange"]!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Favorite Icon
        Positioned(
          bottom: imageHeight - 120,
          right: 15,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1.5),
              color: Colors.white,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.favorite_border, color: Colors.red),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerType8(BuildContext context) {
  List<Map<String, String>> newLaunchProperties = [
    {
      "image": "assets/images/villa7.jpg",
      "title": "La Casa",
      "builder": "By E-Infra",
      "availability": "Ready by Sep 2024",
      "location": "Kompally",
      "propertyType": "2, 2.5, 3 BHK",
      "priceRange": "₹ 19.9Cr - ₹ 19.92Cr",
      "profile": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa8.jpg",
      "title": "Avencia",
      "builder": "By Hallmark Builders ",
      "availability": "Possession in 2025",
      "location": "Madhapur",
      "propertyType": "3, 4 BHK",
      "priceRange": "₹ 1.80Cr - ₹ 2.90Cr",
      "profile": "assets/images/elite_logo.jpg",
    },
    {
      "image": "assets/images/villa9.jpg",
      "title": "Ankura",
      "builder": "By Myhome Constructions",
      "availability": "Under Construction",
      "location": "Gachibowli",
      "propertyType": "2, 3 BHK",
      "priceRange": "₹ 90L - ₹ 2.20Cr",
      "profile": "assets/images/elite_logo.jpg",
    }
  ];

  PageController _pageController4 = PageController(viewportFraction: 0.95);
  int _currentPage4 = 0;

  double cardHeight = MediaQuery.of(context).size.width * 0.46;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Villas in limelight",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: cardHeight,
              child: PageView.builder(
                controller: _pageController4,
                itemCount: newLaunchProperties.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage4 = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem8(
                      context, newLaunchProperties[index]);
                },
              ),
            ),
            Center(
              child: DotsIndicator(
                dotsCount: newLaunchProperties.length,
                position: _currentPage4.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  size: Size.square(8.0),
                  activeSize: Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerItem8(
    BuildContext context, Map<String, String> property) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageWidth = screenWidth * 0.45;
  double imageHeight = screenWidth * 0.55;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300, width: 1.5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        // Left Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            property["image"]!,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
        ),

        // Right Property Info
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Title
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          property["profile"]!,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        property["title"]!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Builder
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Text(
                    property["builder"]!,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Availability
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Text(
                    property["availability"]!,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 6),

                // Location
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: primaryGreen, size: 14),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          property["location"]!,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Property Type
                Padding(
                  padding: EdgeInsets.only(left: 36, top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.king_bed, color: primaryGreen, size: 14),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          property["propertyType"]!,
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Padding(
                  padding: EdgeInsets.only(left: 32, top: 8),
                  child: Text(
                    property["priceRange"]!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget _buildPremiumBannerType9(BuildContext context) {
//   List<Map<String, dynamic>> sponsoredProperties = [
//     {
//       "image": "assets/images/villa1.jpg",
//       "title": "The Village",
//       "builder": "By Elemental Reality",
//       "availability": "Ready Sep 2025",
//       "location": "Karmanghat",
//       "propertyType": "3 & 4 BHK",
//       "priceRange": "₹ 1.37 Cr - 2 Cr",
//       "profile": "assets/images/builder_logo.png",
//     },
//     {
//       "image": "assets/images/villa1.jpg",
//       "title": "Raaga",
//       "builder": "By Radhey Constructions",
//       "availability": "Possession by 2026",
//       "location": "Gachibowli",
//       "propertyType": "2, 3 & 4 BHK",
//       "priceRange": "₹ 1.50 Cr - ₹ 3.80 Cr",
//       "profile": "assets/images/builder_logo.png",
//     },
//     {
//       "image": "assets/images/villa2.jpg",
//       "title": "Woods",
//       "builder": "By Vesella Constructions ",
//       "availability": "Ready by Dec 2024",
//       "location": "Madhapur",
//       "propertyType": "3 & 4 BHK",
//       "priceRange": "₹ 96.0 L - ₹ 2.50 Cr",
//       "profile": "assets/images/builder_logo.png",
//     },
//   ];

//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           child: Text(
//             "Sponsored",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: 5),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: sponsoredProperties
//                 .map((property) => _buildSponsoredBanner(context, property))
//                 .toList(),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSponsoredBanner(
//     BuildContext context, Map<String, dynamic> property) {
//   double screenWidth = MediaQuery.of(context).size.width;
//   double cardWidth = screenWidth * 0.60;
//   double imageHeight = cardWidth * 0.72;

//   return Container(
//     width: cardWidth,
//     height: imageHeight + 95,
//     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       border: Border.all(color: Colors.grey.shade300, width: 1.5),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Image with overlays
//         Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 property["image"]!,
//                 width: cardWidth,
//                 height: imageHeight,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned(
//               top: 10,
//               left: 10,
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 child: ClipOval(
//                   child: Image.asset(
//                     property["profile"]!,
//                     width: 35,
//                     height: 35,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8,
//               right: 10,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.85),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   property["priceRange"]!,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         // Details
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 14,
//                       backgroundImage: AssetImage(property["profile"]!),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             property["title"]!,
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             property["builder"]!,
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             property["availability"]!,
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Padding(
//                   padding: EdgeInsets.only(left: 30),
//                   child: Row(
//                     children: [
//                       Icon(Icons.location_on, color: primaryGreen, size: 14),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           property["location"]!,
//                           style: TextStyle(
//                               fontSize: 12, fontWeight: FontWeight.bold),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(width: 6),
//                       Icon(Icons.king_bed, color: primaryGreen, size: 14),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           property["propertyType"]!,
//                           style: TextStyle(
//                               fontSize: 12, fontWeight: FontWeight.bold),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildPremiumBannerType10() {
  List<Map<String, String>> localityData = [
    {
      "image": "assets/images/mokila_map.png",
      "title": "Mokila",
      "description":
          "Situated in the lap of nature, Mokila is a suburb in Hyderabad that has recently become a preferred choice of many.",
      "hyperlink": "Explore properties in Mokila",
    },
    {
      "image": "assets/images/mokila_map.png",
      "title": "Gachibowli",
      "description":
          "A bustling IT hub with excellent infrastructure, Gachibowli is home to top companies, educational institutions, and vibrant communities.",
      "hyperlink": "Explore properties in Gachibowli",
    },
    {
      "image": "assets/images/mokila_map.png",
      "title": "Tellapur",
      "description":
          "Known for its rapid urban development, Tellapur is attracting homebuyers with modern residential projects and excellent connectivity.",
      "hyperlink": "Explore properties in Tellapur",
    },
  ];

  PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      double screenWidth = MediaQuery.of(context).size.width;
      double cardHeight = screenWidth * 0.78;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Hot localities to explore",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: cardHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: localityData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildLocalityBanner(context, localityData[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: DotsIndicator(
              dotsCount: localityData.length,
              position: _currentPage.toDouble(),
              decorator: DotsDecorator(
                activeColor: primaryGreen,
                size: const Size.square(8.0),
                activeSize: const Size(16.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Locality Card
Widget _buildLocalityBanner(
    BuildContext context, Map<String, String> locality) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageHeight = screenWidth * 0.45;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.asset(
            locality["image"]!,
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Text(
                locality["description"]!,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // View More
              GestureDetector(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const HotLocalitiesPage()),
                //   );
                // },
                child: Text(
                  "View More",
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Hyperlink
              GestureDetector(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const HotLocalitiesPage()),
                //   );
                // },
                child: Text(
                  locality["hyperlink"]!,
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerType11(BuildContext context) {
  List<Map<String, String>> propertyNews = [
    {
      "image": "assets/images/villa1.jpg",
      "title": "Popular areas to Buy villas in Hyderabad city",
      "category": "MARKET TRENDS",
      "date": "Posted on 1 Feb 2025",
    },
    {
      "image": "assets/images/villa1.jpg",
      "title": "Real estate investments in 2025: What to expect?",
      "category": "INVESTMENT TIPS",
      "date": "Posted on 15 Jan 2025",
    },
    {
      "image": "assets/images/villa1.jpg",
      "title": "Government policies shaping the real estate sector",
      "category": "POLICY UPDATES",
      "date": "Posted on 5 Jan 2025",
    },
  ];

  PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  double cardHeight = MediaQuery.of(context).size.width * 0.68;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Property News",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: cardHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: propertyNews.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildNewsBanner(context, propertyNews[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: DotsIndicator(
              dotsCount: propertyNews.length,
              position: _currentPage.toDouble(),
              decorator: DotsDecorator(
                activeColor: primaryGreen,
                size: const Size.square(8.0),
                activeSize: const Size(16.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// **News Banner Card with working context**
Widget _buildNewsBanner(BuildContext context, Map<String, String> newsItem) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageHeight = screenWidth * 0.45;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PropertyNewsPage()),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              newsItem["image"]!,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),

          // News Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem["title"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        newsItem["category"]!,
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        newsItem["date"]!,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
