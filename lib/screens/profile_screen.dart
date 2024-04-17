import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/models/profile_details.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/widgets/circular_loader.dart';
import 'package:posts/widgets/post_item.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<ProfileDetails> _getProfile() async {
    final snapshot =
        await _db.collection("users").doc(_auth.currentUser!.uid).get();
    final ProfileDetails profileDetails = ProfileDetails(
      email: snapshot.data()?["email"],
      name: snapshot.data()?["name"],
      profilePhoto: snapshot.data()?["profilePhoto"],
      uid: snapshot.data()?["uid"],
    );
    return profileDetails;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const ErrorScrren();
          } else {
            final data = snapshot.data!;
            return Scaffold(
              backgroundColor: kBackground,
              appBar: ProfileAppBar(title: data.email),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: FadeInImage(
                        placeholder: const AssetImage("images/placeholder.png"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/placeholder.png',
                            fit: BoxFit.fitWidth,
                            width: 64,
                            height: 64,
                          );
                        },
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        image: Image.network(
                          data.profilePhoto,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      data.email,
                      style: const TextStyle(color: kGray, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      "Posts",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Consumer<PostProvider>(
                        builder: (context, postData, child) {
                          final List<Post> userPosts = postData.posts
                              .where((eachPost) =>
                                  eachPost.postOwnerId ==
                                  _auth.currentUser!.uid)
                              .toList();

                          if (userPosts.isEmpty) {
                            return const Center(
                              child: Text("You have no posts"),
                            );
                          }

                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            padding: const EdgeInsets.only(bottom: 16),
                            itemBuilder: (context, index) {
                              return PostItem(
                                post: userPosts[index],
                              );
                            },
                            itemCount: userPosts.length,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackground,
      appBar: ProfileAppBar(
        title: "Profile",
      ),
      body: SafeArea(
          child: Center(
        child: CircularLoader(),
      )),
    );
  }
}

class ErrorScrren extends StatelessWidget {
  const ErrorScrren({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackground,
      appBar: ProfileAppBar(
        title: "Profile",
      ),
      body: SafeArea(
          child: Center(
        child: Text("Something went wrong"),
      )),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhite,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: kLines,
          height: 1,
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
