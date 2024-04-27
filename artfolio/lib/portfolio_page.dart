import 'package:artfolio/portfolio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile.dart'; // Assuming this model is correctly defined and imported
import 'art_work.dart'; // Assuming you have an Artwork model defined

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final picker = ImagePicker();
  Profile? userProfile;
  bool _isLoading = false;
  bool _isUpdatingImage = false;

  // Artwork form controllers
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Painting';
  File? _artworkImageFile;
  final List<String> _artTypes = [
    'Painting',
    'Sketch',
    'Photography',
    'Ceramics',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('profiles')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userProfile = Profile.fromMap(
            documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      _showErrorDialog('Failed to load user profile.');
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _pickAndUpdateProfileImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String filePath = 'profile_images/${user!.uid}';
        print('Starting upload...');
        String downloadURL = await uploadFile(imageFile, filePath);
        print('Upload complete: $downloadURL');
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user!.uid)
            .update({
          'profileImageUrl': downloadURL,
        });
        setState(() {
          userProfile!.profileImageUrl = downloadURL;
          print('Profile updated in Firestore');
        });
      }
    } catch (e) {
      print('Failed to update profile image: $e');
      _showErrorDialog('Failed to update profile image.');
    }
  }

  Future<void> _pickArtworkImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _artworkImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadArtwork() async {
    Navigator.pop(context);
    if (_artworkImageFile == null) return;
    try {
      String filePath =
          'artworks/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}';
      String imageUrl = await uploadFile(_artworkImageFile!, filePath);

      // Create the Artwork object
      Artwork newArtwork = Artwork(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user!.uid, // Ensure you have a valid user instance
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: imageUrl,
        type: _selectedType,
        comments: [],
      );

      // Upload the artwork to Firestore
      await FirebaseFirestore.instance
          .collection('artworks')
          .doc(newArtwork.id)
          .set(newArtwork.toMap());

      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      _artworkImageFile = null;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Artwork uploaded successfully!")));
    } catch (e) {
      print('Error uploading artwork: $e');
      _showErrorDialog('Failed to upload artwork.');
    }
  }

  Future<String> uploadFile(File file, String path) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      throw e;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isUpdatingImage) CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Profile \n& Portfolio",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 15),
                            Text(
                                userProfile != null
                                    ? "${userProfile!.firstName} ${userProfile!.lastName}"
                                    : "Loading...",
                                style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 5),
                            Text(
                                userProfile != null
                                    ? "${userProfile!.email}"
                                    : "Loading...",
                                style: TextStyle(fontSize: 15)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: FirebaseAuth
                                                .instance.currentUser!.email
                                                .toString());
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                                "The password reset link has been sent to your email"),
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Reset Password",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                    onPressed: _loadUserProfile,
                                    icon: Icon(Icons.refresh)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: userProfile != null &&
                                      userProfile!.profileImageUrl.isNotEmpty
                                  ? NetworkImage(userProfile!.profileImageUrl)
                                      as ImageProvider
                                  : AssetImage('assets/images/profilepic.png')
                                      as ImageProvider,
                            ),
                            IconButton(
                                onPressed: _pickAndUpdateProfileImage,
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Portfolio()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Go To\nPortfolio",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(51, 158, 158, 158),
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierColor: Color.fromARGB(116, 94, 94, 94),
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 20),
                                              _artworkImageFile != null
                                                  ? Image.file(
                                                      _artworkImageFile!)
                                                  : Container(),
                                              TextField(
                                                controller: _titleController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'Title'),
                                              ),
                                              const SizedBox(height: 20),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: TextField(
                                                  controller:
                                                      _descriptionController,
                                                  decoration:
                                                      const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  vertical: 20,
                                                                  horizontal:
                                                                      20),
                                                          border:
                                                              InputBorder.none,
                                                          labelText:
                                                              'Description'),
                                                  maxLines: null,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              DropdownButton<String>(
                                                value: _selectedType,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedType = newValue!;
                                                  });
                                                },
                                                items: _artTypes.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                              IconButton(
                                                  onPressed: _pickArtworkImage,
                                                  icon: const Icon(
                                                    Icons
                                                        .drive_folder_upload_sharp,
                                                    color: Colors.black,
                                                  )),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: _uploadArtwork,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Add to Portfolio",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                          icon: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
