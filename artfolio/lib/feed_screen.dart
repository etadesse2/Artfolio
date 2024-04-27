import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'art_work.dart';
import 'art_page.dart';
import 'profile.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedCategory = 'All';
  List<Artwork> allArtworks = [];

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
        padding: const EdgeInsets.all(30),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 50,
          childAspectRatio: (1 / 1.5),
        ),
        itemCount: filteredArtworks.length,
        itemBuilder: (context, index) {
          Artwork artwork = filteredArtworks[index];
          return GestureDetector(
            onTap: () => navigateToArtDetailPage(artwork),
            child: GridTile(
              child: Image.network(artwork.imageUrl, fit: BoxFit.cover),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  _fetchArtworks();
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
