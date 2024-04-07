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
    // Future.microtask(() {
      notifyListeners();
    // });
  }
}
