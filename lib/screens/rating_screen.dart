import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var _rating;
  late double averageRate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _calculateAverageRate();
  }

  void _calculateAverageRate() {
    FirebaseFirestore.instance
        .collection('ratings')
        .get()
        .then((querySnapshot) {
      double total = 0;
      int count = 0;
      querySnapshot.docs.forEach((doc) {
        total += (doc.data()['rating'] as double);
        count++;
      });
      var average = total / count;
      setState(() {
        averageRate = average;
        isLoading = false;
      });
    });
  }

  Future<void> postRating(double rating) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      var currentUser = _auth.currentUser;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('ratings').doc(currentUser!.email).set({
        'rating': rating,
        'name': currentUser.email,
        'datePublished': DateTime.now(),
      });
    } catch (e) {
      print('Error posting rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Butterfly Detection App"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Please Rate Our App",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Total Rating: $averageRate',
                    style: const TextStyle(fontSize: 25),
                  ),
                  if (_rating == null)
                    const Text(
                      'Your Rating: 0 ',
                      style: TextStyle(fontSize: 25),
                    )
                  else
                    Text(
                      'Your Rating: $_rating ',
                      style: const TextStyle(fontSize: 25),
                    ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                      postRating(rating);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _calculateAverageRate();
                    },
                    child: const Text(
                      'Submit Rate',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
