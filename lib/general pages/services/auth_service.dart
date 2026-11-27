import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box _settings = Hive.box('settings');

  Future<void>? _googleInitialization;

  // ================= GOOGLE INITIALIZATION =================

  Future<void> _initializeGoogle() {
    return _googleInitialization ??= GoogleSignIn.instance.initialize(
      serverClientId:
          '802161278448-tnqv7qlgigmm0hujue8ubd2norfuvn92.apps.googleusercontent.com',
    );
  }

  // ================= EMAIL SIGN UP =================

  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;

    await user.updateDisplayName(name.trim());

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': name.trim(),
      'email': email.trim(),
      'role': role,
      'photoUrl': '',
      'phoneNumber': '',
      'bio': '',
      'isEmailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await user.sendEmailVerification();

    return credential;
  }

  // ================= EMAIL LOGIN =================

  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ================= GOOGLE SIGN UP / LOGIN =================

  Future<UserCredential> signInWithGoogle({String? role}) async {
    await _initializeGoogle();

    final googleUser = await GoogleSignIn.instance.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(
      credential,
    );

    final user = userCredential.user!;

    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      if (role == null) {
        await _auth.signOut();

        throw Exception('No profile found. Please sign up first.');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': user.displayName ?? '',
        'email': user.email ?? '',
        'role': role,
        'photoUrl': user.photoURL ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'bio': '',
        'isEmailVerified': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential;
  }

  // ================= GET USER ROLE =================

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return doc.data()?['role'] as String?;
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await _auth.signOut();

    await _settings.put('remember_me', false);
  }

  User? get currentUser => _auth.currentUser;

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ================= GET USER NAME =================

  Future<String> getStudentName() async {
    final user = _auth.currentUser;

    if (user == null) return 'Student';

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return 'Student';

    return doc.data()?['fullName'] as String? ?? 'Student';
  }

  // ================= REMEMBER ME =================

  Future<void> setRememberMe(bool value) async {
    await _settings.put('remember_me', value);
  }

  bool getRememberMe() {
    return _settings.get('remember_me', defaultValue: false);
  }

  // ================= RESTORE SESSION =================

  Future<User?> restoreSession() async {
    final rememberMe = getRememberMe();

    if (!rememberMe) {
      await _auth.signOut();
      return null;
    }

    return _auth.currentUser;
  }
}
