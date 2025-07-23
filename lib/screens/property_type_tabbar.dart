import 'package:flutter/material.dart';

class PropertyTypeTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;  

  const PropertyTypeTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Apartments', 'Villas', 'Plots'];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.red : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                SizedBox(height: 6),
                if (isSelected)
                  Container(
                    height: 3,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
