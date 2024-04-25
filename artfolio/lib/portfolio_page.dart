import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      appBar: AppBar(title: Text('Your Portfolio')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isUpdatingImage) CircularProgressIndicator(),
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: userProfile != null &&
                            userProfile!.profileImageUrl.isNotEmpty
                        ? NetworkImage(userProfile!.profileImageUrl)
                            as ImageProvider
                        : AssetImage('assets/images/profile_pic.png')
                            as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text(
                      userProfile != null
                          ? "${userProfile!.firstName} ${userProfile!.lastName}"
                          : "Loading...",
                      style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: _pickAndUpdateProfileImage,
                    child: Text('Update Profile Picture'),
                  ),
                  ElevatedButton(
                    onPressed: _loadUserProfile,
                    child: Text('Refresh Profile'),
                  ),
                  Divider(),
                  Text('Upload New Artwork',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  _artworkImageFile != null
                      ? Image.file(_artworkImageFile!)
                      : Container(),
                  ElevatedButton(
                    onPressed: _pickArtworkImage,
                    child: Text('Pick Image for Artwork'),
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  DropdownButton<String>(
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items:
                        _artTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: _uploadArtwork,
                    child: Text('Upload Artwork'),
                  ),
                ],
              ),
            ),
    );
  }
}
