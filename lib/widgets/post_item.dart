import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/models/profile_details.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/utilites/get_profile_detals.dart';
import 'package:posts/widgets/toast.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, required this.post});

  final Post post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String formatFromNow(int milliseconds) {
    DateTime then = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    DateTime now = DateTime.now();
    Duration difference = now.difference(then);

    int seconds = difference.inSeconds;
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    int days = (hours / 24).floor();
    int weeks = (days / 7).floor();

    String fromNowText;
    if (weeks > 0) {
      fromNowText = weeks == 1 ? '$weeks week ago' : '$weeks weeks ago';
    } else if (days > 0) {
      fromNowText = days == 1 ? '$days day ago' : '$days days ago';
    } else if (hours > 0) {
      fromNowText = hours == 1 ? '$hours hour ago' : '$hours hours ago';
    } else if (minutes > 0) {
      fromNowText =
          minutes == 1 ? '$minutes minute ago' : '$minutes minutes ago';
    } else if (seconds > 0) {
      fromNowText =
          seconds == 1 ? '$seconds second ago' : '$seconds seconds ago';
    } else {
      fromNowText = "Just now";
    }
    return fromNowText;
  }

  Future<void> handleLikingPost(Post post, String uid) async {
    final postRef = _db.collection("posts").doc(post.postId);

    try {
      if (post.postLikes == null || !post.postLikes!.contains(uid)) {
        await postRef.update({
          "postLikes": FieldValue.arrayUnion([uid]),
          "likeCount": FieldValue.increment(1)
        });
      } else {
        await postRef.update({
          "postLikes": FieldValue.arrayRemove([uid]),
          "likeCount": FieldValue.increment(-1)
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Toast(
          toastType: ToastType.descructive,
          toastText: "Something went wrong",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kLines, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: getProfileDetails(widget.post.postOwnerId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("");
                    }
                    ProfileDetails details = snapshot.data!;
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            details.profilePhoto,
                            height: 18,
                            width: 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(details.name,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    );
                  },
                ),
                Text(
                  formatFromNow(widget.post.postTime),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
              visible: widget.post.postText.isNotEmpty,
              child: Text(
                widget.post.postText,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Visibility(
              visible: widget.post.postImage.isNotEmpty,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Image.network(
                    widget.post.postImage,
                    width: double.infinity,
                    height: 224,
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "${widget.post.likeCount} Likes • ${widget.post.postComments?.length ?? 0} Comments",
              style: const TextStyle(
                  color: kGray, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        handleLikingPost(widget.post, _auth.currentUser!.uid)
                            .then((value) {
                          Provider.of<PostProvider>(context, listen: false)
                              .likeOrUnlikePost(
                                  widget.post, _auth.currentUser!.uid);
                        });
                      },
                      child: (widget.post.postLikes != null &&
                              widget.post.postLikes!
                                  .contains(_auth.currentUser!.uid))
                          ? SvgPicture.asset(
                              "images/filled-heart.svg",
                              semanticsLabel: "heart",
                              height: 18,
                              width: 18,
                            )
                          : SvgPicture.asset(
                              "images/heart.svg",
                              semanticsLabel: "heart",
                              height: 18,
                              width: 18,
                            ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset(
                      "images/comment.svg",
                      semanticsLabel: "heart",
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
                SvgPicture.asset(
                  "images/options.svg",
                  semanticsLabel: "options",
                  height: 6,
                  width: 12,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
