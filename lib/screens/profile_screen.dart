import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        _userName = userDoc['username'] ?? "";
      });
    } catch (error) {
      print("Error loading user data: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser?.photoURL ??
                    'https://example.com/default-profile-image.jpg',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showSnackbar('Change Profile Photo');
                // Add logic to handle uploading new profile photo from gallery
                // You may want to use a package like image_picker for this
              },
              child: Text('Change Profile Photo'),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: getUserInfo(FirebaseAuth.instance.currentUser?.uid ?? ""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error fetching user data');
                } else {
                  final username = snapshot.data?['userName'] ?? 'Not found';
                  return Text(
                    'User Name: $username',
                    style: TextStyle(fontSize: 20),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${FirebaseAuth.instance.currentUser?.email ?? "N/A"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Password: *********',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    } catch (error) {
      print("Error fetching user data: ${error.toString()}");
      return null;
    }
  }
}
