import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart'; // Import your HomeScreen
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart'; // Import your reusable widgets
import 'package:flutter_application_1/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  final DateTime today = DateTime.now();
  final DateTime endDate =
      DateTime.now().subtract(const Duration(days: 365 * 30));
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = '';
  late String _dropdownValue;
  bool _isUsernameAvailable = true;

  @override
  void initState() {
    super.initState();
    _dropdownValue = 'Select your gender';
  }

  void checkUsernameAvailability(String username) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .get();
    setState(() {
      _isUsernameAvailable = !userDoc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("C82893"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                  checkUsernameAvailability,
                ),
                if (!_isUsernameAvailable)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Username is already taken!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  (value) {},
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                  (value) {},
                ),
                const SizedBox(height: 20),

                // Date picker
                OutlinedButton(
                  onPressed: () async {
                    DateTime? selected = await showDatePicker(
                      context: context,
                      firstDate: endDate,
                      lastDate: today,
                    );
                    if (selected != null && selected != _selectedDate) {
                      setState(() {
                        _selectedDate = selected;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Select Birthday',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                Text('Selected Birthday: ${_selectedDate.toString()}'),

                // Gender dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16.0,
                    ),
                    underline: Container(), // Remove underline
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                        _selectedGender = newValue;
                      });
                    },
                    items: <String>[
                      'Select your gender',
                      'Male',
                      'Female',
                      'Other'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),
                signInSignUpButton(context, false, () async {
                  try {
                    String username = _userNameTextController.text.trim();

                    // Check if the username already exists
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .get();

                    if (userDoc.exists) {
                      setState(() {
                        _isUsernameAvailable = false;
                      });
                      return;
                    } else {
                      setState(() {
                        _isUsernameAvailable = true;
                      });
                    }

                    // Create user with email and password
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailTextController.text.trim(),
                      password: _passwordTextController.text,
                    );

                    // Send email verification
                    await userCredential.user!.sendEmailVerification();

                    // Save user data in firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .set({
                      'email': _emailTextController.text.trim(),
                      'uid': userCredential.user!.uid,
                      'timestamp': Timestamp.now(),
                      'gender': _selectedGender,
                      'date_of_birth': _selectedDate,
                    });

                    print("Created New Account");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );

                    // Inform the user that a verification email has been sent
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification email sent"),
                      ),
                    );
                  } catch (error) {
                    print("Error ${error.toString()}");
                    // Handle registration or verification errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: ${error.toString()}"),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget reusableTextField(String hintText, IconData icon, bool isPasswordType,
    TextEditingController controller, Function(String) onChanged) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 4,
          blurRadius: 4,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hintText,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    ),
  );
}

Widget signInSignUpButton(BuildContext context, bool isLogin, Function onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            hexStringToColor("C82893"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          isLogin ? "Log In" : "Sign Up",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );
}

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
