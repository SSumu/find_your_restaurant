import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerForm extends StatefulWidget {
  CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String message = "";
  bool _registrationSuccessful = false;

  TextStyle successTextStyle = const TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  TextStyle errorTextStyle = const TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );

  _CustomerFormState() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null && _registrationSuccessful) {
        setState(() {
          message = "Registration successful";
        });
      }
    });
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await addUserData(name, email);

      setState(() {
        _registrationSuccessful = true;
      });

      await Future.delayed(Duration(microseconds: 100));

      setState(() {
        message = 'Registration successful';
      });
    } catch (signInError) {
      try {
        // If signInWithEmailAndPassword fails, proceed with user registration
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // String name = nameController.text;
        await addUserData(name, email);

        setState(() {
          _registrationSuccessful = true;
          message = 'Registration successful';
        });
      } catch (e) {
        print("Error creating user: $e");

        setState(() {
          message = "Registration unsuccessful: $e";
        });
      }
    }
  }

  Future<void> addUserData(String name, String email) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          "name": name,
          "email": email,
        });
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print("Failed to add user data: $e");
    }
  }

  Future<void> _registerUser() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await registerUser(email, password, name);
      // await addUserData(name, email);

      setState(() {
        message = 'Registration successful';
      });
    } catch (e) {
      print('Error in _registerUser: $e');

      setState(() {
        message = 'Registration unsuccessful: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 4.0,
                color: Colors.pink,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/images/156757283_Bedford_Hotel__F_B__Botanica_Restaurant_and_Bar__General_View._4500x3000.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Customer experience 1.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: message.isEmpty,
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 38, 76, 200),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 38, 76, 200),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ElevatedButton(
                        onPressed:
                            _registrationSuccessful ? null : _registerUser,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (message.isNotEmpty)
            Center(
              child: Text(
                message,
                style: message.contains('successful')
                    ? successTextStyle
                    : errorTextStyle,
              ),
            )
        ],
      ),
    );
  }
}
