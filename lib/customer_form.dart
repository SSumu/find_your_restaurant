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
    // bool isRegistrationSuccessful = false;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // String name = nameController.text;
      await addUserData(name, email);

      setState(() {
        _registrationSuccessful = true;
      });

      // _auth.authStateChanges().listen((User? user) {
      //   if (user != null) {
      //     setState(() {
      //       message = "Registration successful";
      //     });
      //   }
      // });

      // isRegistrationSuccessful = true;
    } catch (e) {
      print("Error creating user: $e");

      setState(() {
        message = "Registration unsuccessful: $e";
      });
    }

    // setState(() {
    //   message = isRegistrationSuccessful
    //       ? "Registration successful"
    //       : "Registration unsuccessful";
    // });
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
      await addUserData(name, email);
    } catch (e) {
      print('Error in _registerUser: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Customer Form',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.pink,
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.pink.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
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
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ElevatedButton(
                        // onPressed: () async {
                        //   String name = nameController.text;
                        //   String email = emailController.text;
                        //   String password = passwordController.text;

                        //   await registerUser(email, password, name);

                        //   // addUserData(name, email);
                        // },
                        onPressed: _registerUser,
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
