class LocationSuggestion {
  final String fullAddress;
  final List<String> keywords;

  LocationSuggestion({required this.fullAddress, required this.keywords});

  factory LocationSuggestion.fromGeoAddress(String geoAddress) {
    final cleaned = geoAddress
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    return LocationSuggestion(fullAddress: geoAddress, keywords: cleaned);
  }
}
