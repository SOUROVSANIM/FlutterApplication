import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/graphql_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/rating_screen.dart';
import 'package:flutter_application_1/screens/restfulapi_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About App',
          style: TextStyle(
            color: Colors.white, // Set text color
          ),
        ),
        backgroundColor: Colors.blue, // Set AppBar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Make text italic
                color: Colors.purple, // Set text color
              ),
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
              icon: Icon(Icons.star), // Star icon for rating
              onPressed: () {
                _showSnackbar(
                    'App Rating'); // Show snackbar when button is pressed
                Navigator.push(
                  // Navigate to RatingScreen
                  context,
                  MaterialPageRoute(builder: (context) => RatingScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add), // Add icon for some action
              onPressed: () {
                _showSnackbar(
                    'GraphQL'); // Show snackbar when button is pressed
                Navigator.push(
                  // Navigate to RatingScreen
                  context,
                  MaterialPageRoute(builder: (context) => GraphQlScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.api), // API icon for RESTful API
              onPressed: () {
                _showSnackbar(
                    'Restful API'); // Show snackbar when button is pressed
                Navigator.push(
                  // Navigate to RestfulApiScreen
                  context,
                  MaterialPageRoute(builder: (context) => RestFullScreen()),
                );
              },
            ),
          ],
        ),
        color: Colors.blue, // Set BottomAppBar color
      ),
    );
  }

  // Function to show a snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
