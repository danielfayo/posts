import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/comment.dart';
import 'package:posts/models/post.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/screens/auth_screen.dart';
import 'package:posts/screens/create_post.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _db = FirebaseFirestore.instance;

  void fetchPosts() async {
    try {
      
    
    await _db.collection("posts").get().then((querySnapsot) {
      for (var docSnapshot in querySnapsot.docs) {
        final postsData = Post.fromFirestore(
            docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
        List<Comment> comments = postsData.postComments;
        Post post = Post(
          postText: postsData.postText,
          postImage: postsData.postImage,
          postOwnerId: postsData.postOwnerId,
          postTime: postsData.postTime,
          likeCount: postsData.likeCount,
          postComments: comments,
          postId: postsData.postId,
          postLikes: postsData.postLikes,
        );
        Provider.of<PostProvider>(context, listen: false).addPost(post);
      }
    });
    } catch (e) {
      
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      floatingActionButton: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePostScreen()));
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
