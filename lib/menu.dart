import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Companion'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('Part 1 tapped!');
                }
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
                            'Find your restaurant',
                            style: TextStyle(
                              color: Color.fromARGB(255, 9, 0, 0),
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
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
                color: Colors.green,
                child: const Center(
                  child: Text('Part 2'),
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
                color: Colors.orange,
                child: const Center(
                  child: Text('Part 3'),
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
                color: Colors.purple,
                child: const Center(
                  child: Text('Part 4'),
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
              },
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text('Part 5'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
