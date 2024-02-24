import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController postTextController = TextEditingController();
  String imageUrl = ''; // URL of the image
  String videoUrl = ''; // URL of the video
  String location = ''; // Location information
  bool isLiked = false;
  int likeCount = 0;

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
            // Add image selection widget
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
        'videoUrl': videoUrl,
        'location': location,
        'likeCount': likeCount,
        'isLiked': isLiked,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field after posting
      postTextController.clear();
      // You may also need to reset other state variables like imageUrl, videoUrl, etc.

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
