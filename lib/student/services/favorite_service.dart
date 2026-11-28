import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's favorites collection.
  CollectionReference<Map<String, dynamic>> get _favoritesCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User is not logged in.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
  }

  // Check if a course is in favorites.
  Future<bool> isFavorite(String courseId) async {
    final doc = await _favoritesCollection.doc(courseId).get();

    return doc.exists;
  }

  // Add course to favorites.
  Future<void> addFavorite(String courseId) async {
    await _favoritesCollection.doc(courseId).set({
      'courseId': courseId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove course from favorites.
  Future<void> removeFavorite(String courseId) async {
    await _favoritesCollection.doc(courseId).delete();
  }

  // Get all favorite course IDs.
  Future<List<String>> getFavoriteCourseIds() async {
    final snapshot = await _favoritesCollection.get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Listen to favorites changes.
  Stream<List<String>> watchFavoriteCourseIds() {
    return _favoritesCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }
}