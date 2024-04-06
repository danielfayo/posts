import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/main.dart';
import 'package:posts/widgets/primary_button.dart';
import 'package:posts/widgets/toast.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            "name": user.displayName,
            "email": user.email,
            "profilePhoto": user.photoURL
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        Toast(
            toastType: ToastType.descructive,
            toastText: "Something went wrong"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.00,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 26, horizontal: 24),
                    decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(99)),
                    width: 80,
                    height: 80,
                    child: SvgPicture.asset(
                      "images/vector.svg",
                      semanticsLabel: "logo",
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Posts",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Share ideas with the world",
                    style: TextStyle(
                      color: kGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  PrimaryButton(
                    text: "Sign in with Google",
                    isGoogle: true,
                    onPressed: () {
                      signInWithGoogle(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "By signing up you are agreeing to our",
                        style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kGray,
                        )),
                        children: const [
                          TextSpan(
                            text: " safety guidelines.",
                            style: TextStyle(
                              color: kPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
