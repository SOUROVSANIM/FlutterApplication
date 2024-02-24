import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                // Handle the "Change Profile Photo" button press
                _showSnackbar('Change Profile Photo');
                // Add logic to handle uploading new profile photo from gallery
                // You may want to use a package like image_picker for this
              },
              child: Text('Change Profile Photo'),
            ),
            SizedBox(height: 20),
            Text(
              'User Name: ${FirebaseAuth.instance.currentUser?.displayName ?? "N/A"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${FirebaseAuth.instance.currentUser?.email ?? "N/A"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Password: *********', // Displaying asterisks for security
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
}
