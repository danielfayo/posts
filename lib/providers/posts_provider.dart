import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:posts/models/comment.dart';
import 'package:posts/models/post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];

  UnmodifiableListView<Post> get posts {
    return UnmodifiableListView(_posts);
  }

  void addPost(Post newPost) {
    // _posts.add(newPost);
    _posts = [newPost, ..._posts];
    notifyListeners();
  }

  void likeOrUnlikePost(Post post, String uid) {
    if (post.postLikes == null) {
      post.likeCount += 1;
      post.postLikes = [uid];
    }
    if (post.postLikes!.contains(uid)) {
      post.likeCount -= 1;
      post.postLikes!.remove(uid);
    } else if (!post.postLikes!.contains(uid)) {
      post.likeCount += 1;
      post.postLikes!.add(uid);
    }
    notifyListeners();
  }

  void clearState() {
    _posts = [];
    Future.microtask(() {
      notifyListeners();
    });
  }

  void addComment(Post post, Comment comment) {
    if (post.postComments == null) {
      post.postComments = [comment];
    } else {
      post.postComments!.add(comment);
    }
    notifyListeners();
  }

  void deletePost(Post post) {
    _posts.remove(post);
    notifyListeners();
  }
}
