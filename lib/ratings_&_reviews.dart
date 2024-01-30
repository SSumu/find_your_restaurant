import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingsAndReviews extends StatefulWidget {
  const RatingsAndReviews({super.key});

  @override
  State<RatingsAndReviews> createState() => _RatingsAndReviewsState();
}

class _RatingsAndReviewsState extends State<RatingsAndReviews> {
  double _rating = 0;
  TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ratings and Reviews',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.orange,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 181, 112, 27),
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/images/156757283_Bedford_Hotel__F_B__Botanica_Restaurant_and_Bar__General_View._4500x3000.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/star-rating-1.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Write a review...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (kDebugMode) {
                  print('Rating: $_rating');
                }
                if (kDebugMode) {
                  print(
                    'Reviews: ${_reviewController.text}',
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
