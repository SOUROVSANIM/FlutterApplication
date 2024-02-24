import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/aboutapp_screen.dart';
import 'package:flutter_application_1/screens/camera_screen.dart';
import 'package:flutter_application_1/screens/createpost_screen.dart';
import 'package:flutter_application_1/screens/people_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              // Handle the "Map" button press
              _showSnackbar('Map');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
              // Add navigation to the MapScreen or your map-related logic
            },
          ),
          IconButton(
            icon: Icon(Icons.post_add),
            onPressed: () {
              _showSnackbar('Create Post');
              // Handle the "Create Post" button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _showSnackbar('Profile');
              // Handle the "Profile" button press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Sign out logic
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }).catchError((error) {
                print("Error signing out: $error");
                // Handle error if sign-out fails
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Placeholder content
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                _showSnackbar('Camera');
                // Handle the "Camera" button press
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                _showSnackbar('People');
                // Handle the "People" button press
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PeopleScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Handle the "About App" button press
                _showSnackbar('About App');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutAppScreen()),
                );
              },
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
