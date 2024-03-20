import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/aboutapp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rating: $rating',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 32),
            TextButton(
              child: Text(
                'Show Dialog',
                style: TextStyle(fontSize: 32),
              ),
              onPressed: () => showRatingDialog(),
            ),
          ],
        ),
      ),
    );
  }

  void showRatingDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Rating This App'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Please leave a star rating.',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 32),
              buildRating(),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

  Widget buildRating() => RatingBar.builder(
        initialRating: rating,
        minRating: 1,
        itemSize: 46,
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      );
}
