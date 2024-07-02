import 'package:car_find/models/profile.dart';
import 'package:car_find/screens/bottom_nav.dart';
import 'package:car_find/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:car_find/components/my_text_field.dart';
import 'package:car_find/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'CarFind',
                      style: TextStyle(
                        fontSize: 52.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(offset: Offset(2, 2), color: Colors.black),
                          Shadow(offset: Offset(-2, 2), color: Colors.black),
                          Shadow(offset: Offset(2, -2), color: Colors.black),
                          Shadow(offset: Offset(-2, -2), color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 180.0,
                  ),
                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 32.0,
                    ),
                  ),
                  //
                  //
                  const SizedBox(height: 32.0),
                  //
                  //
                  MyTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  //
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  //
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  //
                  MyTextField(
                    controller: _confirmController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  //
                  const SizedBox(height: 16.0),
                  //
                  ElevatedButton(
                    onPressed: () async {
                      final username = _usernameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final confirmPassword = _confirmController.text.trim();

                      if (username.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Semua bagian harus terisi untuk register!')),
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Password tidak sesuai dengan Confirm Password')),
                        );
                        return;
                      }

                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        Profile profile =
                            Profile(username: username, noTelp: "");

                        await ProfileService.addProfile(
                            userCredential, profile);

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const BottomNav()),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('The password provided is too weak.')),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'The account already exists for that email.')),
                          );
                        } else if (e.code == 'invalid-email') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('The email address is not valid.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred: $e')),
                        );
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
