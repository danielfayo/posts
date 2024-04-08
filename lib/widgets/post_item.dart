import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/models/profile_details.dart';
import 'package:posts/utilites/get_profile_detals.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, required this.post});

  final Post post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

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
              children: [
                Image.network(
                    getProfileDetails(widget.post.postOwnerId).then((value) => value.profilePhoto) as String),
                Text(getProfileDetails(widget.post.postOwnerId).then((value) => value.name) as String)
              ],
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
              children: [
                SvgPicture.asset(
                  "images/heart.svg",
                  semanticsLabel: "heart",
                  height: 18,
                  width: 18,
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
            )
          ],
        ),
      ),
    );
  }
}
