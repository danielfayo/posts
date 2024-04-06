import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posts/models/comment.dart';

class Post {
  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    final postComments = data?["comment"];
    return Post(
      postId: data?["postId"],
      postText: data?["postText"],
      postImage: data?["postImage"],
      postOwnerId: data?["postOwnerId"],
      postTime: data?["postTime"],
      likeCount: data?["likeCount"],
      postComments:
          List<Comment>.from(postComments.map((e) => Comment.fromMap(e))),
    );
  }

  toJson() {
    return {
      "postId": postId,
      "postText": postText,
      "postImage": postImage,
      "postOwnerId": postOwnerId,
      "postTime": postTime,
      "likeCount": likeCount,
      "postComments": postComments
    };
  }

  Post({
    required this.postText,
    required this.postImage,
    required this.postOwnerId,
    required this.postTime,
    required this.likeCount,
    required this.postComments,
    required this.postId,
  });

  final String postId;
  final String postText;
  final String postImage;
  final String postOwnerId;
  List<Comment> postComments;
  int likeCount;
  final Timestamp postTime;
}
