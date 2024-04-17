import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/widgets/toast.dart';
import 'package:provider/provider.dart';

class PostOptionsModal extends StatelessWidget {
  const PostOptionsModal(
      {super.key, required this.userOwnsPost, required this.post});

  final bool userOwnsPost;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OptionButton(
            label: "Share",
            isDestructive: false,
            onPressed: () {},
          ),
          OptionButton(
            label: "Save",
            isDestructive: false,
            onPressed: () {},
          ),
          Visibility(
            visible: userOwnsPost,
            child: OptionButton(
              label: "Delete",
              isDestructive: true,
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Center(
                    child: SingleChildScrollView(
                      child: DeleteDialog(
                        post: post,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    this.onPressed,
    required this.label,
    required this.isDestructive,
  });

  final void Function()? onPressed;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor:
            MaterialStatePropertyAll(isDestructive ? kDestructive : kBlack),
        alignment: Alignment.centerLeft,
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, required this.post});
  final _db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final Post post;

  void _handleDeletePost(Post post, BuildContext context) async {
    try {
      if (post.postImage.isNotEmpty) {
        await storage.ref(post.postId).child("postPhoto").delete();
      }
      await _db.collection("posts").doc(post.postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(Toast(
        toastType: ToastType.success,
        toastText: "Post deleted",
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(Toast(
        toastType: ToastType.descructive,
        toastText: "Something went wrong",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Are you absolutely sure?",
              style: TextStyle(
                  fontSize: 16, color: kBlack, fontWeight: FontWeight.w600),
            ),
            const Text(
              "This action will permanently delete this post.",
              style: TextStyle(
                  fontSize: 12, color: kGray, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(kBackground),
                    foregroundColor: MaterialStatePropertyAll(kPrimary),
                    elevation: MaterialStatePropertyAll(0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(kDestructive),
                    foregroundColor: MaterialStatePropertyAll(kWhite),
                    elevation: MaterialStatePropertyAll(0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Provider.of<PostProvider>(context, listen: false)
                        .deletePost(post);
                    _handleDeletePost(post, context);
                  },
                  child: const Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
