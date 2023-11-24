// import 'dart:async';
// import 'package:find_your_restaurant/menu.dart';
// import 'package:find_your_restaurant/menu.dart';
// import 'package:find_your_restaurant/menu.dart';
import 'package:flutter/material.dart';
import 'package:find_your_restaurant/sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SignIn(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // const begin = Offset(1.0, 0.0);
              // const end = Offset.zero;
              // const curve = Curves.easeInOut;

              const begin = 0.0;
              const end = 1.0;

              final opacityTween = Tween<double>(begin: begin, end: end).chain(
                CurveTween(curve: Curves.easeInOut),
              );
              final opacityAnimation = animation.drive(opacityTween);

              return FadeTransition(
                opacity: opacityAnimation,
                child: child,
              );

              // final scaleTween = Tween<double>(begin: 0.0, end: 1.0);
              // final scaleAnimation = animation.drive(scaleTween);

              // final colorTween =
              //     ColorTween(begin: Colors.transparent, end: Colors.white);
              // final colorAnimation = animation.drive(colorTween);

              // return ScaleTransition(
              //   scale: scaleAnimation,
              //   child: FadeTransition(
              //     opacity: opacityAnimation,
              //     child: ClipOval(
              //       clipper: CircleRevealClipper(
              //         fraction: _animation.value,
              //         center: const Offset(0.5, 0.5),
              //       ),
              //       // opacity: animation,
              //       child: child,
              //     ),
              //   ),
              // );
            },
          ),
        );
      }
    });

    // Timer(
    //   const Duration(seconds: 3),
    //   () {
    //     Navigator.pushReplacement(
    //       context,
    //       // MaterialPageRoute(
    //       //   builder: (context) => const SignInPage(),
    //       // ),
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             const SignInPage(),
    //         transitionsBuilder:
    //             (context, animation, secondaryAnimation, child) {
    //           const begin = Offset(1.0, 0.0);
    //           const end = Offset.zero;
    //           const curve = Curves.easeInOut;

    //           final tween = Tween(begin: begin, end: end).chain(
    //             CurveTween(curve: curve),
    //           );

    //           final offsetAnimation = animation.drive(tween);
    //           return SlideTransition(
    //             position: offsetAnimation,
    //             child: FadeTransition(
    //               opacity: animation,
    //               child: child,
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/image_61fc4e997b.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to the Restaurant Companion!',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 24, 9),
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 0, 4, 212),
                        offset: Offset(5, 5),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipOval(
                clipper: CircleRevealClipper(
                  fraction: _animation.value,
                  center: const Offset(0.5, 0.5),
                ),
                // child: Container(
                //   color: const Color.fromARGB(255, 231, 11, 11),
                // ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double fraction;
  final Offset center;

  CircleRevealClipper({required this.fraction, required this.center});

  @override
  Rect getClip(Size size) {
    final radius = size.width * 1.5;
    final offset = Offset(center.dx * size.width, center.dy * size.height);

    return Rect.fromCircle(center: offset, radius: radius);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
