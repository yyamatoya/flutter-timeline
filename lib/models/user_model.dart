import 'package:logger/logger.dart';

import 'post_model.dart';

class User {
  final int id;
  final String name;
  final int posts;

  User({required this.id, required this.name, required this.posts});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      posts: json['posts'],
    );
  }
}
