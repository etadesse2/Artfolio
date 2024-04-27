import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'art_work.dart'; // Your artwork model class
import 'art_page.dart'; // Your art detail page class
import 'profile.dart'; // Your profile model class

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
          .map((doc) =>
              Artwork.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: _buildFilterChipBar(),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(30),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 50,
          childAspectRatio:
              (1 / 1.5), // Adjust the aspect ratio of the grid items
        ),
        itemCount: filteredArtworks.length,
        itemBuilder: (context, index) {
          Artwork artwork = filteredArtworks[index];
          return GestureDetector(
            onTap: () => navigateToArtDetailPage(artwork),
            child: GridTile(
              child: Image.network(artwork.imageUrl, fit: BoxFit.cover),
              // footer: GridTileBar(
              //   backgroundColor: Colors.black54,
              //   title: Text(artwork.title, style: TextStyle(fontSize: 14)),
              //   subtitle:
              //       Text(artwork.description, style: TextStyle(fontSize: 12)),
              // ),
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
      'Others',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              label: Text(
                category,
                style: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.black),
              ),
              showCheckmark: true,
              checkmarkColor: Colors.white,
              selected: selectedCategory == category,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) selectedCategory = category;
                  _fetchArtworks(); // Refetch artworks with the selected category
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void navigateToArtDetailPage(Artwork artwork) async {
    Profile artistProfile = await fetchArtistProfile(artwork.userId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ArtDetailPage(artwork: artwork, artistProfile: artistProfile),
      ),
    );
  }
}

Future<Profile> fetchArtistProfile(String userId) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('profiles').doc(userId).get();
  return Profile.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
}
