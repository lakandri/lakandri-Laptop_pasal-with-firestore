// import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserwithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential crediential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return crediential.user;
    } catch (e) {
      // log("Error");
      print('error');
    }
    return null;
  }

  // login

  Future<User?> loginUserwithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential crediential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return crediential.user;
    } catch (e) {
      // log("Error");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('error');
    }
  }
}
