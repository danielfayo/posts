import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDetails {
  factory ProfileDetails.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> profileData) {
    return ProfileDetails(
      email: profileData["email"],
      name: profileData["name"],
      profilePhoto: profileData["profilePhoto"],
      uid: profileData["uid"],
    );
  }
  ProfileDetails({
    required this.email,
    required this.name,
    required this.profilePhoto,
    required this.uid,
  });

  final String name;
  final String email;
  final String profilePhoto;
  final String uid;
}
