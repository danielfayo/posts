import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posts/models/profile_details.dart';

Future<ProfileDetails> getProfileDetails(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

  return ProfileDetails(
    email: doc["email"],
    name: doc["name"],
    profilePhoto: doc["profilePhoto"],
    uid: doc["uid"],
  );
}
