import 'dart:ui';
import 'package:find_your_restaurant/registration.dart';
import 'package:find_your_restaurant/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignIn extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: use_super_parameters
  SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 246, 245, 241),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Lacuisine_resto.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: isSmallScreen
                ? _FormContent(
                    onSignInSuccess: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Menu(),
                        ),
                      );
                    },
                    scaffoldKey: _scaffoldKey,
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: _FormContent(
                              onSignInSuccess: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Menu(),
                                  ),
                                );
                              },
                              scaffoldKey: _scaffoldKey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ignore: use_super_parameters
//   const _Logo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FlutterLogo(size: isSmallScreen ? 100 : 200),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             "Welcome to Flutter!",
//             textAlign: TextAlign.center,
//             style: isSmallScreen
//                 ? Theme.of(context).textTheme.headlineSmall
//                 : Theme.of(context)
//                     .textTheme
//                     .headlineMedium
//                     ?.copyWith(color: Colors.black),
//           ),
//         )
//       ],
//     );
//   }
// }

class _FormContent extends StatefulWidget {
  final VoidCallback onSignInSuccess;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _FormContent({
    required this.onSignInSuccess,
    required this.scaffoldKey,
  });

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isBlurred = false;
  bool _isFocused = false;

  // FocusNode _emailFocusNode = FocusNode();
  // FocusNode _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithFirebase(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      widget.onSignInSuccess();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          if (_isFocused) {
            setState(() {
              _isBlurred = false;
              _isFocused = false;
            });
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _isBlurred ? 10 : 0,
              sigmaY: _isBlurred ? 10 : 0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildTextField(
                  //   controller: _emailController,
                  //   labelText: 'Email',
                  //   hintText: 'Enter your email',
                  //   prefixIcon: const Icon(Icons.email_outlined),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Please enter your email";
                  //     }

                  //     bool emailValid = RegExp(
                  //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  //         .hasMatch(value);
                  //     if (!emailValid) {
                  //       return 'Please enter a valid email';
                  //     }

                  //     return null;
                  //   },
                  //   focusNode: _emailFocusNode,
                  // ),
                  // _gap(),
                  // _buildTextField(
                  //   controller: _passwordController,
                  //   labelText: 'Password',
                  //   hintText: 'Enter your password',
                  //   prefixIcon: const Icon(Icons.lock_outline_rounded),
                  //   suffixIcon: IconButton(
                  //     icon: Icon(_isPasswordVisible
                  //         ? Icons.visibility_off
                  //         : Icons.visibility),
                  //     onPressed: () {
                  //       setState(() {
                  //         _isPasswordVisible = !_isPasswordVisible;
                  //       });
                  //     },
                  //   ),
                  //   validator: (value) {
                  //     if (value != null && value.isNotEmpty) {
                  //       return 'Please enter a valid password';
                  //     }

                  //     if ((value?.length ?? 0) < 6) {
                  //       return 'Password must be at least 6 characters';
                  //     }
                  //     return null;
                  //   },
                  //   focusNode: _passwordFocusNode,
                  // ),
                  _gap(),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      // add email validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid email';
                      }

                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid password';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              _isPasswordVisible = !_isPasswordVisible;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  _gap(),
                  CheckboxListTile(
                    value: _rememberMe,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _rememberMe = value;
                      });
                    },
                    title: const Text(
                      'Remember me',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: Colors.transparent,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  _gap(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          // Call the callback on successful sign-in
                          // widget.onSignInSuccess();
                          await _signInWithFirebase(email, password);
                        }
                      },
                    ),
                  ),
                  _gap(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registration(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String labelText,
  //   required String hintText,
  //   required Icon prefixIcon,
  //   Widget? suffixIcon,
  //   String? Function(String?)? validator,
  //   required FocusNode focusNode,
  // }) {
  //   return Focus(
  //     onFocusChange: (hasFocus) {
  //       setState(() {
  //         _isFocused = hasFocus;
  //         if (!hasFocus) {
  //           _isBlurred = false;
  //         }
  //       });
  //     },
  //     child: TextFormField(
  //       controller: controller,
  //       validator: validator,
  //       focusNode: focusNode,
  //       obscureText: labelText.toLowerCase().contains('password')
  //           ? !_isPasswordVisible
  //           : false,
  //       decoration: InputDecoration(
  //         labelText: labelText,
  //         hintText: hintText,
  //         prefixIcon: prefixIcon,
  //         suffixIcon: suffixIcon,
  //         border: const OutlineInputBorder(),
  //         filled: true,
  //         fillColor: Colors.white.withOpacity(0.5),
  //       ),
  //     ),
  //   );
  // }

  Widget _gap() => const SizedBox(height: 16);
}
