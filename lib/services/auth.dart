// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase exposes the user's authentication state as a stream
class AuthService {
  // Listen to changes in the firebase user
  final userStream = FirebaseAuth.instance.authStateChanges();
  // Grab a single instance of the authentication state
  final user = FirebaseAuth.instance.currentUser;

  // Handle anonoymous authentiation
  Future<void> anonLogin() async {
    // Always useful to wrap in a try catch to use the FirebaseAuthException
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  // Sign out (of any provider)
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
