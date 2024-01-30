import 'package:find_your_restaurant/google_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:find_your_restaurant/ratings_&_reviews.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Companion',
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const Image(
          image: AssetImage(
              'assets/images/156757283_Bedford_Hotel__F_B__Botanica_Restaurant_and_Bar__General_View._4500x3000.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 1 tapped!');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserCustomGoogleMap(),
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints.expand(height: 134),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/Screenshot 2023-11-22 093831.png',
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Find Your Restaurant',
                            style: TextStyle(
                              color: Color.fromARGB(255, 50, 7, 207),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 33, 40, 243),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 2 tapped!');
                }
              },
              child: Container(
                constraints: const BoxConstraints.expand(height: 134),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/content9723.jpg',
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Book Your Table',
                            style: TextStyle(
                              color: Color.fromARGB(255, 252, 4, 4),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 232, 68, 68),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 3 tapped!');
                }
              },
              child: Container(
                constraints: const BoxConstraints.expand(height: 134),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/twkylfez1nn91.jpg',
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Prices & Discounts',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 234, 32),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 10, 174, 73),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 4 tapped!');
                }
              },
              child: Container(
                constraints: const BoxConstraints.expand(height: 134),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/unnamed-1024x669.jpg',
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Restaurant Information',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 252, 208, 12),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 5 tapped!');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RatingsAndReviews(),
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints.expand(height: 134),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/0_fjq8yWx1PL-hXw8J.jpg',
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Ratings & Reviews',
                            style: TextStyle(
                              color: Color.fromARGB(255, 196, 11, 247),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 216, 98, 239),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
