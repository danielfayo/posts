import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/utilites/format_time.dart';
import 'package:posts/utilites/get_profile_detals.dart';
import 'package:posts/widgets/comment_modal.dart';
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
  String _photoUrl = "";
  String _name = "";

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
  void initState() {
    super.initState();

    getProfileDetails(widget.post.postOwnerId).then((value) {
      setState(() {
        _name = value.name;
        _photoUrl = value.profilePhoto;
      });
    });
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
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: _photoUrl.isNotEmpty && _name.isNotEmpty,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          _photoUrl,
                          height: 18,
                          width: 18,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(_name,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
              "${widget.post.likeCount} Like${widget.post.likeCount == 1 ? "" : "s"} • ${widget.post.postComments?.length ?? 0} Comment${(widget.post.postComments != null && widget.post.postComments!.length == 1) ? "" : "s"}",
              style: const TextStyle(
                  color: kGray, fontSize: 12, fontWeight: FontWeight.w600),
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
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 16),
                              child: SvgPicture.asset(
                                "images/filled-heart.svg",
                                semanticsLabel: "heart",
                                height: 18,
                                width: 18,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 16),
                              child: SvgPicture.asset(
                                "images/heart.svg",
                                semanticsLabel: "heart",
                                height: 18,
                                width: 18,
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => CommentModal(
                                  post: widget.post,
                                ),
                            enableDrag: true,
                            isScrollControlled: true,
                            useSafeArea: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 16),
                        child: SvgPicture.asset(
                          "images/comment.svg",
                          semanticsLabel: "comment",
                          height: 18,
                          width: 18,
                        ),
                      ),
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
