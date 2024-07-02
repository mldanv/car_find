import 'package:car_find/screens/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:car_find/components/my_text_field.dart';
import 'package:car_find/screens/sign_up_screen.dart';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
  clientId:
      '278603931501-bnqihe4etufcka8tkcse1fraf51i3qlg.apps.googleusercontent.com',
);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signInWIthGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({"username": 'username'});

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'CarFind',
                  style:
                      TextStyle(fontSize: 52.0, color: Colors.white, shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(-2, 2),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(2, -2),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(-2, -2),
                      color: Colors.black,
                    ),
                  ]),
                ),
                const Icon(
                  Icons.person,
                  size: 180.0,
                ),
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
                const SizedBox(height: 32.0),
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                //
                //
                const SizedBox(height: 24.0),
                //
                //
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }
                  },
                  child: const Text('LOGIN'),
                ),
                //
                const SizedBox(height: 16.0),
                const Text('OR'),
                const SizedBox(height: 16.0),
                //
                ElevatedButton.icon(
                  onPressed: _signInWIthGoogle,
                  icon: Image.asset(
                    'lib/assets/gicon.png',
                    height: 24,
                  ),
                  label: const Text(
                    'Login with Google',
                  ),
                ),
                //
                const SizedBox(height: 24.0),
                const Text('Don\'t have an account yet?'),
                //
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Register Here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
