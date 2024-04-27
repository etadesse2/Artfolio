import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'art_work.dart'; // Your Artwork model
import 'profile.dart'; // Your Profile model

class ArtDetailPage extends StatelessWidget {
  final Artwork artwork;
  final Profile artistProfile;

  // Remove 'Artwork artwork,' from the constructor
  ArtDetailPage({
    required this.artwork,
    required this.artistProfile,
  });

  final TextEditingController commentController = TextEditingController();

// Function to add a comment to an artwork
  Future<void> addComment(
      String artworkId, String comment, BuildContext context) async {
    try {
      DocumentReference artworkRef =
          FirebaseFirestore.instance.collection('artworks').doc(artworkId);

      print(
          "Adding comment: $comment to artwork ID: $artworkId"); // Debug output

      // Update the comments array in Firestore
      await artworkRef.update({
        'comments': FieldValue.arrayUnion([comment])
      });

      // Optionally clear the comment controller and close the keyboard
      commentController.clear();
      FocusScope.of(context).unfocus();

      // Show a success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Comment added successfully')));
    } catch (e) {
      print("Failed to add comment: $e"); // Log the error

      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add comment: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = artwork.userId == FirebaseAuth.instance.currentUser!.uid;

    // Listen to real-time updates of the artwork comments
    Stream<List<String>> commentsStream = FirebaseFirestore.instance
        .collection('artworks')
        .doc(artwork.id)
        .snapshots()
        .map((snapshot) =>
            List<String>.from(snapshot.data()?['comments'] ?? []));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(artwork.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              artwork.imageUrl,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(artistProfile.profileImageUrl),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${artistProfile.firstName} ${artistProfile.lastName}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(artwork.description,
                      style: Theme.of(context).textTheme.bodyText2),
                  SizedBox(height: 20),
                  Divider(),
                  Text('Comments',
                      style: Theme.of(context).textTheme.headline6),
                  StreamBuilder<List<String>>(
                    stream: commentsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error loading comments');
                      }
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      List<String> comments = snapshot.data!;
                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: comments
                            .map((comment) => ListTile(title: Text(comment)))
                            .toList(),
                      );
                    },
                  ),
                  if (!isOwner) ...[
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(hintText: "Add a comment"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (commentController.text.isNotEmpty) {
                          await addCommentToFirestore(
                              artwork.id, commentController.text);
                          commentController.clear();
                        }
                      },
                      child: Text('Post Comment'),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addCommentToFirestore(String artworkId, String comment) async {
    // Add comment to the comments array in the Firestore document
    await FirebaseFirestore.instance
        .collection('artworks')
        .doc(artworkId)
        .update({
      'comments': FieldValue.arrayUnion([comment])
    });
  }
}
