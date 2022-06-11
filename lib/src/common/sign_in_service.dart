import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthException implements Exception {
  const AuthException(this.msg);
  final String msg;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anonymously
  Future<User?> signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          throw const AuthException(
              "Anonymous auth hasn't been enabled for this project.");

        default:
          throw const AuthException("Sorry for inconvenience!!");
      }
    }
  }
}
