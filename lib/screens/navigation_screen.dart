import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:proser/api/homescreen_model.dart';
import 'package:proser/screens/compareScreen.dart';
import 'package:proser/screens/home/home_screen.dart';
import 'package:proser/screens/home/homeScreen_villas.dart';
import 'package:proser/screens/home/homeScreen_plots.dart';
import 'package:proser/screens/search/search_screen.dart';
import 'package:proser/screens/search/PropertyByLocation.dart';
import 'package:proser/screens/wishlistScreen.dart'; // ✅ Wishlist screen import

import 'package:proser/utils/color.dart';

class NavigationScreen extends StatefulWidget {
  final int selectedIndex;
  final String? initialPageType;

  NavigationScreen({this.selectedIndex = 0, this.initialPageType});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;
  late Widget _homePage;
  late Widget _searchSubPage;
  late List<Widget> _pages;

  // ✅ Dummy list – replace with your real property data
  final List<ProminentBuilder> _allProperties = [
    // Add actual ProminentBuilder instances here
    // Example:
    // ProminentBuilder(
    //   projectSlug: "my-project",
    //   projectTitle: "Skyline Residency",
    //   builderName: "ABC Builders",
    //   validatedCoverImage: "https://yourimage.com/image.jpg",
    //   validatedBuilderLogo: "https://yourimage.com/logo.jpg",
    //   location: "Hyderabad",
    //   bhk: "2, 3 BHK",
    //   possession: "Dec 2025",
    //   priceRange: "₹80L - ₹1.2Cr",
    // )
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    switch (widget.initialPageType) {
      case 'villas':
        _homePage = HomeScreenVillas();
        break;
      case 'plots':
        _homePage = HomeScreenPlots();
        break;
      default:
        _homePage = HomeScreen();
    }

    final knownHomeTypes = ['villas', 'plots'];
    final isLocation = widget.selectedIndex == 1 &&
        widget.initialPageType != null &&
        !knownHomeTypes.contains(widget.initialPageType);

    _searchSubPage = isLocation
        ? PropertyByLocation(location: widget.initialPageType!)
        : SearchScreen(
            onLocationSelected: (String location) {
              setState(() {
                _searchSubPage = PropertyByLocation(location: location);
                _pages[1] = _searchSubPage;
              });
            },
          );

    _pages = [
      _homePage,
      _searchSubPage,
      CompareScreen(),
      WishlistScreen(allProperties: _allProperties), // ✅ Routed here
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        _searchSubPage = SearchScreen(
          onLocationSelected: (String location) {
            setState(() {
              _searchSubPage = PropertyByLocation(location: location);
              _pages[1] = _searchSubPage;
            });
          },
        );
        _pages[1] = _searchSubPage;
      }

      if (index == 3) {
        // Refresh wishlist tab when selected
        _pages[3] = WishlistScreen(allProperties: _allProperties);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 55,
        backgroundColor: primaryGreen,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.easeInOut,
        onTap: _onItemTapped,
        items: <Widget>[
          Icon(Icons.home, size: 28, color: _selectedIndex == 0 ? primaryGreen : Colors.black),
          Icon(Icons.search, size: 28, color: _selectedIndex == 1 ? primaryGreen : Colors.black),
          Icon(Icons.swap_horiz, size: 28, color: _selectedIndex == 2 ? primaryGreen : Colors.black),
          Icon(Icons.favorite_border, size: 28, color: _selectedIndex == 3 ? primaryGreen : Colors.black),
        ],
      ),
    );
  }
}
