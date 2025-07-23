import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:proser/screens/PropertyScreen.dart';
import 'package:proser/screens/search/search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final String? originType;
  final Function(String location) onLocationSelected;

  SearchScreen({this.originType, required this.onLocationSelected});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<String> recentSearches = [];
  List<String> dynamicLocations = [];
  List<String> dynamicPincodes = [];
  List<Map<String, String>> dynamicProjects = [];

  List<String> filteredLocations = [];
  List<Map<String, String>> filteredProjects = [];

  String _originType = 'apartments';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _originType = widget.originType ?? prefs.getString('search_origin_type') ?? 'apartments';
    await prefs.setString('search_origin_type', _originType);

    recentSearches = prefs.getStringList('recent_searches') ?? [];

    final data = await SearchService.loadAll();
    dynamicLocations = data['locations'] ?? [];
    dynamicPincodes = data['pincodes'] ?? [];
    dynamicProjects = List<Map<String, String>>.from(data['projects'] ?? []);

    setState(() => isLoading = false);
  }

  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', recentSearches);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        setState(() {
          filteredLocations = [];
          filteredProjects = [];
        });
        return;
      }

      setState(() {
        filteredLocations = SearchService.fuzzyMatch(query, [
          ...dynamicLocations,
          ...dynamicPincodes.where((p) => p.startsWith(query))
        ]).take(8).toList();

        filteredProjects = dynamicProjects
            .where((project) =>
                project['title']!.toLowerCase().contains(query.toLowerCase()))
            .take(8)
            .toList();
      });

      // if (!recentSearches.contains(query) && query.length > 2) {
      //   recentSearches.insert(0, query);
      //   if (recentSearches.length > 10) recentSearches.removeLast();
      //   _saveRecentSearches();
      // }
    });
  }

  void _onSearchSubmitted(String query) {
  query = query.trim();
  if (query.isEmpty) return;

  final isLocation = dynamicLocations.any((l) => l.toLowerCase() == query.toLowerCase());
  final isPincode = RegExp(r'^\d{6}$').hasMatch(query) || dynamicPincodes.contains(query);

  final matchedProject = dynamicProjects.firstWhere(
    (p) => p['title']!.toLowerCase() == query.toLowerCase(),
    orElse: () => {},
  );

  if (isLocation || isPincode) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) recentSearches.removeLast();
      _saveRecentSearches();
    }
    widget.onLocationSelected(query);
  } else if (matchedProject.isNotEmpty && matchedProject['slug'] != null) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) recentSearches.removeLast();
      _saveRecentSearches();
    }
    Navigator.pushNamed(context, '/property/${matchedProject['slug']}');
  }
}


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Search")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TypeAheadField<String>(
                controller: _searchController,
                hideOnEmpty: true,
                debounceDuration: Duration(milliseconds: 300),
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
                  final input = _searchController.text;
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
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                  _searchController.text = suggestion;
                  _onSearchChanged(suggestion);
                  _onSearchSubmitted(suggestion);
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Search your dream home...",
                      border: InputBorder.none,
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                controller.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _onSearchSubmitted(_searchController.text),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: "Recent Searches",
                showCondition: recentSearches.isNotEmpty,
                child: Wrap(
                  spacing: 8,
                  children: recentSearches.map((search) {
                    return InputChip(
                      label: Text(search),
                      onPressed: () => widget.onLocationSelected(search),
                      onDeleted: () {
                        setState(() {
                          recentSearches.remove(search);
                          _saveRecentSearches();
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              _buildSection(
                title: "Search by Project Name",
                showCondition: filteredProjects.isNotEmpty,
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filteredProjects
                        .map((project) => _buildProjectCard(project))
                        .toList(),
                  ),
                ),
              ),
              _buildSection(
                title: "Most Searched Localities",
                showCondition: filteredLocations.isNotEmpty,
                child: Wrap(
                  spacing: 10,
                  children: filteredLocations
                      .map((location) => ActionChip(
                            label: Text(location),
                            onPressed: () => widget.onLocationSelected(location),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool showCondition,
    required Widget child,
  }) {
    return showCondition
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                child,
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildProjectCard(Map<String, String> project) {
  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PropertyScreen(
        slug: project['slug'] ?? '',
        propertyTitle: project['title'] ?? '',
        builderName: project['byLabel'] ?? '',
        imageUrl: project['validatedImageUrl'] ?? '',
        builderLogo: project['validatedLogoUrl'] ?? '',
      ),
    ),
  );
},

    child: SizedBox(
      width: 170,
      height: 230,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                project['validatedImageUrl'] ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/property1.jpg', fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                project["title"] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
