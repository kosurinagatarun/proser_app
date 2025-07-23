import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:proser/api/category_API/ProjectCategory.dart';
import 'package:proser/api/category_API/ProjectCategoryService.dart';
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/components/constant.dart';
import 'package:proser/screens/components/filter.dart';
import 'package:proser/screens/components/viewAllPage.dart';
import 'package:proser/screens/navigation_screen.dart';
import 'package:proser/screens/search/MapPropertyScreen.dart';
import 'package:proser/screens/search/property_location_model.dart';
import 'package:proser/screens/search/property_location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proser/utils/color.dart';
import 'package:proser/screens/Profile/profile_screen.dart';
//import 'package:dots_indicator/dots_indicator.dart';
import 'package:animations/animations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/search/search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sortOptions = [
      "Popularity",
      "Price per sq.ft - High to Low",
      "Price per sq.ft - Low to High",
      "Possession - Earliest to Furthest",
      "Possession - Furthest to Earliest",
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Sort By",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...sortOptions.map((option) => ListTile(
                title: Text(option, style: const TextStyle(fontSize: 15)),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}

class PropertyByLocation extends StatefulWidget {
  final String location;

  const PropertyByLocation({Key? key, required this.location}) : super(key: key);

  @override
  _PropertyByLocationState createState() => _PropertyByLocationState();
}

class _PropertyByLocationState extends State<PropertyByLocation> {
  late PageController _pageController1;
  int _currentPage1 = 0;
  late ScrollController _scrollController;
  bool _isCategoryVisible = true;
  double _lastOffset = 0;

  late Future<List<LocationPremiumBanner2>> _locationPremiumBanner2Future;
  late Future<List<LocationPremiumBanner2>>? _locationPremiumBanner8Future;
  late Future<List<LocationPremiumBanner2>> _locationPremiumBanner9Future;
  late Future<List<LocationPremiumBanner2>> _locationPremiumBanner12Future;
  late Future<List<NewLaunchProperty>> _newLaunchFuture;
  late Future<List<EditorChoiceLocation>> _editorChoiceFuture;
  late Future<List<UltraLuxuryHome>> _ultraLuxuryFuture;
  TextEditingController searchController = TextEditingController();
List<String> dynamicLocations = [];
List<String> dynamicPincodes = [];
List<Map<String, String>> dynamicProjects = [];
late Future<List<dynamic>> _projectDataFuture;
late Future<List<ProjectCategory>> _projectCategoryFuture;
List<LocationPremiumModel> _allLocationBanners = [];
List<LocationPremiumModel> _filteredLocationBanners = [];
List<String> _categories = [];
String _selectedCategory = '';
late Future<List<AgentPostedProperty>> _agentPostedPropertiesFuture;








  bool _isGridView = false;
  String? _profileImage;
  List<LocationPremiumModel> _locationBanners = [];
  bool _loadingBanners = true;
  bool shouldShowBannerType(String targetLocation) {
  return _locationBanners.any((b) =>
      b.location.toLowerCase() == targetLocation.toLowerCase());
}




  @override
  void initState() {
    super.initState();
    _pageController1 = PageController();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _loadProfileImage();
    _fetchLocationBanners();
    _locationPremiumBanner2Future = LocationPremiumService1
      .fetchByLocation(widget.location)
      .then((list) => list
          ..sort((a, b) => a.order.compareTo(b.order)) // sort by order
          ..length = list.length > 4 ? 4 : list.length);

    _locationPremiumBanner8Future = LocationPremiumService1.fetchByLocation(widget.location);
    _locationPremiumBanner9Future = LocationPremiumService1.fetchByLocation(widget.location);
    _locationPremiumBanner12Future = LocationPremiumService1.fetchByLocation(widget.location);
    _newLaunchFuture = NewLaunchService.fetchByLocation(widget.location);
    _editorChoiceFuture = EditorChoiceService.fetchByLocation(widget.location);
    _ultraLuxuryFuture = UltraLuxuryHomeService.fetchByLocation(widget.location);
    _projectDataFuture = fetchProjectData();
    _projectCategoryFuture = ProjectCategoryService.fetchCategories();
    _agentPostedPropertiesFuture = AgentPropertyService.fetchAgentPostedProperties();


  }

  Future<List<dynamic>> fetchProjectData() async {
  final response = await http.get(Uri.parse(
    "${AppConstants.baseUrl1}/api/v1/projects/apartment-buy",
  ));

  final decoded = jsonDecode(response.body);
  if (decoded['success'] == true) {
    return decoded['data'];
  } else {
    throw Exception("Failed to fetch project data");
  }
}




void onLocationSelected(String location) {
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => NavigationScreen(
      selectedIndex: 1,
      initialPageType: location,
    ),
  ),
);

}

  void _handleScroll() {
    if (_scrollController.offset > _lastOffset && _isCategoryVisible) {
      setState(() => _isCategoryVisible = false);
    } else if (_scrollController.offset < _lastOffset && !_isCategoryVisible) {
      setState(() => _isCategoryVisible = true);
    }
    _lastOffset = _scrollController.offset;
  }

Future<void> _fetchLocationBanners() async {
  try {
    final banners = await LocationPremiumService.fetchByLocation(widget.location);
    setState(() {
      _locationBanners = banners;
      _loadingBanners = false;
    });
  } catch (e) {
    setState(() => _loadingBanners = false);
    debugPrint("Banner fetch error: $e");
  }
}


  @override
  void dispose() {
    _pageController1.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImage = prefs.getString('profile_image') ?? 'assets/images/profile.png';
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Pinned AppBar
            SliverPersistentHeader(
              pinned: true,
              delegate: _CustomSearchAppBarDelegate(
                child: CustomSearchAppBar(
                  location: widget.location,
                  onBack: () => Navigator.pop(context),
                  onFilter: () {},
                  onClearLocation: () {},
                  onProfileTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                    _loadProfileImage();
                  },
                  profileImage: _profileImage ?? 'assets/images/profile.png',
                ),
              ),
            ),

            // Floating Category Section
            SliverPersistentHeader(
              floating: false,
              delegate: _FloatingCategoryHeaderDelegate(
                minExtent: 120,
                maxExtent: 120,
                child: ClipPath(
                  clipper: DualCornerCurveClipper(),
                  child: Container(
                    color: primaryGreen,
                    padding: const EdgeInsets.only(left: 12, bottom: 15),
                    child: _buildCategorySection1(context),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(child: _buildPremiumBannerType1(context)),
            SliverToBoxAdapter(child: _buildFilterRow()),
            SliverToBoxAdapter(child: const SizedBox(height: 6)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType2(context, _isGridView)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType3(context)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType4(context)),

            //SliverToBoxAdapter(child: _buildCategorySection2(context)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType5(context)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType6(context)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType8(context, _isGridView)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType9(context, _isGridView)),

            //SliverToBoxAdapter(child: _buildCategorySection5()),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType10()),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType11()),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType12(context, _isGridView)),

            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(
  child: FutureBuilder<List<dynamic>>(
    future: _projectDataFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("Error loading projects")),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("No projects available")),
        );
      }

      return _buildPremiumBannerType13(snapshot.data!, onLocationSelected);
    },
  ),
),


            if (shouldShowBannerType(widget.location))
              SliverToBoxAdapter(child: _buildPremiumBannerType14(context)),

            SliverToBoxAdapter(child: _buildSectionServiceType21(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
          ],
        ),

        // Floating Bottom Bar
        Positioned(
          bottom: 30,
          left: MediaQuery.of(context).size.width * 0.28,
          right: MediaQuery.of(context).size.width * 0.28,
          child: _buildBottomFloatingSortMapBar(context),
        ),
      ],
    ),
  );
}


Widget _buildBottomFloatingSortMapBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapPropertyScreen(location: widget.location),
    ),
  );
},

          child: Row(
            children: const [
              Icon(Icons.map, size: 18, color: primaryGreen),
              SizedBox(width: 4),
              Text("Map", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          height: 20,
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => const SortBottomSheet(),
            );
          },
          child: Row(
            children: const [
              Icon(Icons.sort, size: 18, color: primaryGreen),
              SizedBox(width: 4),
              Text("Sort", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildFilterRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown("Filter", ["With Loan", "Immediate", "Offers"]),
                _buildFilterDropdown("Sort By", ["Low to High", "High to Low", "Newest"]),
                _buildFilterDropdown("Property Type", ["Apartments", "Villas", "Plots"]),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Grid/List toggle
        Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.grey.shade300),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade200,
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: () => setState(() => _isGridView = true),
        child: Icon(
          Icons.grid_view,
          size: 24,
          color: _isGridView ? primaryGreen : Colors.grey,
        ),
      ),
      SizedBox(width: 4),
      Container(
        width: 1,
        height: 14,
        color: Colors.grey.shade300,
      ),
      SizedBox(width: 4),
      GestureDetector(
        onTap: () => setState(() => _isGridView = false),
        child: Icon(
          Icons.list,
          size: 24,
          color: !_isGridView ? primaryGreen : Colors.grey,
        ),
      ),
    ],
  ),
)

      ],
    ),
  );
}


Widget _buildFilterDropdown(String label, List<String> options) {
  String? selectedValue;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(right: 5),
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 2, offset: Offset(0, 2)),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            hint: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            icon: const Icon(Icons.arrow_drop_down, size: 18),
            style: const TextStyle(color: Colors.black, fontSize: 12),
            isExpanded: false, // Make sure it's not stretched
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
        ),
      );
    },
  );
}

Widget _buildCategorySection1(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return FutureBuilder<List<ProjectCategory>>(
    future: _projectCategoryFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
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
              ...categories.map((item) =>
                  _buildGreyContainerChipNetwork(context, item.name, item.image)).toList(),
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

Widget _buildGreyContainerChipNetwork(BuildContext context, String title, String imageUrl) {
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

    
  // ✅ Premium Banner with Dots Indicator
Widget _buildPremiumBannerType1(BuildContext context) {
  if (_locationBanners.isEmpty) return const SizedBox();

  double screenWidth = MediaQuery.of(context).size.width;
  double baseFontSize = screenWidth * 0.035;
  double cardHeight = screenWidth * 0.71;

  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: cardHeight,
            child: PageView.builder(
              controller: _pageController1,
              itemCount: _locationBanners.length,
              onPageChanged: (index) {
                setState(() => _currentPage1 = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildEditorChoiceBannerFromModel(
                    context,
                    _locationBanners[index],
                    screenWidth,
                    baseFontSize,
                  ),
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
                  children: List.generate(_locationBanners.length, (index) {
                    final isActive = _currentPage1 == index;
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
                  '${_currentPage1 + 1} / ${_locationBanners.length}',
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
  });
}




Widget _buildEditorChoiceBannerFromModel(
  BuildContext context,
  LocationPremiumModel model,
  double screenWidth,
  double baseFontSize,
) {
  double cardWidth = screenWidth * 0.93;
  double cardHeight = cardWidth * 0.85;
  double imageHeight = cardHeight * 0.70;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: model.slug,
            propertyTitle: model.title,
            builderName: model.byLabel,
            imageUrl: model.imageUrl,
            builderLogo: model.logo,
          ),
        ),
      );
    },
    child: Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(246, 103, 179, 166),
            Color.fromARGB(246, 218, 200, 169),
           // Color.fromARGB(246, 253, 169, 144),
            Color.fromARGB(246, 61, 109, 133),
          ],
          stops: [0.0, 0.4, 0.7],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        model.imageUrl,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
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
                      left: 10,
                      right: 10,
                      bottom: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: baseFontSize * 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            model.byLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: baseFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 5,
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: baseFontSize),
                          const SizedBox(width: 4),
                          Text(
                            model.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: baseFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(Icons.favorite_border, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              // Availability & Type
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12, right: 12, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.possession ?? 'Ongoing Project',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 64, 63, 63),
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.home, color: const Color.fromARGB(255, 46, 46, 46), size: baseFontSize),
                        const SizedBox(width: 4),
                        Text(
                          model.bhk,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 43, 42, 42),
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Center(
                  child: Text(
                    model.priceRange,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 38, 38, 38),
                      fontSize: baseFontSize * 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Arrow button
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: baseFontSize * 2,
              height: baseFontSize * 1.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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







// ✅ Premium Banner Section with Toggle for Grid/List View

Widget _buildPremiumBannerType2(BuildContext context, bool isGridView) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double baseFontSize = screenWidth * 0.032;

  return FutureBuilder<List<LocationPremiumBanner2>>(
    future: _locationPremiumBanner2Future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading banners"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox();
      }

      final properties = snapshot.data!
          .where((prop) => prop.imageUrl.isNotEmpty)
          .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

      final visibleProperties = properties.take(4).toList();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 600),
          reverse: !isGridView,
          transitionBuilder: (
            Widget child,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: isGridView
              ? Column(
                  key: const ValueKey('grid'),
                  children: [
                    Wrap(
                      spacing: screenWidth * 0.02,
                      runSpacing: screenHeight * 0.025,
                      children: visibleProperties.map((prop) {
                        return SizedBox(
                          width: (screenWidth - screenWidth * 0.07) / 2,
                          child: _buildGridPropertyCard(
                            context,
                            {
                              "image": prop.imageUrl,
                              "title": prop.title,
                              "builder": prop.byLabel,
                              "availability": prop.possession ?? '',
                              "location": prop.location,
                              "bhk": prop.bhk,
                              "price": prop.priceRange,
                              "slug": prop.slug,
                            },
                            baseFontSize,
                            screenHeight,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('list'),
                  children: visibleProperties.map((prop) {
                    return _buildListPropertyCard(
                      context,
                      {
                        "image": prop.imageUrl,
                        "title": prop.title,
                        "builder": prop.byLabel,
                        "availability": prop.possession ?? '',
                        "location": prop.location,
                        "bhk": prop.bhk,
                        "price": prop.priceRange,
                        "slug": prop.slug,
                      },
                      baseFontSize,
                      screenWidth,
                      screenHeight,
                    );
                  }).toList(),
                ),
        ),
      );
    },
  );
}



Widget _buildGridPropertyCard(BuildContext context, Map<String, String> property, double baseFontSize, double screenHeight) {
  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PropertyScreen(
        slug: property["slug"] ?? '',
        propertyTitle: property["title"] ?? '',
        builderName: property["builder"] ?? '',
        imageUrl: property["image"] ?? '',
        builderLogo: property["logo"] ?? '',
      ),
    ),
  );
},

  child : Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          child: Stack(
            children: [
              Image.network(
                property["image"]!,
                width: double.infinity,
                height: screenHeight * 0.2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "starts @ ${property["price"]!}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: baseFontSize * 0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property["title"]!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: baseFontSize * 1.1, fontWeight: FontWeight.bold),
              ),
              Text(
                "By ${property["builder"]}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: baseFontSize, color: Colors.grey),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, color: primaryGreen, size: baseFontSize),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      property["location"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      property["bhk"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Icon(Icons.phone, color: Colors.white, size: baseFontSize),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          child: Center(
            child: Text(
              property["availability"]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: baseFontSize),
            ),
          ),
        ),
      ],
    ),
  ));
}



// ✅ List Property Card UI (For Non-Grid View)
Widget _buildListPropertyCard(BuildContext context, Map<String, String> property, double baseFontSize, double screenWidth, double screenHeight) {
  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PropertyScreen(
        slug: property["slug"] ?? '',
        propertyTitle: property["title"] ?? '',
        builderName: property["builder"] ?? '',
        imageUrl: property["image"] ?? '',
        builderLogo: property["logo"] ?? '',
      ),
    ),
  );
},
  child: Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(
                property["image"]!,
                width: double.infinity,
                height: screenHeight * 0.18,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
              ),
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
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property["title"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: baseFontSize * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "By ${property["builder"]!}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: baseFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 15,
                right: 20,
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                    SizedBox(width: 4),
                    Text(
                      property["location"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: baseFontSize * 0.9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.apartment, color: Colors.grey),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                    SizedBox(width: 5),
                    Text(
                      property["bhk"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Text("|"),
                    SizedBox(width: 10),
                    Text(
                      property["availability"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: baseFontSize, color: primaryGreen, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  property["price"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: baseFontSize),
                ),
              ),
              SizedBox(width: screenWidth * 0.1),
              Container(
                  width: 35,
  height: 35,
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8)),
                //padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.3),
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
      size: baseFontSize * 1.2,
    ),
  ),
),
SizedBox(width: 10),
              Container(
                  width: 35,
  height: 35,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Icon(Icons.phone, color: Colors.white, size: baseFontSize * 1.3),
              ),
              
              

            ],
          ),
        ),
      ],
    ),
  ));
}




Widget _buildPremiumBannerType3(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double baseFontSize = screenWidth * 0.034;

  return FutureBuilder<List<EditorChoiceLocation>>(
    future: _editorChoiceFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox(); // or error placeholder
      }

      final items = snapshot.data!;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        padding: const EdgeInsets.only(bottom: 15, top: 8),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 167, 152),
        ),
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
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: screenHeight * 0.27,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    width: screenWidth * 0.92,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Banner
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.network(
                                  item.imageUrl,
                                  width: double.infinity,
                                  height: screenHeight * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 14,
                                right: 14,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: baseFontSize * 1.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.byLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: baseFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item.possession != null)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      item.possession ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: baseFontSize * 0.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Image.network(item.logo, fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Details
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: primaryGreen, size: baseFontSize),
                                          const SizedBox(width: 5),
                                          Text(
                                            item.location,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: baseFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                                          const SizedBox(width: 5),
                                          Text(
                                            item.bhk.isNotEmpty ? item.bhk : item.bhkSize,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: baseFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Center(
                                    child: Text(
                                      item.priceRange,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: baseFontSize * 1.15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 15,
                              child: Container(
                                width: baseFontSize * 2.4,
                                height: baseFontSize * 1.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: baseFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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
  double screenWidth = MediaQuery.of(context).size.width;
  double baseFontSize = screenWidth * 0.032;
  double cardWidth = screenWidth * 0.85;
  double imageHeight = cardWidth * 0.59;

  return FutureBuilder<List<UltraLuxuryHome>>(
    future: _ultraLuxuryFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error loading data'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox(); // or fallback UI
      }

      final items = snapshot.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 15),
            child: Text(
              "Ultra Luxury Homes",
              style: TextStyle(fontSize: baseFontSize * 1.3, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: imageHeight * 1.47,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              itemBuilder: (context, index) {
                final item = items[index];

                final priceParts = item.priceRange.split(" - ");
                final minPrice = priceParts.first;
                final maxPrice = priceParts.length > 1 ? priceParts.last : '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyScreen(
                          slug: item.slug,
                          propertyTitle: item.title,
                          builderName: item.byLabel,
                          imageUrl:  item.imageUrl,
                          builderLogo:  item.logo,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(right: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.network(
                                   item.imageUrl,
                                  width: cardWidth - 12,
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 12,
                                right: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: baseFontSize * 1.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.byLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: baseFontSize * 0.9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 14,
                                right: 12,
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                                    SizedBox(width: 4),
                                    Text(
                                      item.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: baseFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.favorite_border, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.network(
            item.logo,
            fit: BoxFit.contain,
          ),
        ),
      ),
      SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
              SizedBox(width: 5),
              Text(
                item.bhk,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Text("|"),
              SizedBox(width: 10),
              Text(
                item.possession ?? 'Possession soon',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),
SizedBox(height: 5),
Padding(
  padding: EdgeInsets.only(left: 50),
  child: Row(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 6),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$minPrice - $maxPrice",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: baseFontSize,
          ),
        ),
      ),
      SizedBox(width: screenWidth * 0.1),
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.3),
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
      size: baseFontSize * 1.2,
    ),
  ),
),
SizedBox(width: 10),
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.phone, color: Colors.white, size: baseFontSize * 1.3),
      ),
    ],
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
      );
    },
  );
}






// Widget _buildCategorySection2(BuildContext context) {
//   final List<String> bhkOptions = [
//     '1 BHK',
//     '2 BHK',
//     '3 BHK',
//     '4 BHK',
//     '5 BHK',
//     '5+ BHK',
//   ];

//   Set<String> selectedOptions =
//       {}; // Manage this in StatefulWidget for interactivity

//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double baseFontSize = screenWidth * 0.035;
//   final double buttonWidth = screenWidth * 0.2;

//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 0, vertical: screenWidth * 0.02),
//     padding: EdgeInsets.all(screenWidth * 0.03),
//     decoration: BoxDecoration(
//       color: Colors.grey[200],
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Filter By BHK",
//           style: TextStyle(
//             fontSize: baseFontSize * 1.1,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: screenWidth * 0.02),

//         // Scrollable BHK Options
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: bhkOptions.map((option) {
//               final isSelected = selectedOptions.contains(option);
//               return Padding(
//                 padding: EdgeInsets.only(right: screenWidth * 0.02),
//                 child: GestureDetector(
//                   onTap: () {
//                     // Update state logic
//                     if (isSelected) {
//                       selectedOptions.remove(option);
//                     } else {
//                       selectedOptions.add(option);
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenWidth * 0.01),
//                     decoration: BoxDecoration(
//                       color: isSelected ? primaryGreen : Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(color: Colors.grey.shade400),
//                     ),
//                     child: Text(
//                       option,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: baseFontSize,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),

//         SizedBox(height: screenWidth * 0.02),

//         // Apply Button (Fixed)
//         Align(
//           alignment: Alignment.centerRight,
//           child: ElevatedButton(
//             onPressed: () {
//               // TODO: Apply filter logic
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2E5077), // Deep blue
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.01),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50), // Capsule shape
//               ),
//               elevation: 1,
//               minimumSize: Size(buttonWidth, 30), // Adjusted button width and height
//             ),
//             child: Text(
//               "Apply",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: baseFontSize * 0.9,
//                 letterSpacing: 0.3,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


Widget _buildPremiumBannerType5(BuildContext context) {
  return FutureBuilder<List<NewLaunchProperty>>(
    future: _newLaunchFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading new launches."));
      }

      final List<NewLaunchProperty> properties = snapshot.data ?? [];

      if (properties.isEmpty) {
        return const SizedBox(); // or show "No properties"
      }

      final screenWidth = MediaQuery.of(context).size.width;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "New Launches",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: screenWidth * 0.69,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final prop = properties[index];
                  return _buildPremiumBannerItem5(context, prop);
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPremiumBannerItem5(BuildContext context, NewLaunchProperty prop) {
  final screenWidth = MediaQuery.of(context).size.width;
  final cardHeight = screenWidth * 0.54;
  final baseFontSize = screenWidth * 0.032;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: prop.slug,
            propertyTitle: prop.title,
            builderName: prop.companyName,
            imageUrl: prop.imageUrl,
            builderLogo: prop.companyLogo,
          ),
        ),
      );
    },
    child: Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: screenWidth > 600 ? 500 : screenWidth * 0.93,
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: cardHeight + 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                    backgroundImage: NetworkImage(prop.companyLogo),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    prop.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: baseFontSize * 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Main content
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      prop.imageUrl,
                      width: screenWidth * 0.45,
                      height: cardHeight * 0.872,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIconTextRow(Icons.location_on, prop.location, baseFontSize),
                        const SizedBox(height: 8),
                        _buildIconTextRow(Icons.king_bed, prop.bhk.isNotEmpty ? prop.bhk : prop.bhkSize, baseFontSize),
                        const SizedBox(height: 8),
                        Text(
                          prop.priceRange,
                          style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          prop.possession ?? 'Under Construction',
                          style: TextStyle(fontSize: baseFontSize, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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


Widget _buildPremiumBannerType6(BuildContext context) {
  return FutureBuilder<List<AgentPostedProperty>>(
    future: _agentPostedPropertiesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading agent properties."));
      }

      final List<AgentPostedProperty> properties = snapshot.data ?? [];

      if (properties.isEmpty) {
        return const SizedBox(); // or show "No properties"
      }

      double screenWidth = MediaQuery.of(context).size.width;
      double baseFontSize = screenWidth * 0.035;
      double cardHeight = screenWidth * 0.7;

      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Properties posted by Agents",
                    style: TextStyle(
                      fontSize: baseFontSize * 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AgentPropertiesViewAllPage(),
    ),
  );
},

                    child: Text(
                      "View all",
                      style: TextStyle(
                        fontSize: baseFontSize,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final item = {
                    "image": properties[index].imageUrl,
                    "logo": properties[index].logo,
                    "title": properties[index].title,
                    "builder": properties[index].companyName,
                    "availability": properties[index].possession,
                    "location": properties[index].location,
                    "bhk": properties[index].bhk,
                    "priceRange": properties[index].priceRange,
                  };

                  return _buildAgentBannerCard(
                    context,
                    item,
                    screenWidth,
                    baseFontSize,
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildAgentBannerCard(
  BuildContext context,
  Map<String, String> item,
  double screenWidth,
  double baseFontSize,
) {
  double cardWidth = screenWidth * 0.9;
  double imageHeight = cardWidth * 0.52;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyScreen(
            slug: item["slug"] ?? '',
            propertyTitle: item["title"] ?? '',
            builderName: item["builder"] ?? '',
            imageUrl: item["image"] ?? '',
            builderLogo: item["logo"] ?? '',
          ),
        ),
      );
    },
    child: Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.network(
                  item["image"] ?? '',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: imageHeight,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),
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
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: baseFontSize * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "By ${item["builder"] ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: baseFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 20,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                      const SizedBox(width: 4),
                      Text(
                        item["location"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: baseFontSize * 0.9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: item["logo"] != null && item["logo"]!.isNotEmpty
                    ? NetworkImage(item["logo"]!)
                    : null,
                child: item["logo"] == null || item["logo"]!.isEmpty
                    ? const Icon(Icons.apartment, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                      const SizedBox(width: 5),
                      Text(
                        item["bhk"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      const Text("|"),
                      const SizedBox(width: 10),
                      Text(
                        item["availability"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: baseFontSize,
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item["priceRange"] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: baseFontSize,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.3),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: baseFontSize * 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.phone, color: Colors.white, size: baseFontSize * 1.3),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}





// Widget _buildPremiumBannerType7() {
//   List<Map<String, String>> resaleProperties = [
//     {
//       "image": "assets/images/property3.jpg",
//       "price": "₹ 2,00,00,000",
//       "details": "3 BHK Flat for Sale - 2300 sq.ft.",
//       "location": "Myhome Mangala, Tellapur, Hyderabad",
//       "posted": "10 days ago",
//       "tag1": "Gymnasium",
//       "tag2": "Utility Shop",
//     },
//     {
//       "image": "assets/images/property4.jpg",
//       "price": "₹ 1,75,00,000",
//       "details": "2 BHK Flat for Sale - 1850 sq.ft.",
//       "location": "Aparna Cyberzon, Gachibowli, Hyderabad",
//       "posted": "7 days ago",
//       "tag1": "Swimming Pool",
//       "tag2": "Clubhouse",
//     },
//     {
//       "image": "assets/images/property5.jpg",
//       "price": "₹ 1,25,00,000",
//       "details": "2 BHK Flat for Sale - 1600 sq.ft.",
//       "location": "SMR Vinay, Kondapur, Hyderabad",
//       "posted": "3 days ago",
//       "tag1": "Children Park",
//       "tag2": "Power Backup",
//     },
//   ];

//   PageController _pageController = PageController(viewportFraction: 0.95);
//   int _currentPage = 0;

//   return StatefulBuilder(
//     builder: (context, setState) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title Row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Resale properties in this location",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text("view all",
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple)),
//               ],
//             ),
//           ),
//           //SizedBox(height: 5),

//           // PageView with resale cards
//           Container(
//             height: 370,
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: resaleProperties.length,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               itemBuilder: (context, index) {
//                 final item = resaleProperties[index];
//                 return Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       width: 390,
//                       margin: EdgeInsets.only(right: 15, top: 15),
//                       decoration: BoxDecoration(
//                         border:
//                             Border.all(color: Colors.grey.shade300, width: 1.5),
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(20),
//                           bottomLeft: Radius.circular(20),
//                         ),
//                         color: Colors.white,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Image
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(20),
//                               bottomLeft: Radius.circular(20),
//                             ),
//                             child: Image.asset(
//                               item["image"]!,
//                               width: 403,
//                               height: 203,
//                               fit: BoxFit.cover,
//                             ),
//                           ),

//                           // Content
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(item["price"]!,
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 3),
//                                 Text(item["details"]!,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600)),
//                                 SizedBox(height: 5),
//                                 Text(item["location"]!,
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.grey.shade600)),
//                                 SizedBox(height: 5),
//                                 Text("POSTED ${item["posted"]}",
//                                     style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey.shade500)),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Icon(Icons.fitness_center,
//                                         size: 18, color: Colors.black),
//                                     SizedBox(width: 4),
//                                     Text(item["tag1"]!,
//                                         style: TextStyle(fontSize: 12)),
//                                     SizedBox(width: 20),
//                                     Icon(Icons.store,
//                                         size: 18, color: Colors.orange),
//                                     SizedBox(width: 4),
//                                     Text(item["tag2"]!,
//                                         style: TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Wishlist & Contact buttons
//                     Positioned(
//                       right: 25,
//                       bottom: 40,
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.grey, width: 2),
//                             ),
//                             padding: EdgeInsets.all(6),
//                             child:
//                                 Icon(Icons.favorite_border, color: Colors.red),
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             width: 58,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               color: Colors.deepPurple,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child:
//                                 Icon(Icons.chat, color: Colors.white, size: 20),
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             width: 58,
//                             height: 38,
//                             decoration: BoxDecoration(
//                               color: Colors.lightBlue,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child:
//                                 Icon(Icons.call, color: Colors.white, size: 20),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // ✅ Dots Indicator
//           SizedBox(height: 5),
//           Center(
//             child: DotsIndicator(
//               dotsCount: resaleProperties.length,
//               position: _currentPage.toDouble(),
//               decorator: DotsDecorator(
//                 activeColor: primaryGreen,
//                 size: const Size.square(8.0),
//                 activeSize: const Size(16.0, 8.0),
//                 activeShape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// Widget _buildCategorySection3() {
//   double minValue = 0.0;
//   double maxValue = 20.0;

//   return StatefulBuilder(
//     builder: (context, setState) {
//       return Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         padding: EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title + Subtitle in a Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Filter by Budget",
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   "Slide to set your budget",
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Budget Labels
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Min: ₹${minValue.toStringAsFixed(1)} Cr",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: primaryGreen[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "Max: ₹${maxValue.toStringAsFixed(1)} Cr",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: primaryGreen[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 6),

//             // Slider
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 4,
//                 activeTrackColor: primaryGreen,
//                 inactiveTrackColor: Colors.grey.shade300,
//                 thumbColor: Colors.white,
//                 overlayColor: primaryGreen.withOpacity(0.2),
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
//               ),
//               child: RangeSlider(
//                 min: 0,
//                 max: 20,
//                 divisions: 20,
//                 values: RangeValues(minValue, maxValue),
//                 onChanged: (RangeValues values) {
//                   setState(() {
//                     minValue = values.start;
//                     maxValue = values.end;
//                   });
//                 },
//               ),
//             ),

//             SizedBox(height: 10),

//             // Apply Button
//             Align(
//   alignment: Alignment.centerRight,
//   child: ElevatedButton(
//     onPressed: () {
//       // Apply filter logic
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: primaryGreen.shade600,
//       foregroundColor: Colors.white,
//       elevation: 2,
//       padding: EdgeInsets.symmetric(horizontal: 22, vertical: 3),
//       minimumSize: Size(70, 28), // Thinner size
//       shape: StadiumBorder(), // More rounded capsule
//       shadowColor: primaryGreen.withOpacity(0.3),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.check, size: 14, color: Colors.white),
//         SizedBox(width: 6),
//         Text(
//           "Apply",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 12.5,
//             letterSpacing: 0.6,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     ),
//   ),
// )

//           ],
//         ),
//       );
//     },
//   );
// }


Widget _buildPremiumBannerType8(BuildContext context, bool isGridView) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double baseFontSize = screenWidth * 0.032;

  return FutureBuilder<List<LocationPremiumBanner2>>(
    future: _locationPremiumBanner8Future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading premium banners"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox();
      }

      // ✅ Filter data with order between 4 and 8
      final items = snapshot.data!
          .where((prop) => prop.imageUrl.isNotEmpty && prop.order >= 4 && prop.order <= 8)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      if (items.isEmpty) return const SizedBox();

      if (isGridView) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: screenWidth * 0.02,
            runSpacing: screenHeight * 0.025,
            children: items.map((prop) {
              return SizedBox(
                width: (screenWidth - screenWidth * 0.07) / 2,
                child: _buildGridPropertyCard(
                  context,
                  {
                    "image": prop.imageUrl,
                    "logo": prop.logo,
                    "title": prop.title,
                    "builder": prop.byLabel,
                    "availability": prop.possession ?? '',
                    "location": prop.location,
                    "bhk": prop.bhk,
                    "price": prop.priceRange,
                    "slug": prop.slug,
                  },
                  baseFontSize,
                  screenHeight,
                ),
              );
            }).toList(),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: screenWidth * 0.92,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner image with gradient overlay
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              "${AppConstants.baseUrl1}/${item.imageUrl}",
                              width: screenWidth * 0.92,
                              height: screenHeight * 0.18,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 14,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: baseFontSize * 1.1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "By ${item.byLabel}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: baseFontSize,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 14,
                            bottom: 12,
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                                SizedBox(width: 4),
                                Text(
                                  item.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontSize: baseFontSize),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.favorite_border, color: Colors.red, size: baseFontSize * 1.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Info section
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            backgroundImage: NetworkImage("${AppConstants.baseUrl1}/${item.logo}"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                                SizedBox(width: 6),
                                Text(
                                  item.bhk,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 12),
                                Text("|", style: TextStyle(fontSize: baseFontSize)),
                                SizedBox(width: 12),
                                Icon(Icons.event_available, color: primaryGreen, size: baseFontSize),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.possession ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price + CTA buttons
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 2, right: 16, bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.priceRange,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.2),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: baseFontSize * 1.2),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.call, color: Colors.white, size: baseFontSize * 1.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    },
  );
}





// Widget _buildCategorySection4() {
//   double minValue = 0.0;
//   double maxValue = 5000.0;

//   return StatefulBuilder(
//     builder: (context, setState) {
//       return Container(
//         margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Filter by Area",
//                   style: TextStyle(
//                     fontSize: 14.5,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   "Select range (sq.ft)",
//                   style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),

//             // Area Labels
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${minValue.toInt()} sq.ft",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                     color: primaryGreen[700],
//                   ),
//                 ),
//                 Text(
//                   "${maxValue.toInt()} sq.ft+",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                     color: primaryGreen[700],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 6),

//             // Slider
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 3,
//                 activeTrackColor: primaryGreen,
//                 inactiveTrackColor: Colors.grey.shade300,
//                 thumbColor: Colors.white,
//                 overlayColor: primaryGreen.withOpacity(0.15),
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
//               ),
//               child: RangeSlider(
//                 min: 0,
//                 max: 5000,
//                 divisions: 100,
//                 values: RangeValues(minValue, maxValue),
//                 onChanged: (RangeValues values) {
//                   setState(() {
//                     minValue = values.start;
//                     maxValue = values.end;
//                   });
//                 },
//               ),
//             ),

//             SizedBox(height: 10),

//             // Apply Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle filter logic
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryGreen.shade600,
//                   foregroundColor: Colors.white,
//                   elevation: 2,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//                   minimumSize: Size(70, 28),
//                   shape: StadiumBorder(),
//                   shadowColor: primaryGreen.withOpacity(0.2),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.check, size: 14, color: Colors.white),
//                     SizedBox(width: 5),
//                     Text(
//                       "Apply",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.5,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }


Widget _buildPremiumBannerType9(BuildContext context, bool isGridView) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double baseFontSize = screenWidth * 0.032;

  return FutureBuilder<List<LocationPremiumBanner2>>(
    future: _locationPremiumBanner9Future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading premium banners"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox();
      }

      // ✅ Filter data with order between 8 and 12
      final items = snapshot.data!
          .where((prop) => prop.imageUrl.isNotEmpty && prop.order >= 8 && prop.order <= 12)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      if (items.isEmpty) return const SizedBox();

      if (isGridView) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: screenWidth * 0.02,
            runSpacing: screenHeight * 0.025,
            children: items.map((prop) {
              return SizedBox(
                width: (screenWidth - screenWidth * 0.07) / 2,
                child: _buildGridPropertyCard(
                  context,
                  {
                    "image": prop.imageUrl,
                    "logo": prop.logo,
                    "title": prop.title,
                    "builder": prop.byLabel,
                    "availability": prop.possession ?? '',
                    "location": prop.location,
                    "bhk": prop.bhk,
                    "price": prop.priceRange,
                    "slug": prop.slug,
                  },
                  baseFontSize,
                  screenHeight,
                ),
              );
            }).toList(),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: screenWidth * 0.92,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner image with gradient overlay
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              "${AppConstants.baseUrl1}/${item.imageUrl}",
                              width: screenWidth * 0.92,
                              height: screenHeight * 0.18,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 14,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: baseFontSize * 1.1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "By ${item.byLabel}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: baseFontSize,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 14,
                            bottom: 12,
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white70, size: baseFontSize),
                                SizedBox(width: 4),
                                Text(
                                  item.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontSize: baseFontSize),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.favorite_border, color: Colors.red, size: baseFontSize * 1.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Info section
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            backgroundImage: NetworkImage("${AppConstants.baseUrl1}/${item.logo}"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.king_bed, color: primaryGreen, size: baseFontSize),
                                SizedBox(width: 6),
                                Text(
                                  item.bhk,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 12),
                                Text("|", style: TextStyle(fontSize: baseFontSize)),
                                SizedBox(width: 12),
                                Icon(Icons.event_available, color: primaryGreen, size: baseFontSize),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.possession ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price + CTA buttons
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 2, right: 16, bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.priceRange,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: baseFontSize,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.compare_arrows, color: Colors.black, size: baseFontSize * 1.2),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: baseFontSize * 1.2),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.call, color: Colors.white, size: baseFontSize * 1.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    },
  );
}




// Widget _buildCategorySection5() {
//   final List<String> possessionOptions = [
//     'Ready to move',
//     'Under Construction',
//     'New launch',
//   ];

//   Set<String> selectedOptions = {};

//   return StatefulBuilder(
//     builder: (context, setState) {
//       final double screenWidth = MediaQuery.of(context).size.width;
//       final double baseFontSize = screenWidth * 0.035;
//       final double paddingHorizontal = screenWidth * 0.01;
//       final double buttonWidth = screenWidth * 0.2;

//       return Container(
//         margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//         padding: EdgeInsets.fromLTRB(paddingHorizontal, 10, 0, 0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 8,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
//               child: Text(
//                 "Filter by Possession Date",
//                 style: TextStyle(
//                   fontSize: baseFontSize * 1.1,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),

//             // Horizontal Scrollable Options
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: possessionOptions.map((option) {
//                   final isSelected = selectedOptions.contains(option);
//                   return Padding(
//                     padding: EdgeInsets.only(right: screenWidth * 0.03),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isSelected
//                               ? selectedOptions.remove(option)
//                               : selectedOptions.add(option);
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 200),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.03,
//                           vertical: screenWidth * 0.01,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected ? primaryGreen : Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: isSelected
//                                 ? primaryGreen
//                                 : Colors.grey.shade400,
//                           ),
//                         ),
//                         child: Text(
//                           option,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: baseFontSize,
//                             color: isSelected ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(height: 8),

//             // Apply Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle possession filter
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryGreen,
//                   foregroundColor: Colors.white,
//                   elevation: 1,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: screenWidth * 0.04, 
//                     vertical: screenWidth * 0.01
//                   ),
//                   minimumSize: Size(buttonWidth, 30),
//                   shape: StadiumBorder(),
//                   shadowColor: primaryGreen.withOpacity(0.2),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.check, size: baseFontSize * 0.9, color: Colors.white),
//                     SizedBox(width: screenWidth * 0.02),
//                     Text(
//                       "Apply",
//                       style: TextStyle(
//                         fontSize: baseFontSize,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }



Widget _buildPremiumBannerType10() {
  List<String> locations = [
    "Tellapur", "Kollur", "Gachibowli", "Gopanpally", "Kompally"
  ];

  List<Map<String, String>> projects = [
    {
      "image": "assets/images/property1.jpg",
      "logo": "assets/images/builder_logo.png",
      "title": "Vaishnavi Houdini",
      "builder": "Vaishnavi Infracon India Pvt Ltd",
      "availability": "Ready by Sep 2025",
      "location": "Bandlaguda Jagiri",
      "bhk": "2 BHK",
      "minPrice": "₹ 96.0 L",
      "maxPrice": "₹ 2.50 Cr",
    },
    {
      "image": "assets/images/property2.jpg",
      "logo": "assets/images/builder_logo.png",
      "title": "Altitude DSR",
      "builder": "DSR Infra",
      "availability": "Ready by Sep 2025",
      "location": "Bandlaguda Jagiri",
      "bhk": "2 BHK",
      "minPrice": "₹ 96.0 L",
      "maxPrice": "₹ 2.50 Cr",
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double screenHeight = MediaQuery.of(context).size.height;
      double fontSize = screenWidth * 0.032;
      double cardWidth = screenWidth * 0.68;
      double cardHeight = screenHeight * 0.32;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
            child: Text(
              "Popular Locations near Tellapur",
              style: TextStyle(fontSize: fontSize * 1.3, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: locations.map((loc) {
                bool isSelected = loc == "Tellapur";
                return Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.03),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    loc,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: projects.length,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              itemBuilder: (context, index) {
                final item = projects[index];
                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(right: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⬇️ Image section with margin except bottom
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                item["image"]!,
                                width: cardWidth - 12, // width adjusted for horizontal padding
                                height: cardHeight * 0.67,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                                  ),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: screenWidth * 0.04,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Image.asset(item["logo"]!, fit: BoxFit.contain),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                ),
                                child: Text(
                                  item["availability"]!,
                                  style: TextStyle(color: Colors.white, fontSize: fontSize * 0.8),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Positioned(
                              left: screenWidth * 0.04,
                              bottom: 10,
                              right: screenWidth * 0.04,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"]!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize * 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "By ${item["builder"]!}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white70, fontSize: fontSize),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 📍 Location & BHK
                      Padding(
                        padding: EdgeInsets.fromLTRB(screenWidth * 0.04, 10, screenWidth * 0.04, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, size: fontSize, color: primaryGreen),
                                SizedBox(width: 4),
                                Text(item["location"]!, style: TextStyle(fontSize: fontSize), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.king_bed, size: fontSize, color: primaryGreen),
                                SizedBox(width: 4),
                                Text(item["bhk"]!, style: TextStyle(fontSize: fontSize), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 💰 Price + Arrow
                      Padding(
                        padding: EdgeInsets.fromLTRB(screenWidth * 0.04, 10, screenWidth * 0.04, 12),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${item["minPrice"]!} - ${item["maxPrice"]!}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(Icons.arrow_forward_ios, size: fontSize, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}





Widget _buildPremiumBannerType11() {
  List<Map<String, String>> items = [
    {
      "image": "assets/images/property1.jpg",
      "title": "Marvella",
      "builder": "Bricks Infratech",
      "availability": "Ready by Oct 2025",
      "location": "Tellapur",
      "bhk": "2,3,4&5 BHK",
      "price": "₹ 1.94 Cr",
      "logo": "assets/images/builder_logo.png",
    },
    {
      "image": "assets/images/property2.jpg",
      "title": "Haimi Nirvana",
      "builder": "Haimi Builders",
      "availability": "Ready by Oct 2025",
      "location": "Tellapur",
      "bhk": "2,3,4&5 BHK",
      "price": "₹ 1.94 Cr",
      "logo": "assets/images/builder_logo.png",
    },
    {
      "image": "assets/images/property3.jpg",
      "title": "Fortune Green Sapphire",
      "builder": "Fortune Green Homes",
      "availability": "Ready by Oct 2025",
      "location": "Tellapur",
      "bhk": "2,3,4&5 BHK",
      "price": "₹ 1.94 Cr",
      "logo": "assets/images/builder_logo.png",
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double fontSize = screenWidth * 0.03;
      double imageHeight = screenWidth * 0.35;
      double cardWidth = screenWidth * 0.4;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Recently added projects",
              style: TextStyle(
                fontSize: fontSize * 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: imageHeight * 2.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔲 Image with top/left/right padding
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(
                                item["image"]!,
                                height: imageHeight,
                                width: cardWidth - 12, // account for left/right padding
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: fontSize * 0.9,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Image.asset(
                                      item["logo"]!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 📋 Card Content
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"]!,
                              style: TextStyle(fontSize: fontSize * 1.1, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "By ${item["builder"]!}",
                              style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item["availability"]!,
                              style: TextStyle(fontSize: fontSize * 0.85, color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Icon(Icons.location_on, size: fontSize, color: primaryGreen),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item["location"]!,
                                    style: TextStyle(fontSize: fontSize * 0.95),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.king_bed, size: fontSize, color: primaryGreen),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item["bhk"]!,
                                    style: TextStyle(fontSize: fontSize * 0.95),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Starts from ${item["price"]!}",
                                style: TextStyle(
                                  fontSize: fontSize * 0.95,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
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
              },
            ),
          ),
        ],
      );
    },
  );
}



Widget _buildPremiumBannerType12(BuildContext context, bool isGridView) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double baseFontSize = screenWidth * 0.032;

  return FutureBuilder<List<LocationPremiumBanner2>>(
    future: _locationPremiumBanner12Future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error loading premium banners"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox();
      }

      final items = snapshot.data!
          .where((prop) =>
              prop.imageUrl.isNotEmpty && prop.order >= 12 && prop.order <= 15)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      if (items.isEmpty) return const SizedBox();

      if (isGridView) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: screenWidth * 0.02,
            runSpacing: screenHeight * 0.025,
            children: items.map((prop) {
              return SizedBox(
                width: (screenWidth - screenWidth * 0.07) / 2,
                child: _buildGridPropertyCard(
                  context,
                  {
                    "image": prop.imageUrl,
                    "logo": prop.logo,
                    "title": prop.title,
                    "builder": prop.byLabel,
                    "availability": prop.possession ?? '',
                    "location": prop.location,
                    "bhk": prop.bhk,
                    "price": prop.priceRange,
                    "slug": prop.slug,
                  },
                  baseFontSize,
                  screenHeight,
                ),
              );
            }).toList(),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final prop = items[index];
              return _buildListPropertyCard(
                context,
                {
                  "image": prop.imageUrl,
                  "logo": prop.logo,
                  "title": prop.title,
                  "builder": prop.byLabel,
                  "availability": prop.possession ?? '',
                  "location": prop.location,
                  "bhk": prop.bhk,
                  "price": prop.priceRange,
                  "slug": prop.slug,
                },
                baseFontSize,
                screenWidth,
                screenHeight,
              );
            },
          ),
        );
      }
    },
  );
}




 Widget _buildPremiumBannerType13(
      List<dynamic> projectData, Function(String) onLocationSelected) {
    final Map<String, int> localityCounts = {};

    for (var item in projectData) {
      final address = item['project']?['geo_address'] ?? '';
      if (address.isNotEmpty) {
        final parts = address.split(',');
        final trimmedParts = parts.map((e) => e.trim()).toList();
        String locality = '';

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

    final List<Map<String, String>> projectCategories =
        localityCounts.entries.map((entry) {
      return {
        'name': entry.key,
        'projects': "${entry.value} Project${entry.value > 1 ? 's' : ''}",
      };
    }).toList();

    List<List<Map<String, String>>> pages = [];
    for (int i = 0; i < projectCategories.length; i += 9) {
      pages.add(projectCategories.sublist(
        i,
        (i + 9 > projectCategories.length)
            ? projectCategories.length
            : i + 9,
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
                            padding:
                                const EdgeInsets.only(right: 8, bottom: 10),
                            child: GestureDetector(
                              onTap: () =>
                                  onLocationSelected(category['name']!),
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
                  fontSize: 11,
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
                  fontSize: 10,
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
}

Widget _buildPremiumBannerType14(BuildContext context) {
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

  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth * 0.6;
  double cardHeight = cardWidth * 1.02;
  double baseFontSize = screenWidth * 0.032;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          "Tellapur News",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: cardHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: localityData
                .map((item) => _buildLocalityBanner(context, item, screenWidth))
                .toList(),
          ),
        ),
      ),
    ],
  );
}

Widget _buildLocalityBanner(BuildContext context, Map<String, String> locality, double screenWidth) {
  double cardWidth = screenWidth * 0.6;
  double imageHeight = cardWidth * 0.55;
  double baseFontSize = screenWidth * 0.032;

  return Container(
    width: cardWidth,
    margin: const EdgeInsets.symmetric(horizontal: 5),
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
            locality["image"] ?? '',
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   locality["title"] ?? '',
              //   style: const TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              const SizedBox(height: 10),
              Text(
                locality["description"] ?? '',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: baseFontSize,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Text(
                  locality["hyperlink"] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionServiceType21(BuildContext context) {
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

class CustomSearchAppBar extends StatefulWidget {
  final String location;
  final VoidCallback onBack;
  final VoidCallback onFilter;
  final VoidCallback onClearLocation;
  final VoidCallback onProfileTap;
  final String profileImage;

  const CustomSearchAppBar({
    super.key,
    required this.location,
    required this.onBack,
    required this.onFilter,
    required this.onClearLocation,
    required this.onProfileTap,
    required this.profileImage,
  });

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  TextEditingController searchController = TextEditingController();

  List<String> dynamicLocations = [];
  List<String> dynamicPincodes = [];
  List<Map<String, String>> dynamicProjects = [];

  @override
  void initState() {
    super.initState();
    _loadSearchData();
  }

  Future<void> _loadSearchData() async {
    final data = await SearchService.loadAll();
    setState(() {
      dynamicLocations = data['locations'] ?? [];
      dynamicPincodes = data['pincodes'] ?? [];
      dynamicProjects = List<Map<String, String>>.from(data['projects'] ?? []);
    });
  }

  void _onLocationSelected(String selectedLocation) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyByLocation(location: selectedLocation),
      ),
    );
  }

  void _onClearLocation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyByLocation(location: ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseFontSize = screenWidth * 0.035;
    final double padding = screenWidth * 0.01;

    return Container(
      color: primaryGreen,
      padding: EdgeInsets.only(top: 40, left: padding, right: padding, bottom: 8),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: primaryGreen),
            ),
          ),
          const SizedBox(width: 10),
          // Search Box
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.location.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: primaryGreen),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.location,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: baseFontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    widget.onClearLocation();
                                    searchController.clear();
                                    _onClearLocation();
                                  },
                                  child: const Icon(Icons.close, size: 18, color: primaryGreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : TypeAheadField<String>(
                      hideOnEmpty: true,
                      debounceDuration: const Duration(milliseconds: 300),
                      suggestionsCallback: (pattern) async {
                        if (pattern.trim().length < 3) return [];
                        final all = [
                          ...dynamicLocations,
                          ...dynamicPincodes,
                          ...dynamicProjects.map((p) => p['title']!)
                        ];
                        return SearchService.fuzzyMatch(pattern, all).take(10).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        final input = searchController.text;
                        final matchIndex = suggestion.toLowerCase().indexOf(input.toLowerCase());

                        if (matchIndex >= 0) {
                          final before = suggestion.substring(0, matchIndex);
                          final match = suggestion.substring(matchIndex, matchIndex + input.length);
                          final after = suggestion.substring(matchIndex + input.length);
                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  TextSpan(text: before),
                                  TextSpan(
                                    text: match,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  TextSpan(text: after),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListTile(title: Text(suggestion));
                      },
                      onSelected: (suggestion) {
                        searchController.clear();
                        _onLocationSelected(suggestion);
                      },
                      builder: (context, controller, focusNode) {
                        searchController = controller;
                        return Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    controller.clear();
                                    _onLocationSelected(value.trim());
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Search your dream home...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: baseFontSize * 0.9),
                                ),
                              ),
                            ),
                            if (controller.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  controller.clear();
                                  setState(() {});
                                },
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 10),
          // Profile Avatar
          GestureDetector(
            onTap: widget.onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.profileImage.startsWith('assets/')
                  ? AssetImage(widget.profileImage) as ImageProvider
                  : FileImage(File(widget.profileImage)),
            ),
          ),
        ],
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
      60, size.height, // end point
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

class _CustomSearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomSearchAppBarDelegate({required this.child});

  @override
  double get minExtent => kToolbarHeight + 35;
  @override
  double get maxExtent => kToolbarHeight + 35;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _CustomSearchAppBarDelegate oldDelegate) => false;
}

class _FloatingCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _FloatingCategoryHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

