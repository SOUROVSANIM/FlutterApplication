import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/aboutapp_screen.dart';
import 'package:flutter_application_1/screens/camera_screen.dart';
import 'package:flutter_application_1/screens/createpost_screen.dart';
import 'package:flutter_application_1/screens/map_screen.dart';
import 'package:flutter_application_1/screens/people_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/screens/youtube_player_screen.dart.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override

//add animation and GSAP

  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Duration of the animation
    );

    // Curved animation for smoother transition
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white, // Set text color
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.post_add),
            onPressed: () {
              _showSnackbar('Create Post');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              _showSnackbar('Map');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _showSnackbar('Profile');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }).catchError((error) {
                print("Error signing out: $error");
              });
            },
          ),
        ],
        backgroundColor: Colors.blue, // Set AppBar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          // add GSAP & SASS

          children: [
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Welcome to Our App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, // Make text italic
                  color: Colors.purple, // Set text color
                ),
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
              icon: Icon(Icons.camera),
              onPressed: () async {
                print("Hello)=");

                await availableCameras().then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetectionScreen(
                          //cameras: value,
                          ),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.video_library),
              onPressed: () {
                _showSnackbar('Video');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoutubePlayerScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                _showSnackbar('People');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PeopleScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _showSnackbar('About App');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutAppScreen()),
                );
              },
            ),
          ],
        ),
        color: Colors.blue, // Set BottomAppBar color
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
