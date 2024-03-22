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

  @override
  void initState() {
    super.initState();
    _dropdownValue = 'Select your gender';
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
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),

                // Date picker

                OutlinedButton(
                  onPressed: () async {
                    DateTime? selected = await showDatePicker(
                        context: context, firstDate: endDate, lastDate: today);
                    if (selected != null && selected != _selectedDate) {
                      setState(() {
                        _selectedDate = selected;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button background color
                    side: const BorderSide(color: Colors.white), // Border color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Button border radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black, // Icon color
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Select Birthday',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black, // Arrow icon color
                        ),
                      ],
                    ),
                  ),
                ),
                Text('Selected Birthday: ${_selectedDate.toString()}'),

                //multiple drop box

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
                        color: Colors.deepPurple, fontSize: 16.0),
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

                //user name verification

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
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username already taken!')));
                        return;
                      }
                    }

                    //email verification

                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text);

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
                            builder: (context) => const HomeScreen()));

                    // Inform the user that a verification email has been sent
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Verification email sent"),
                    ));
                  } catch (error) {
                    print("Error ${error.toString()}");
                    // Handle registration or verification errors
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error: ${error.toString()}"),
                    ));
                  }
                })
              ],
            ),
          ))),
    );
  }
}
