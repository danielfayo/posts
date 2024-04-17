import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/comment.dart';
import 'package:posts/models/post.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/widgets/circular_loader.dart';
import 'package:posts/widgets/comment_item.dart';
import 'package:posts/widgets/text_input.dart';
import 'package:posts/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:xid/xid.dart';

class CommentModal extends StatefulWidget {
  const CommentModal({super.key, required this.post});

  final Post post;

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  String _commentText = "";
  final TextEditingController _commentController = TextEditingController();
  List<Comment> postComments = [];
  bool sendingReply = false;

  void _handleComment(Post post) async {
    Comment comment = Comment(
      commentText: _commentText,
      commentTime: Timestamp.now().millisecondsSinceEpoch,
      commentOwnerId: _auth.currentUser!.uid,
      commentId: Xid().toString(),
    );

    final postRef = _db.collection("posts").doc(post.postId);

    setState(() {
      sendingReply = true;
    });
    try {
      await postRef.update({
        "postComments": FieldValue.arrayUnion([comment.toJson()]),
      }).then((value) {
        Provider.of<PostProvider>(context, listen: false)
            .addComment(post, comment);
        setState(() {
          postComments.add(comment);
        });
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          Toast(
            toastType: ToastType.success,
            toastText: "Reply Sent",
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Toast(
          toastType: ToastType.descructive,
          toastText: "Something went wrong",
        ),
      );
    } finally {
      setState(() {
        sendingReply = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.post.postComments != null) {
      for (var eachComment in widget.post.postComments!) {
        setState(() {
          postComments.add(eachComment);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: kBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: kWhite,
              border: Border(bottom: BorderSide(color: kLines, width: 1)),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: const Text(
              "Comments",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            child: postComments.isEmpty
                ? const Center(
                    child: Text("This post has no comments"),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return CommentItem(comment: postComments[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: widget.post.postComments!.length,
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextInput(
                      controller: _commentController,
                      enabled: !sendingReply,
                      onChanged: (value) {
                        setState(() {
                          _commentText = value;
                        });
                      },
                      ),
                ),
                const SizedBox(
                  width: 16,
                ),
                sendingReply
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CircularLoader(),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_commentText.isNotEmpty) {
                            _handleComment(widget.post);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 32,
                          width: 64,
                          decoration: BoxDecoration(
                            color: _commentText.isEmpty ? kLines : kPrimary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Post",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: kWhite,
                              wordSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
