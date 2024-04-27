import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'art_work.dart'; // Your Artwork model
import 'profile.dart'; // Your Profile model

class ArtDetailPage extends StatelessWidget {
  final Artwork artwork;
  final Profile artistProfile;
  final _key = GlobalKey<FormState>();
  sendEmail(String subject, String body, String recipient) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipient],
      isHTML: false,
    );
  }

  TextEditingController email = TextEditingController();

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

  String selectedCategory = 'All'; // Default category
  List<Artwork> allArtworks = []; // List to hold all artworks

  @override
  void initState() {
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 20, top: 10),
              child: SizedBox(
                width: 250,
                height: 350,
                child: ClipRect(
                  child: Image.network(
                    artwork.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      artwork.type,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            '${artwork.title}\nBy ${artistProfile.firstName} ${artistProfile.lastName}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)
                            // Theme.of(context).textTheme.headline6,
                            ),
                      ),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(artistProfile.profileImageUrl),
                        radius: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Text(artwork.description,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 210,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => Form(
                              key: _key,
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        controller: email,
                                        decoration: const InputDecoration(
                                          hintText: "Request commission",
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // _key.currentState!.save();
                                        sendEmail(
                                          "Commission Request",
                                          email.text,
                                          artistProfile.email,
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        "Submit Request",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text("Cancel"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Commissions",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("${artistProfile.firstName}'s Portfolio",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  SingleChildScrollView(),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Comments',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
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
                      decoration: InputDecoration(
                          hintText: "Add a comment",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () async {
                          if (commentController.text.isNotEmpty) {
                            await addCommentToFirestore(
                                artwork.id, commentController.text);
                            commentController.clear();
                          }
                        },
                        child: Text('Post Comment'),
                      ),
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
