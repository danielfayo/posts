import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:posts/models/post.dart';

class PostProvider extends ChangeNotifier {
  final List<Post> _posts = [];

  UnmodifiableListView<Post> get posts {
    return UnmodifiableListView(_posts);
  }

  void addPost(Post newPost) {
    _posts.add(newPost);
      notifyListeners();
  }

  void likeOrUnlikePost(Post post, String uid){
    if (post.postLikes == null){
      post.likeCount+=1;
      post.postLikes = [uid];
    }
    if (post.postLikes!.contains(uid)){
      post.likeCount-=1;
      post.postLikes!.remove(uid);
    } else if (!post.postLikes!.contains(uid)){
      post.likeCount+=1;
      post.postLikes!.add(uid);
    }
    notifyListeners();
  }
}
