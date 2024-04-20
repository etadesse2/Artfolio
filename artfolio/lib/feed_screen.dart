import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  final bool hasFeed; // This flag will simulate whether there's feed content

  // Constructor to accept feed status, defaulting to false
  FeedScreen({this.hasFeed = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: Center(
        child: hasFeed ? Text("Here's your feed") : Text("No feed yet"),
      ),
    );
  }
}
