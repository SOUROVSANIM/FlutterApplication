import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController postTextController = TextEditingController();
  String? imageUrl; // URL of the image

  // Function to handle photo selection
  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageUrl = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _createPost();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: postTextController,
              decoration: InputDecoration(labelText: 'Write something...'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            // Photo selection button
            ElevatedButton.icon(
              onPressed: _selectPhoto,
              icon: Icon(Icons.photo),
              label: Text('Select Photo'),
            ),
            // Display selected image if available
            if (imageUrl != null)
              Image.file(
                File(imageUrl!),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            // Add video selection widget
            // Add location selection widget
          ],
        ),
      ),
    );
  }

  Future<void> _createPost() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'N/A';
      String userProfilePic = FirebaseAuth.instance.currentUser?.photoURL ?? '';

      // Create a new post document in Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': userId,
        'userName': userName,
        'userProfilePic': userProfilePic,
        'postText': postTextController.text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field after posting
      postTextController.clear();
      setState(() {
        imageUrl = null; // Reset imageUrl after posting
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print('Error creating post: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
