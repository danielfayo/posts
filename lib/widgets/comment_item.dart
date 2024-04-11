import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/comment.dart';
import 'package:posts/utilites/format_time.dart';
import 'package:posts/utilites/get_profile_detals.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  String _photoUrl = "";
  String _name = "";

  @override
  void initState() {
    super.initState();

    getProfileDetails(widget.comment.commentOwnerId).then((value) {
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
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                formatFromNow(widget.comment.commentTime),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.comment.commentText,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
