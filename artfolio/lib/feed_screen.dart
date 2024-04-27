import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'art_work.dart'; // Your artwork model class

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedCategory = 'All'; // Default category
  List<Artwork> allArtworks = []; // List to hold all artworks

  @override
  void initState() {
    super.initState();
    _fetchArtworks();
  }

  void _fetchArtworks() {
    FirebaseFirestore.instance.collection('artworks').get().then((snapshot) {
      List<Artwork> artworks = snapshot.docs
          .map((doc) => Artwork.fromMap(doc.data(), doc.id))
          .toList();
      setState(() {
        allArtworks = artworks;
      });
    });
  }

  List<Artwork> get filteredArtworks {
    if (selectedCategory == 'All') {
      return allArtworks;
    } else {
      return allArtworks
          .where((artwork) => artwork.type == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Art Feed'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _buildFilterChipBar(),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredArtworks.length,
        itemBuilder: (context, index) {
          Artwork artwork = filteredArtworks[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(artwork.imageUrl, fit: BoxFit.cover),
                ListTile(
                  title: Text(artwork.title),
                  subtitle: Text(artwork.description),
                ),
                // ... any other widgets to display artwork details
              ],
            ),
          );
        },
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
                        // The feed will update to show the filtered artworks
                      });
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
