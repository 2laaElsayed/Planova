import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserDocument() {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument() async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    return _firestore.collection('users').doc(user.uid).get();
  }

  Future<void> updateNotifications(bool enabled) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    await _firestore.collection('users').doc(user.uid).update({
      'preferences.notifications_enabled': enabled,
    });
  }

  Future<void> updateUsername(String username) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    await _firestore.collection('users').doc(user.uid).update({
      'full_name': username,
    });
  }

  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);
    await _firestore.collection('users').doc(user.uid).update({
      'email': newEmail,
    });
  }

  Future<void> updateProfileImageUrl(String imageUrl) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    await _firestore.collection('users').doc(user.uid).update({
      'profile_pic_url': imageUrl,
    });
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
    await _firestore.collection('users').doc(user.uid).update({
      'passwordChangedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteUserDocument() async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }
    await _firestore.collection('users').doc(user.uid).delete();
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No authenticated user available');
    }

    final uid = user.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final profileUrl = (userDoc.data()?['profile_pic_url'] as String?) ?? '';

    if (profileUrl.isNotEmpty) {
      await _deleteProfileImage(profileUrl);
    }

    await _firestore.collection('users').doc(uid).delete();
    await user.delete();
  }

  Future<void> _deleteProfileImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (_) {
      // Ignore errors when the profile image is not a storage reference or already deleted.
    }
  }
}
