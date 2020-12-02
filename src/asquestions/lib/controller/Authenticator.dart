import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Authenticator();

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //User get CurrentUser => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
