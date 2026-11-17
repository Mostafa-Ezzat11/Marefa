import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String photoUrl;
  final String phoneNumber;
  final String bio;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.photoUrl = '',
    this.phoneNumber = '',
    this.bio = '',
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      bio: data['bio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
    };
  }
}
