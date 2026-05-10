import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool get isLoggedIn => _auth.currentUser != null;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  String getErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return "The email address is badly formatted.";
        case 'user-disabled':
          return "This user account has been disabled.";
        case 'user-not-found':
          return "No user found with this email.";
        case 'wrong-password':
          return "Incorrect password, please try again.";
        case 'email-already-in-use':
          return "This email is already in use.";
        case 'weak-password':
          return "The password provided is too weak.";
        default:
          return "An unexpected error occurred. Please try again.";
      }
    }
    return e.toString();
  }

  Future<void> signUp({required String email, required String password}) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await sendVerificationEmail();
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveUserDataToFirestore({
    required String fullName,
    required String email,
    
  }) async {
    final currentUser = _auth.currentUser; 
  
  if (currentUser == null) return;

    try {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'uid': currentUser.uid,
        'full_name': fullName,
        'email': currentUser.email ?? email,
        'profile_pic_url': '',
        'bio_title': 'Undergraduate Student',
        'created_at': FieldValue.serverTimestamp(),
        'statistics': {
          'current_streak': 0,
          'longest_streak': 0,
          'completed_tasks_count': 0,
          'active_tasks_count': 0,
        },
        'preferences': {
          'notifications_enabled': true,
          'dark_mode_enabled': false,
          'privacy_policy_read': true,
        },
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> checkEmailVerified() async {
    await _auth.currentUser?.reload();
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
