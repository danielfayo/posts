import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/screens/auth_screen.dart';
import 'package:posts/screens/create_post.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      floatingActionButton: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreatePostScreen()));
          },
          backgroundColor: kPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(
            "images/plus.svg",
            height: 17,
            width: 17,
            semanticsLabel: "plus",
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kWhite,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: kLines,
            height: 1,
          ),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 32,
          height: 32,
          child: SvgPicture.asset(
            "images/small-logo.svg",
            semanticsLabel: "logo",
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AuthScreen()));
            },
            child: Text("logout"),
          )
        ],
      )),
    );
  }
}
