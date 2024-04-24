import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  final bool hasFeed; // This flag will simulate whether there's feed content

  // Constructor to accept feed status, defaulting to false
  FeedScreen({this.hasFeed = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 75, left: 55.0, right: 55),
          child: Container(
            width: double.infinity,
            child: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            label: '',
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "All",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "Painting",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "Photography",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "Ceramic",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "Digital",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: FilterChip(
                      label: const Text(
                        "Other",
                        style:
                            TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      disabledColor: Colors.white,
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: null),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: hasFeed ? Column() : Text("No feed yet"),
          ),
        ],
      ),
    );
  }
}
