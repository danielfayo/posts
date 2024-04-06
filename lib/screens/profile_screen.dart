import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kWhite,
        title: Text("Profile"),
      ),
    );
  }
}
