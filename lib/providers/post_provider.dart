import 'package:flutter/material.dart';

import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  void refreshPost() {
    _posts.clear();
    notifyListeners();
  }

  void setPosts(List<Post> posts) {
    _posts.clear();
    notifyListeners();
    _posts = posts;
    notifyListeners();
  }

  void addAllPost(List<Post> posts) {
    _posts.addAll(posts);
    notifyListeners();
  }

  void removePostAtIndex(int index) {
    _posts.removeAt(index);
    notifyListeners();
  }

  void updatePostAtIndex(int index, Post post) {
    _posts[index] = post;
    notifyListeners();
  }
}
