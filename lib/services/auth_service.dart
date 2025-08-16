import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  // New logout method to sign out
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  Future<String?> register(String email, String password, String name) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        await _db.collection('users').doc(cred.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Google Sign-In was canceled.';
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);

      // Null check added for safety
      if (userCred.additionalUserInfo != null && userCred.additionalUserInfo!.isNewUser) {
        await _db.collection('users').doc(userCred.user!.uid).set({
          'name': userCred.user!.displayName ?? '',
          'email': userCred.user!.email,
          'photoUrl': userCred.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unknown error occurred during Google Sign-In.';
    }
  }
}