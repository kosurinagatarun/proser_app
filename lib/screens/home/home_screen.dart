import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proser/api/category_API/ProjectCategory.dart';
import 'package:proser/api/category_API/ProjectCategoryService.dart';
import 'package:proser/api/home_api_service.dart' as LocalityService;
import 'package:proser/api/homescreen_model.dart';
import 'package:proser/api/home_api_service.dart';
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/components/constant.dart';
import 'package:proser/screens/components/fetchLocation_bottomSheet.dart';
import 'package:proser/screens/home/offer_screen.dart';
import 'package:proser/screens/hotLocalities.dart';
import 'package:proser/screens/navigation_screen.dart';
import 'package:proser/screens/property_type_screen.dart';
import 'package:proser/screens/propertynews.dart';
import 'package:proser/screens/search/PropertyByLocation.dart';
import 'package:proser/screens/search/search_screen.dart';
import 'package:proser/screens/wishlist_manager.dart';
import 'package:proser/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proser/screens/Profile/profile_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/category_API/best_deal_model.dart';



class _FadeCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _FadeCategoryHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final opacity = 1.0 - (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    return Opacity(opacity: opacity, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SearchBarHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}



class _HomeScreenState extends State<HomeScreen> {
PageController _pageController1 = PageController(
  viewportFraction: 0.95,
  //initialPage: 10000,
);
  final PageController _pageController2 =
      PageController(viewportFraction: 0.95);
  final PageController _pageController3 =
      PageController(viewportFraction: 0.95);
  //late final PageController _pageController1;
int _currentPage1 = 0;
bool _userInteracting = false;
Timer? _autoPlayTimer;
double _progress = 0.0;
Timer? _progressTimer;
bool _timerStarted = false;
List<dynamic> projectData = [];
bool isLoading = true;

  

  //int _currentPage1 = 0;
  int _currentPage2 = 0;
  int _currentPage3 = 0;
  String? _profileImage;

  
//int _currentPage1 = 10000;



Widget _buildPremiumBannerType1(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final baseFontSize = screenWidth * 0.035;
  final cardHeight = screenHeight * 0.523;

  final PageController pageController = PageController(viewportFraction: 0.98);

  return FutureBuilder<List<BestDeal>>(
    future: _bestDealsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: const Color.fromARGB(255, 185, 185, 185),
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: const Color.fromARGB(255, 3, 3, 3),
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No best deals available"));
      }

      final deals = snapshot.data!;

      return StatefulBuilder(
        builder: (context, setState) {
          void startProgressTimer(StateSetter setState, int totalItems) {
  _progressTimer?.cancel();
  _progressTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
    setState(() {
      _progress = (_progress + 0.02).clamp(0.0, 1.0);
      if (_progress >= 1.0) {
        _progress = 0.0;
        _currentPage1 = (_currentPage1 + 1) % totalItems;
        if (_pageController1.hasClients) {
          _pageController1.animateToPage(
            _currentPage1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  });
}


         if (!_timerStarted && mounted) {
  _timerStarted = true;
  startProgressTimer(setState, snapshot.data!.length);
}



          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  "Best Deals",
                  style: TextStyle(fontSize: baseFontSize * 1.2, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: cardHeight,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: deals.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage1 = index;
                      _progress = 0.0;
                    });
                  },
                  itemBuilder: (context, index) {
                    final deal = deals[index];
                    return Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 204, 228, 215),
                                    Color.fromARGB(255, 255, 99, 51)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: _buildPremiumBannerItem(context, deal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(deals.length, (index) {
                  if (index == _currentPage1) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Stack(
                        children: [
                          Container(
                            width: 30,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 50),
                            width: 30 * _progress,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${_currentPage1 + 1} / ${deals.length}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}





Widget _buildPremiumBannerType2(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = screenWidth * 0.92; // Responsive card height
  double baseFontSize = screenWidth * 0.035;

  return FutureBuilder<List<EditorsChoice>>(
    future: _editorsChoiceFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No editors choice available"));
      }

      final editorChoices = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Editor's Choice",
                style: TextStyle(
                  fontSize: baseFontSize * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: editorChoices.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final deal = editorChoices[index];
                  return _buildEditorChoiceBanner(context, deal);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildPremiumBannerType3(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final baseFontSize = screenWidth * 0.035;

  return FutureBuilder<List<SelectedProperty>>(
    future: _selectedPropertiesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No selected properties found"));
      }

      final premiumProperties = snapshot.data!;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Select Properties",
                    style: TextStyle(
                      fontSize: baseFontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenWidth * 0.6,
                  child: PageView.builder(
                    controller: _pageController3,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage3 = index;
                      });
                    },
                    itemCount: premiumProperties.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: _buildPremiumBannerItem3(context, premiumProperties[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(premiumProperties.length, (index) {
                          final isActive = _currentPage3 == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 10 : 6,
                            height: isActive ? 10 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? primaryGreen
                                  : Colors.grey.shade400.withOpacity(0.4),
                              shape: BoxShape.circle,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.6),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentPage3 + 1} / ${premiumProperties.length}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildPremiumBannerType5() {
  PageController _builderPageController = PageController(viewportFraction: 1);
  int _currentBuilderIndex = 0;

  return FutureBuilder<List<ProminentBuilder>>(
    future: _prominentBuildersFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No builders in focus found"));
      }

      final prominentBuilders = snapshot.data!;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Builders in Focus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 465,
                  child: PageView.builder(
                    controller: _builderPageController,
                    itemCount: prominentBuilders.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBuilderIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final builder = prominentBuilders[index];
                      return _buildBuilderFocusCardDynamic(context, builder);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(prominentBuilders.length, (index) {
                          final isActive = _currentBuilderIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 10 : 6,
                            height: isActive ? 10 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? primaryGreen
                                  : Colors.grey.shade400.withOpacity(0.4),
                              shape: BoxShape.circle,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.6),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentBuilderIndex + 1} / ${prominentBuilders.length}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildPremiumBannerType6(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerHeight = screenWidth * 0.91;
  double baseFontSize = screenWidth * 0.035;

  return FutureBuilder<List<LifestyleProperty>>(
    future: _lifestylePropertiesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No lifestyle properties found"));
      }

      final lifestyleProperties = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Lifestyle Properties",
                style: TextStyle(
                  fontSize: baseFontSize * 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: containerHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: lifestyleProperties.length,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem6(context, lifestyleProperties[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerType4(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final fontSize = screenWidth * 0.045;

  return FutureBuilder<List<NewLaunchProperty>>(
    future:  _newLaunchesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return Center(child: Text("Error loading: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No New Launches Found"));
      }

      final properties = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("New Launches",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: screenWidth * 0.69,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: properties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem4(context, properties[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildPremiumBannerType7(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = 300;

  return FutureBuilder<List<ReadyToMoveProperty>>(
    future: _readyToMoveFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading properties"));
      }

      final editorChoices = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Ready to move in projects",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: editorChoices.map((property) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: _buildEditorBanner(context, property),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildPremiumBannerType8(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = screenWidth * 0.55;

  return FutureBuilder<List<LimelightProperty>>(
    future:  _limelightPropertiesFuture, // 👈 Your API function
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading limelight properties"));
      }

      final properties = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Properties in Limelight",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return _buildPremiumBannerItem8(context, properties[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildPremiumBannerType9(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double baseFontSize = screenWidth * 0.035;

  return FutureBuilder<List<SponsoredProperty>>(
    future: _sponsoredPropertiesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading sponsored properties"));
      }

      final sponsoredList = snapshot.data ?? [];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Sponsored",
                style: TextStyle(
                  fontSize: baseFontSize * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sponsoredList
                    .map((property) => _buildSponsoredBanner(context, property))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerType10(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double cardHeight = screenWidth * 0.55;
  final double titleFontSize = screenWidth * 0.045;

  return FutureBuilder<List<HotLocality>>(
    future: _hotLocalityFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: const Color.fromARGB(255, 75, 75, 75),
    ),
  ),
);
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading hot localities"));
      }

      final localities = snapshot.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Text(
              "Hot localities to explore",
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          SizedBox(
            height: cardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              itemCount: localities.length,
              separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.02),
              itemBuilder: (context, index) {
                return _buildLocalityBannerFromModel(context, localities[index]);
              },
            ),
          ),
        ],
      );
    },
  );
}



 List<String> animatedOptions = ["Location", "Builder", "BHK", "Project"];
int animatedIndex = 0;

late Future<List<BestDeal>> _bestDealsFuture;
late Future<List<EditorsChoice>> _editorsChoiceFuture;
late Future<List<SelectedProperty>> _selectedPropertiesFuture;
late Future<List<ProminentBuilder>> _prominentBuildersFuture;
late Future<List<LifestyleProperty>> _lifestylePropertiesFuture;
late Future<List<NewLaunchProperty>> _newLaunchesFuture;
late Future<List<ReadyToMoveProperty>> _readyToMoveFuture;
late Future<List<LimelightProperty>> _limelightPropertiesFuture;
late Future<List<SponsoredProperty>> _sponsoredPropertiesFuture;
late Future<List<HotLocality>> _hotLocalityFuture;
late Future<List<ProjectCategory>> _projectCategoryFuture;







@override
void initState() {
  super.initState();
  fetchProjectData();
_pageController1 = PageController(
  viewportFraction: 0.95,
  initialPage: 0, // or use a random number (e.g. 10000) for infinite-loop trick
);

   _bestDealsFuture = fetchBestDeals();
  _editorsChoiceFuture = fetchEditorsChoice();
  _selectedPropertiesFuture = fetchSelectedProperties();
  _prominentBuildersFuture = fetchProminentBuilders();
  _lifestylePropertiesFuture = fetchLifestyleProperties();
  _newLaunchesFuture = fetchNewLaunches();
  _readyToMoveFuture = fetchReadyToMoveProperties();
  _limelightPropertiesFuture = fetchLimelightProperties();
  _sponsoredPropertiesFuture = fetchSponsoredProperties();
  _hotLocalityFuture = LocalityService.fetchHotLocalities();
  _projectCategoryFuture = ProjectCategoryService.fetchCategories();



  if (_progressTimer == null) {
  _autoPlayTimer = Timer.periodic(Duration(seconds: 4), (_) {
    if (!_userInteracting && _pageController1.hasClients) {
      _currentPage1 = (_currentPage1 + 1) % 3;
      _pageController1.animateToPage(
        _currentPage1,
        duration: Duration(milliseconds: 900),
        curve: Curves.linear,
      );
    }
  });

  _loadProfileImage(); // Keep existing code
  _startAnimationLoop(); // Keep existing code
}}

@override
void dispose() {
  _autoPlayTimer?.cancel();
  _progressTimer?.cancel(); // << ADD THIS
  _pageController1.dispose();
  super.dispose();
}



Future<void> fetchProjectData() async {
  final response = await http.get(Uri.parse(
    "${AppConstants.baseUrl1}/api/v1/projects/apartment-buy",
  ));
  final decoded = jsonDecode(response.body);
  if (decoded['success']) {
    setState(() {
      projectData = decoded['data'];
      isLoading = false;
    });
  }
}


  void onLocationSelected(String location) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationScreen(
        selectedIndex: 1,
        initialPageType: location,
      ),
    ),
  );
}


void _startAnimationLoop() {
  Future.doWhile(() async {
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        animatedIndex = (animatedIndex + 1) % animatedOptions.length;
      });
    }
    return true;
  });
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

// SliverAppBar with smooth scroll (no clipper, fixed height)
SliverAppBar(
  pinned: true,
  backgroundColor: primaryGreen, // solid background
  automaticallyImplyLeading: false,
  elevation: 4,
  toolbarHeight: 70,
  forceElevated: true,
  flexibleSpace: Builder(
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;

      return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔙 Back Button
              Container(
                width: screenWidth * 0.10,
                height: screenWidth * 0.10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: screenWidth * 0.045,
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => PropertyTypeScreen(isBuySelected: true),
                        transitionsBuilder: (_, animation, __, child) {
                          final tween = Tween(begin: Offset(-1.0, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOut));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.025),

              // 🔍 Search Bar
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => NavigationScreen(selectedIndex: 1),
                        transitionsBuilder: (_, animation, __, child) {
                          final tween = Tween(begin: Offset(1.0, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOut));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: screenWidth * 0.12,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black54, size: screenWidth * 0.05),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  "Search by ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                AnimatedTextKit(
                                  repeatForever: true,
                                  pause: Duration(milliseconds: 1000),
                                  animatedTexts: [
                                    'Location',
                                    'Builder',
                                    'BHK',
                                    'Project'
                                  ].map((text) => TypewriterAnimatedText(
                                    text,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.black87,
                                    ),
                                    speed: Duration(milliseconds: 100),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.my_location, color: Colors.black54, size: screenWidth * 0.05),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                              ),
                              builder: (context) => FetchLocationBottomSheet(
                                onLocationSelected: (location) {
                                  print("Selected Location: $location");
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.025),

              // 👤 Profile
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) => ProfileScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        final tween = Tween(begin: Offset(1.0, 0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                    ),
                  );
                  _loadProfileImage();
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.045,
                    backgroundImage: (_profileImage == null || _profileImage!.isEmpty)
                        ? AssetImage('assets/images/profile.png')
                        : (_profileImage!.startsWith('assets/')
                            ? AssetImage(_profileImage!) as ImageProvider
                            : FileImage(File(_profileImage!))),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

// Category section with fade and curved bottom
SliverPersistentHeader(
  pinned: false,
  floating: false,
  delegate: _FadeCategoryHeaderDelegate(
    minExtent: 120,
    maxExtent: 120,
    child: ClipPath(
      clipper: DualCornerCurveClipper(),
      child: Container(
        color: primaryGreen,
        padding: EdgeInsets.only(left: 12, bottom: 15),
        child: _buildCategorySectionType1(context),
      ),
    ),
  ),
),




              // 📜 Main scrollable content
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //SizedBox(height: 8),
                    _buildPremiumBannerType1(context),
                    // SizedBox(
                    //   height: 2,
                    // ),
                    _buildPremiumBannerType2(context),
                    _buildPremiumBannerType3(context),
                    _buildPremiumBannerType4(context),
                    _buildPremiumBannerType5(),
                    _buildPremiumBannerType6(context),
                    _buildPremiumBannerType7(context),
                    _buildPremiumBannerType8(context),
                    _buildPremiumBannerType9(context),
                    _buildCategorySectionType2(context, projectData, onLocationSelected),
                    _buildCategorySectionType3(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildPremiumBannerType10(context),
                    _buildPremiumBannerType11(context),
                    _buildSectionType21(context),
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
//   Widget _buildHomeAppBar(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_back, size: 24, color: Colors.black),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 PageRouteBuilder(
//                   transitionDuration: Duration(milliseconds: 400),
//                   pageBuilder: (_, __, ___) => PropertyTypeScreen(
//                       isBuySelected: true), // or pass dynamic value
//                   transitionsBuilder: (_, animation, __, child) {
//                     const begin = Offset(-1.0, 0.0);
//                     const end = Offset.zero;
//                     const curve = Curves.easeInOut;

//                     final tween = Tween(begin: begin, end: end)
//                         .chain(CurveTween(curve: curve));

//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//   Navigator.pushReplacement(
//     context,
//     PageRouteBuilder(
//       transitionDuration: Duration(milliseconds: 400),
//       pageBuilder: (_, __, ___) => NavigationScreen(
//         selectedIndex: 1,
//       ),
//       transitionsBuilder: (_, animation, __, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.easeInOut;
//         final tween = Tween(begin: begin, end: end)
//             .chain(CurveTween(curve: curve));
//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     ),
//   );
// },

//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.black54),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: IgnorePointer(
//                         // Prevents keyboard from opening automatically
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: "Search your dream home...",
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//   icon: Icon(Icons.my_location, color: Colors.black54),
//   onPressed: () {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => FetchLocationBottomSheet(
//         onLocationSelected: (location) {
//           // Handle selected location here
//           print("Selected Location: $location");
//         },
//       ),
//     );
//   },
// ),

//                     // SizedBox(width: 10),
//                     // Icon(Icons.filter_list, color: Colors.black54),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 5),
//           GestureDetector(
//             onTap: () async {
//               await Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   transitionDuration: Duration(milliseconds: 400),
//                   pageBuilder: (_, __, ___) => ProfileScreen(),
//                   transitionsBuilder: (_, animation, __, child) {
//                     const begin = Offset(1.0, 0.0);
//                     const end = Offset.zero;
//                     const curve = Curves.easeInOut;
//                     final tween = Tween(begin: begin, end: end)
//                         .chain(CurveTween(curve: curve));

//                     return SlideTransition(
//                       position: animation.drive(tween),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//               _loadProfileImage(); // Refresh image after return
//             },
//             child: CircleAvatar(
//               radius: 22,
//               backgroundImage: _profileImage!.startsWith('assets/')
//                   ? AssetImage(_profileImage!) as ImageProvider
//                   : FileImage(File(_profileImage!)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

Widget _buildCategorySectionType1(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return FutureBuilder<List<ProjectCategory>>(
    future: _projectCategoryFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
  child: Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180, // Set an appropriate height for each section
      color: Colors.white,
    ),
  ),
);

      } else if (snapshot.hasError) {
        return const Center(child: Text("Failed to load categories"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox.shrink();
      }

      final categories = snapshot.data!;

      return Padding(
        padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.01),
        child: SizedBox(
          height: screenHeight * 0.1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSearchByCategoryCard(context),
              ...categories.map((cat) =>
                _buildNetworkChip(context, cat.name, cat.image)).toList(),
            ],
          ),
        ),
      );
    },
  );
}


Widget _buildSearchByCategoryCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final baseFontSize = screenWidth * 0.027;

  return Container(
    width: screenWidth * 0.2,
    margin: EdgeInsets.only(right: screenWidth * 0.03),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Colors.orange, Colors.yellow], // Outer Gradient from orange to yellow
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(2.0), // Padding to create space between outer border and inner gradient
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // White space inside the border
          borderRadius: BorderRadius.circular(16), // Inner rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Inner padding to create space between white space and inner gradient
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFfdebd3), Colors.white, Color(0xFFcaf0f8)], // Inner Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12), // Inner rounded corners
            ),
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Search", style: TextStyle(fontSize: baseFontSize * 0.9, fontWeight: FontWeight.bold)),
                Text("by", style: TextStyle(fontSize: baseFontSize * 0.9, fontWeight: FontWeight.bold)),
                Text("category", style: TextStyle(fontSize: baseFontSize * 0.9, fontWeight: FontWeight.bold)),
                SizedBox(height: screenHeight * 0.005),
                Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: baseFontSize * 1.2),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildNetworkChip(BuildContext context, String title, String imageUrl) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final baseFontSize = screenWidth * 0.027;

  return Container(
    width: screenWidth * 0.2,
    margin: EdgeInsets.only(right: screenWidth * 0.03),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [Colors.orange, Colors.yellow],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFfdebd3), Colors.white, Color(0xFFcaf0f8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
                SizedBox(height: screenHeight * 0.005),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: baseFontSize * 0.75,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

Widget _buildCategorySectionType2(
  BuildContext context,
  List<dynamic> projectData,
  Function(String) onLocationSelected, // Pass from parent (like SearchScreen)
) {
  final Map<String, int> localityCounts = {};

  for (var item in projectData) {
    final address = item['project']?['geo_address'] ?? '';
    if (address.isNotEmpty) {
      final parts = address.split(',');
      final trimmedParts = parts.map((e) => e.trim()).toList();
      String locality = '';

      // Fallback: Try 4th-last (e.g., HITEC City)
      if (trimmedParts.length >= 4) {
        locality = trimmedParts[trimmedParts.length - 4];
      } else if (trimmedParts.length >= 3) {
        locality = trimmedParts[trimmedParts.length - 3];
      } else {
        locality = 'Unknown';
      }

      if (locality.isNotEmpty) {
        localityCounts[locality] = (localityCounts[locality] ?? 0) + 1;
      }
    }
  }

  final List<Map<String, String>> projectCategories = localityCounts.entries.map((entry) {
    return {
      'name': entry.key,
      'projects': "${entry.value} Project${entry.value > 1 ? 's' : ''}"
    };
  }).toList();

  List<List<Map<String, String>>> pages = [];
  for (int i = 0; i < projectCategories.length; i += 9) {
    pages.add(projectCategories.sublist(
      i,
      (i + 9 > projectCategories.length) ? projectCategories.length : i + 9,
    ));
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, bottom: 10),
          child: Text(
            "Explore Projects in Hyderabad",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 210,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pages.map((pageItems) {
                List<Widget> rows = [];
                for (int i = 0; i < pageItems.length; i += 3) {
                  rows.add(
                    Row(
                      children: List.generate(3, (j) {
                        int index = i + j;
                        if (index >= pageItems.length) {
                          return const SizedBox(width: 100);
                        }
                        final category = pageItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              // 👇 Same behavior as in SearchScreen
                              onLocationSelected(category["name"]!);
                            },
                            child: SizedBox(
                              width: 120,
                              height: 60,
                              child: _buildCategoryCard(category),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rows,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ),
  );
}






// Category Card Widget
Widget _buildCategoryCard(Map<String, String> category) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: const DecorationImage(
        image: AssetImage("assets/images/hyderabad_bg5.jpg"),
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
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              category["projects"]!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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
//           {"name": "Luxury Apartments", "image": "assets/images/house1.png"},
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
//                 child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
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
    {"name": "Themed Homes", "image": "assets/images/house1.png"},
    {"name": "Large Living Spaces", "image": "assets/images/house2.png"},
    {"name": "Sustainable living Houses", "image": "assets/images/house3.png"},
    {"name": "2.5 BHK Houses", "image": "assets/images/house4.png"},
    {"name": "Large Balconies", "image": "assets/images/house1.png"},
    {"name": "Luxury Apartments", "image": "assets/images/house2.png"},
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
          padding: EdgeInsets.all(8),
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
                child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumBannerItem(BuildContext context, BestDeal deal) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final baseFontSize = screenWidth * 0.036;

  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PropertyScreen(
        slug: deal.slug, // 👈 pass the unique slug here
        propertyTitle: deal.title,
        builderName: deal.byLabel,
        imageUrl: deal.validatedImageUrl,
        builderLogo:deal.logo,
      ),
    ),
  );
},

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(2),
          width: screenWidth,
          height: screenWidth * 0.94,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: deal.validatedImageUrl.startsWith("http")
                    ? SizedBox(
  height: 400, // Adjust height as needed
  width: double.infinity,
  child: Image.network(
    deal.validatedImageUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/images/default.png",
        fit: BoxFit.cover,
      );
    },
  ),
)

                    : Image.asset(
                        "assets/images/default.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 204, 228, 215),
                        Color.fromARGB(255, 255, 99, 51),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Possession :  ${deal.possession}",
                    style: TextStyle(color: Colors.white, fontSize: baseFontSize * 0.9),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.05,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              "assets/images/builder_logo.png",
                              width: screenWidth * 0.10,
                              height: screenWidth * 0.10,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              deal.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: baseFontSize * 1.2,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 248, 246, 240),
                              ),
                            ),
                            Text(
                              deal.byLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize,
                                color: const Color.fromARGB(255, 248, 246, 240),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(2, 0, 2, 2),
          width: screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 204, 228, 215),
                Color.fromARGB(255, 251, 145, 113),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: const Color.fromARGB(255, 61, 61, 61), size: baseFontSize),
                      const SizedBox(width: 4),
                      Text(
                        deal.location,
                        style: TextStyle(
                          fontSize: baseFontSize * 1.2,
                          color: const Color.fromARGB(255, 61, 61, 61),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.home,
                          color: const Color.fromARGB(255, 61, 61, 61), size: baseFontSize),
                      const SizedBox(width: 4),
                      Text(
                        deal.bhk,
                        style: TextStyle(
                          fontSize: baseFontSize * 1.2,
                          color: const Color.fromARGB(255, 61, 61, 61),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      deal.priceRange,
                      style: TextStyle(
                        fontSize: baseFontSize * 1.2,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 61, 61, 61),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: screenWidth * 0.09,
                      height: screenHeight * 0.022,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_forward_ios,
                            size: baseFontSize, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



Widget _buildEditorChoiceBanner(BuildContext context, EditorsChoice deal) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = screenWidth * 1.1;
  double baseFontSize = screenWidth * 0.035;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: deal.slug, // 👈 pass the unique slug
            propertyTitle: deal.title,
            builderName: deal.byLabel,
            imageUrl: deal.validatedImageUrl,
            builderLogo: deal.logo,
          ),
        ),
      );
    },
    child: Container(
      width: screenWidth * 0.9,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 252, 217, 242),
            Color.fromARGB(255, 220, 230, 248),
            Color.fromARGB(255, 253, 241, 220),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Stack(
        children: [
          // 🖼 Image section
          Positioned(
            top: baseFontSize * 1.5,
            right: 0,
            child: Stack(
              children: [
                Container(
                  width: screenWidth * 0.82,
                  height: screenWidth * 0.73,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent.shade100,
                      width: 4,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: deal.validatedImageUrl.startsWith("http")
                        ? Image.network(
                            deal.validatedImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  "No image available",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No image available",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.black87,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tag
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: baseFontSize * 0.6,
                vertical: baseFontSize * 0.2,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 144, 224),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Text(
                "Possession : ${deal.possession}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: baseFontSize * 0.85,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Title & Builder
          Positioned(
            left: 42,
            top: screenWidth * 0.5 + baseFontSize * 4.3,
            right: 16,
            child: RichText(
              text: TextSpan(
                text: "${deal.title}\n",
                style: TextStyle(
                  fontSize: baseFontSize * 1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: deal.byLabel,
                    style: TextStyle(
                      fontSize: baseFontSize * 1.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location & Property Type
          Positioned(
            left: 30,
            top: screenWidth * 0.5 + baseFontSize * 8.3,
            right: 16,
            child: Row(
              children: [
                Icon(Icons.location_on, size: baseFontSize, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  deal.location,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: baseFontSize,
                  ),
                ),
                const SizedBox(width: 80),
                Icon(Icons.king_bed, size: baseFontSize, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  deal.bhk,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: baseFontSize,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Positioned(
            left: 130,
            top: screenWidth * 0.5 + baseFontSize * 10,
            child: Text(
              deal.priceRange.isNotEmpty ? deal.priceRange : "Price on request",
              style: TextStyle(
                fontSize: baseFontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Arrow
          Positioned(
            bottom: 8,
            right: 12,
            child: Container(
              width: baseFontSize * 2.2,
              height: baseFontSize * 2.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.black26,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: baseFontSize,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}







Widget _buildPremiumBannerItem3(BuildContext context, SelectedProperty property) {
  double cardWidth = MediaQuery.of(context).size.width * 0.95;
  double cardHeight = MediaQuery.of(context).size.width * 0.55;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: property.slug,
            propertyTitle: property.title,
            builderName: property.byLabel,
            imageUrl: property.validatedImageUrl,
            builderLogo: property.validatedLogoUrl,
          ),
        ),
      );
    },
    child: Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            property.validatedImageUrl.startsWith("http")
                ? Image.network(
                    property.validatedImageUrl,
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/default.png",
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    "assets/images/default.png",
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  ),

            // Top right logo
            Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: property.validatedLogoUrl.startsWith("http")
                      ? Image.network(
                          property.validatedLogoUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/images/builder_logo.png", width: 40, height: 40),
                        )
                      : Image.asset("assets/images/builder_logo.png", width: 40, height: 40),
                ),
              ),
            ),

            // Text info container
            Positioned(
              left: 0,
              right: 0,
              bottom: 55,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Builder
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${property.title} ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: property.byLabel,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Possession :  ${property.possession}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.king_bed, color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.bhk,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              property.priceRange.isNotEmpty
                                  ? property.priceRange
                                  : "Price on request",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}







Widget _buildPremiumBannerItem4(BuildContext context, NewLaunchProperty property) {
  final screenWidth = MediaQuery.of(context).size.width;
  final cardHeight = screenWidth * 0.54;
  final baseFontSize = screenWidth * 0.032;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PropertyScreen(
            slug: property.slug,
            propertyTitle: property.title,
            builderName: property.companyName,
            imageUrl: property.validatedImageUrl,
            builderLogo: property.validatedLogo,
          ),
        ),
      );
    },
    child: Material(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: screenWidth > 600 ? 500 : screenWidth * 0.93,
        height: cardHeight + 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(126, 103, 179, 166),
              Color.fromARGB(116, 218, 200, 169),
              Color.fromARGB(107, 253, 169, 144),
              Color.fromARGB(104, 61, 109, 133),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Logo and title
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: screenWidth * 0.015),
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreen, width: 1),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(property.validatedLogo),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    property.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize * 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    property.builderName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize * 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Main row
            Row(
              children: [
                // Image
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      property.validatedImageUrl,
                      width: screenWidth * 0.45,
                      height: cardHeight * 0.872,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset("assets/images/default.png"),
                    ),
                  ),
                ),

                // Text content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIconTextRow(Icons.location_on, property.location, baseFontSize),
                        const SizedBox(height: 8),
                        _buildIconTextRow(Icons.king_bed, property.bhk, baseFontSize),
                        const SizedBox(height: 8),
                        Text(property.priceRange, style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Possession : ${property.possession}", style: TextStyle(fontSize: baseFontSize, color: Colors.black54)),
                        const SizedBox(height: 8),
                        _buildViewMoreButton(context, baseFontSize, screenWidth),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildIconTextRow(IconData icon, String text, double fontSize) {
  return Row(
    children: [
      Icon(icon, color: primaryGreen, size: fontSize),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget _buildViewMoreButton(BuildContext context, double fontSize, double screenWidth) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "View More",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(screenWidth * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: fontSize,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}





Widget _buildBuilderFocusCardDynamic(BuildContext context, ProminentBuilder builder){
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF5E3D3),
      border: Border.all(
        color: Colors.grey.shade400,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        // white header
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: builder.validatedBuilderLogo.startsWith("http")
                    ? NetworkImage(builder.validatedBuilderLogo)
                    : AssetImage("assets/images/builder_logo.png") as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      builder.builderName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.verified, color: primaryGreen, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "Verified",
                          style: TextStyle(color: primaryGreen, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.apartment, color: primaryGreen, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "1 Project",  // you could count dynamic projects later
                          style: TextStyle(color: primaryGreen, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // projects under this builder
        Container(
          height: 380,
          padding: const EdgeInsets.only(left: 12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 260,
                child: buildPropertyCardDynamic(context, builder),
              ),
            ],
          ),
        )
      ],
    ),
  );
}


class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


Widget buildPropertyCardDynamic(BuildContext context, ProminentBuilder property, {VoidCallback? onWishlistToggle}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageHeight = screenWidth * 0.55;
  double fontSize = screenWidth * 0.050;
  double smallFont = screenWidth * 0.03;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: property.projectSlug,
            propertyTitle: property.projectTitle,
            builderName: property.builderName,
            imageUrl: property.validatedCoverImage,
            builderLogo: property.validatedBuilderLogo,
          ),
        ),
      );
    },
    child: StatefulBuilder(
      builder: (context, setState) {
        bool isWishlisted = WishlistManager.isWishlisted(property.projectSlug);

        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: primaryGreen,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: BottomWaveClipper(),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: property.validatedCoverImage.startsWith("http")
                          ? Image.network(
                              property.validatedCoverImage,
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/images/default.png",
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/images/default.png",
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
  await WishlistManager.toggle(property.projectSlug);
  if (onWishlistToggle != null) onWishlistToggle(); // Notify parent to refresh
  setState(() {});
},

                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          property.location,
                          style: TextStyle(
                            fontSize: smallFont,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${property.projectTitle} ",
                            style: TextStyle(
                              fontSize: fontSize - 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: "by ${property.builderName}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.description, size: smallFont + 4, color: Colors.black87),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  property.bhk,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: smallFont,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(height: 30, width: 1, color: Colors.grey.shade400),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.apartment, size: smallFont + 4, color: Colors.black87),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  "Possession :  ${property.possession}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: smallFont,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          property.priceRange.isNotEmpty
                              ? property.priceRange
                              : "Price on Request",
                          style: TextStyle(
                            fontSize: smallFont + 2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}





Widget _buildPremiumBannerItem6(BuildContext context, LifestyleProperty property) {
  double screenWidth = MediaQuery.of(context).size.width;
  double baseFontSize = screenWidth * 0.035;
  double containerHeight = screenWidth * 1.05;
  double imageHeight = screenWidth * 0.65;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: property.slug,
            propertyTitle: property.title,
            builderName: property.byLabel,
            imageUrl: property.validatedImageUrl,
            builderLogo: property.logo,
          ),
        ),
      );
    },
    child: Material(
      borderRadius: BorderRadius.circular(40),
      color: Colors.transparent,
      child: Container(
        width: screenWidth * 0.85,
        height: containerHeight + 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 119, 176, 212),
            width: 1,
          ),
          color: const Color.fromARGB(255, 144, 213, 255).withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Top: title, builder, and price
            Positioned(
              top: 2,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      fontSize: baseFontSize * 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    property.byLabel,
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    property.priceRange.isNotEmpty ? property.priceRange : "Price on request",
                    style: TextStyle(
                      fontSize: baseFontSize * 1.15,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Image block
            Positioned(
              top: screenWidth * 0.19,
              left: 8,
              right: 8,
              child: Stack(
                children: [
                  Container(
                    height: imageHeight - 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: property.validatedImageUrl.startsWith("http")
                          ? Image.network(
                              property.validatedImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/images/default.png",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/images/default.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  // Gradient overlay
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Property Type & Location
                  Positioned(
                    bottom: 24,
                    left: 40,
                    child: Row(
                      children: [
                        const Icon(Icons.bed, color: Colors.white, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          property.bhk,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseFontSize * 0.9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 85),
                        const Icon(Icons.location_on, color: Colors.white, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          property.location,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseFontSize * 0.85,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Favorite icon
            Positioned(
              top: screenWidth * 0.22,
              right: 28,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: const Icon(Icons.favorite_border, size: 18, color: Colors.red),
              ),
            ),

            // Possession badge (outside image)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "Possession :  ${property.possession}",
                    style: TextStyle(
                      fontSize: baseFontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
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






Widget _buildEditorBanner(BuildContext context, ReadyToMoveProperty deal) {
  double screenWidth = MediaQuery.of(context).size.width;
  double width = screenWidth * 0.78;
  double height = width * 1.07;
  double fontSize = screenWidth * 0.042;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: deal.slug,
            propertyTitle: deal.title,
            builderName: deal.byLabel,
            imageUrl: "${AppConstants.baseUrl1}/${deal.imageUrl}",
            builderLogo: deal.logo,
          ),
        ),
      );
    },
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage("${AppConstants.baseUrl1}/${deal.imageUrl}"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Favourite Icon
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),

          // Property Details
          Positioned(
            bottom: 10,
            left: 12,
            right: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${deal.title} ",
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: deal.byLabel,
                        style: TextStyle(
                          fontSize: fontSize * 0.9,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  "Possession :  ${deal.possession}",
                  style: TextStyle(color: Colors.white70, fontSize: fontSize * 0.85),
                ),
                const SizedBox(height: 2),

                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        deal.location,
                        style: TextStyle(color: Colors.white, fontSize: fontSize * 0.85),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.king_bed, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        deal.bhk,
                        style: TextStyle(color: Colors.white, fontSize: fontSize * 0.85),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                Text(
                  deal.priceRange,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 215, 99, 70),
                  ),
                ),
              ],
            ),
          ),

          // Arrow Icon
          Positioned(
            bottom: 15,
            right: 10,
            child: Container(
              width: 32,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    ),
  );
}








Widget _buildPremiumBannerItem8(BuildContext context, LimelightProperty deal) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardHeight = screenWidth * 0.55;
  double baseFontSize = screenWidth * 0.033;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: deal.slug,
            propertyTitle: deal.title,
            builderName: deal.byLabel,
            imageUrl: deal.validatedImageUrl,
            builderLogo: deal.validatedLogoUrl,
          ),
        ),
      );
    },
    child: Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: screenWidth > 600 ? 500 : screenWidth * 0.85,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryGreen, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Left Image + Logo
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Image.network(
                      deal.validatedImageUrl,
                      width: screenWidth * 0.45,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            deal.validatedLogoUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deal.title,
                      style: TextStyle(
                        fontSize: baseFontSize * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(deal.byLabel,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(deal.possession,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: primaryGreen, size: baseFontSize),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(deal.location,
                            style: TextStyle(fontSize: baseFontSize),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(deal.bhk,
                            style: TextStyle(fontSize: baseFontSize),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(deal.priceRange,
                      style: TextStyle(
                        fontSize: baseFontSize * 0.95,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenWidth * 0.007,
                      ),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("View",
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.arrow_forward_ios,
                              size: baseFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}






Widget _buildSponsoredBanner(BuildContext context, SponsoredProperty property) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth * 0.60;
  double imageHeight = cardWidth * 0.72;
  double baseFontSize = screenWidth * 0.035;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: property.slug,
            propertyTitle: property.title,
            builderName: property.byLabel,
            imageUrl: property.validatedImageUrl,
            builderLogo: property.validatedLogoUrl,
          ),
        ),
      );
    },
    child: Container(
      width: cardWidth,
      height: imageHeight + screenWidth * 0.18,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryGreen, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlays
          Stack(
            children: [
              // Main image
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    property.validatedImageUrl,
                    width: cardWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Bottom black fade
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),

              // Profile (top-left)
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      property.validatedLogoUrl,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Availability (top-right)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Possession :  ${property.possession}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: baseFontSize * 0.75,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Title & builder on black fade
              Positioned(
                bottom: 5,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      property.byLabel,
                      style: TextStyle(
                        fontSize: baseFontSize * 0.82,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Details section (white background)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
                vertical: screenWidth * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & property type
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black, size: baseFontSize * 0.9),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(
                            fontSize: baseFontSize * 0.85,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.king_bed, color: Colors.black, size: baseFontSize * 0.9),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.bhk,
                          style: TextStyle(
                            fontSize: baseFontSize * 0.85,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Price capsule + Forward icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          property.priceRange,
                          style: TextStyle(
                            fontSize: baseFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: baseFontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}






Widget _buildLocalityBannerFromModel(BuildContext context, HotLocality locality) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double cardWidth = screenWidth * 0.60;
  final double imageHeight = cardWidth * 0.52;
  final double fontSize = screenWidth * 0.032;

  return Container(
    width: cardWidth,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🌆 Image with overlay
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Stack(
            children: [
              Image.network(
                locality.validatedImageUrl,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Text(
                  locality.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize * 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // 📄 Description and CTA
        Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locality.shortDescription,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // View More Button + Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _navigateToLocality(context, locality.slug),
                    child: Text(
                      "View More",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToLocality(context, locality.slug),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.015),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: fontSize * 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


void _navigateToLocality(BuildContext context, String slug) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => HotLocalitiesPage(slug: slug), // ⬅ Pass slug to detail screen
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
              child: child,
            ),
          ),
        );
      },
    ),
  );
}




Widget _buildPremiumBannerType11(BuildContext context) {
  List<Map<String, String>> propertyNews = [
    {
      "image": "assets/images/news1.jpg",
      "title": "Popular areas to rent apartments and Apartments in Hyderabad city",
      "category": "MARKET TRENDS",
      "date": "Posted on 1 Feb 2025",
    },
    {
      "image": "assets/images/news1.jpg",
      "title": "Real estate investments in 2025: What to expect?",
      "category": "INVESTMENT TIPS",
      "date": "Posted on 15 Jan 2025",
    },
    {
      "image": "assets/images/news1.jpg",
      "title": "Government policies shaping the real estate sector",
      "category": "POLICY UPDATES",
      "date": "Posted on 5 Jan 2025",
    },
  ];

  final double screenWidth = MediaQuery.of(context).size.width;
  final double titleFontSize = screenWidth * 0.045;
  final double cardHeight = screenWidth * 0.6;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
        child: Text(
          "Property News",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
          itemCount: propertyNews.length,
          separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.03),
          itemBuilder: (context, index) {
            return _buildNewsBanner(context, propertyNews[index], screenWidth);
          },
        ),
      ),
    ],
  );
}




// **News Banner Card with working context**
Widget _buildNewsBanner(BuildContext context, Map<String, String> newsItem, double screenWidth) {
  final double cardWidth = screenWidth * 0.6;
  final double imageHeight = cardWidth * 0.55;
  final double titleFontSize = screenWidth * 0.035;
  final double dateFontSize = screenWidth * 0.032;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PropertyNewsPage()),
      );
    },
    child: Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              newsItem["image"] ?? '',
              width: double.infinity,
              height: imageHeight.isFinite && imageHeight > 0 ? imageHeight : 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem["title"] ?? '',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  newsItem["date"] ?? '',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: dateFontSize,
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
    ),
  );
}


Widget _buildSectionType21(BuildContext context) {
  List<Map<String, dynamic>> supportItems = [
    {
      "icon": "assets/images/emi.jpg",
      "title": "EMI\nCalculator",
       "backgroundColor": Color.fromARGB(255, 115, 202, 229),
    },
    {
      "icon": "assets/images/assistance.jpg",
      "title": "Get property assistance from proser",
       "backgroundColor": Color.fromARGB(255, 176, 229, 115),
    },
    {
      "icon": "assets/images/policy.jpg",
      "title": "Policy & Legal Guide",
       "backgroundColor": Colors.black12,
    },
  ];

  double cardWidth = MediaQuery.of(context).size.width / 2.4;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Help and Support",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: supportItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = supportItems[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const MortgageCalculatorSheet(),
                    );
                  }
                },
child: Container(
  width: cardWidth,
  decoration: BoxDecoration(
    color: item["backgroundColor"] ?? Colors.white,  // <-- Changed here
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Top content (title + button)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item["title"] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
            ),
          ],
        ),
      ),

      const Spacer(),

      // Image fixed at bottom
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(80),
        ),
        child: Image.asset(
          item["icon"] ?? '',
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    ],
  ),
),


              );
            },
          ),
        ),
      ],
    ),
  );
}




class MortgageCalculatorSheet extends StatefulWidget {
  const MortgageCalculatorSheet({Key? key}) : super(key: key);

  @override
  State<MortgageCalculatorSheet> createState() => _MortgageCalculatorSheetState();
}

class _MortgageCalculatorSheetState extends State<MortgageCalculatorSheet> {
  double downPayment = 10000000;
  double tenure = 15;
  double interestRate = 10;
  double totalAmount = 25000000;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    double monthlyEMI = _calculateEMI();
    double payableInterest = (monthlyEMI * tenure * 12) - (totalAmount - downPayment);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: showResult ? _buildResultView(monthlyEMI, payableInterest) : _buildInputView(),
      ),
    );
  }

  Widget _buildInputView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mortgage Calculator", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Principle Amount: ₹2,50,00,000", style: TextStyle(color: primaryGreen, fontSize: 16)),
        const SizedBox(height: 10),

        // Down Payment
        _buildSliderCard("DOWN PAYMENT", downPayment, 500000, 25000000, (val) {
          setState(() => downPayment = val);
        }),

        const SizedBox(height: 3),

        // Tenure
        _buildSliderCard("TENURE", tenure, 1, 30, (val) {
          setState(() => tenure = val);
        }, unit: "Yrs"),

        const SizedBox(height: 7),

        // Interest
        _buildSliderCard("Rate of interest (p.a)", interestRate, 0, 26, (val) {
          setState(() => interestRate = val);
        }, unit: "%"),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: () => setState(() => showResult = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
  "CALCULATE MORTGAGE",
  style: TextStyle(
    color: Colors.white, // ✅ Set text color to white
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSliderCard(String title, double value, double min, double max, Function(double) onChanged, {String unit = ""}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${unit.isNotEmpty ? value.toStringAsFixed(0) + unit : '₹${_formatAmount(value)}'}",
                style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(double emi, double interest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Total Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("₹${_formatAmount(totalAmount)}", style: const TextStyle(fontSize: 24, color: Colors.black)),
        const SizedBox(height: 20),

        _buildBreakdownRow("Principal Amount", totalAmount - downPayment),
        _buildBreakdownRow("Payable Interest", interest),
        _buildBreakdownRow("Down payment", downPayment),
        _buildBreakdownRow("Monthly EMI", emi),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => setState(() => showResult = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
  "RESET",
  style: TextStyle(
    color: Colors.white, // ✅ Set text color to white
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("₹${_formatAmount(value)}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _calculateEMI() {
    double loanAmount = totalAmount - downPayment;
    double monthlyRate = interestRate / (12 * 100);
    int months = (tenure * 12).toInt();
    return loanAmount * monthlyRate * pow((1 + monthlyRate), months) /
        (pow((1 + monthlyRate), months) - 1);
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{2})+(?!\d))'), (match) => ",");
  }
}



class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: "$title\n",
          style:
              const TextStyle(color: Colors.white70, fontSize: 13, height: 1.2),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}



class DualCornerCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start top-left
    path.lineTo(0, size.height - 60);

    // 👈 Left inward curve (concave)
    path.quadraticBezierTo(
      0, size.height, // control point
      50, size.height, // end point
    );

    // Draw straight line to before right curve
    path.lineTo(size.width - 60, size.height);

    // 👉 Right outward curve (convex)
    path.quadraticBezierTo(
      size.width + 30, size.height + 30, // control
      size.width, size.height - 10, // end
    );

    // Right edge to top
    path.lineTo(size.width, 0);

    // Back to start
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}



Widget curvedShimmer({double? width, double? height, double borderRadius = 16}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width ?? double.infinity,
      height: height ?? 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}
