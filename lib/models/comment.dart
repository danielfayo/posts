class Comment {
  factory Comment.fromMap(Map<String, dynamic> commentData) {
    return Comment(
      commentId: commentData["commentId"],
      commentText: commentData["commentText"],
      commentTime: commentData["commentTime"],
      commentOwnerId: commentData["commentOwnerId"],
    );
  }

  toJson() {
    return {
      "commentId": commentId,
      "commentText": commentText,
      "commentTime": commentTime,
      "commentOwnerId": commentOwnerId
    };
  }

  Comment({
    required this.commentText,
    required this.commentTime,
    required this.commentOwnerId,
    required this.commentId,
  });

  final String commentId;
  final String commentText;
  final String commentTime;
  final String commentOwnerId;
}
