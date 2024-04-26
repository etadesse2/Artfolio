import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedCategory = 'All'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:
            _buildFilterChipBar(), // Place the filter chip bar on the left side
        leadingWidth: MediaQuery.of(context)
            .size
            .width, // Extend the width of the leading area to occupy full AppBar width
      ),
      body: Center(
        child: Text("Displaying content for: $selectedCategory"),
      ),
    );
  }

  Widget _buildFilterChipBar() {
    List<String> categories = [
      'All',
      'Painting',
      'Sketch',
      'Photography',
      'Ceramics',
      'Others'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: categories
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black),
                    ),
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) selectedCategory = category;
                        // Here you would also trigger a fetch or filter of the feed data based on the selected category
                      });
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
