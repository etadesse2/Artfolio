import 'package:artfolio/art_work.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  String selectedCategory = 'All';
  List<Artwork> allArtworks = [];

  @override
  void initState() {
    super.initState();
    _fetchArtworks();
  }

  void _fetchArtworks() {
    FirebaseFirestore.instance
        .collection('artworks')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
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
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                const Text("Are you sure you want to delete?"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: ClipRect(
                clipBehavior: Clip.antiAlias,
                child: Image.network(artwork.imageUrl, fit: BoxFit.cover)),
          );
        },
      ),
    );
  }
}
