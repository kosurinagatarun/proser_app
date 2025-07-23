import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedApartment = 'All';
  String selectedConfiguration = 'All';
  String selectedType = 'All';
  String selectedPostedBy = 'All';
  String selectedSaleType = 'All';
  List<String> selectedAmenities = [];

  List<String> apartmentOptions = ['All', 'Standalone', 'Semi gated', 'Fully-gated'];
  List<String> configOptions = ['All', '1 BHK', '2 BHK', '2.5 BHK', '3 BHK'];
  List<String> typeOptions = ['All', 'New Project', 'Ready to move', 'Under Construction'];
  List<String> postedByOptions = ['All', 'Posted By Builder', 'Posted by Owner'];
  List<String> saleTypeOptions = ['All', 'Resale', 'Fresh Sale'];
  List<String> amenitiesList = ['GYM', 'Storage', 'Security', 'Lift', 'CCTV', 'Power Backup'];

  Widget buildSearchField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

Widget buildSingleSelectChips(List<String> options, String selectedValue, Function(String) onChanged) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: options.map((label) {
        final isSelected = selectedValue == label;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onChanged(label),
            selectedColor: const Color(0xFF00796B),
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }).toList(),
    ),
  );
}

Widget buildMultiSelectChips(List<String> options) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: options.map((label) {
        final isSelected = selectedAmenities.contains(label);
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                if (!isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.add, size: 16, color: Colors.grey),
                  )
              ],
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                isSelected ? selectedAmenities.remove(label) : selectedAmenities.add(label);
              });
            },
            selectedColor: const Color(0xFF00796B),
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }).toList(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 251, 253),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text("Filters", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("You are searching in Hyderabad", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Locality", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("Add up to 4 locations", style: TextStyle(color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 10),
                buildSearchField("Search for localities"),
                const SizedBox(height: 20),
                const Text("Apartment Types", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSingleSelectChips(apartmentOptions, selectedApartment, (val) => setState(() => selectedApartment = val)),
                const SizedBox(height: 20),
                const Text("Amenities", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSearchField("Search Amenities"),
                const SizedBox(height: 10),
                buildMultiSelectChips(amenitiesList),
                const SizedBox(height: 20),
                const Text("Configuration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSingleSelectChips(configOptions, selectedConfiguration, (val) => setState(() => selectedConfiguration = val)),
                const SizedBox(height: 20),
                const Text("Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSingleSelectChips(typeOptions, selectedType, (val) => setState(() => selectedType = val)),
                const SizedBox(height: 20),
                const Text("Posted By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSingleSelectChips(postedByOptions, selectedPostedBy, (val) => setState(() => selectedPostedBy = val)),
                const SizedBox(height: 20),
                const Text("Sale Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                buildSingleSelectChips(saleTypeOptions, selectedSaleType, (val) => setState(() => selectedSaleType = val)),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Implement your apply logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Apply', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}