import 'package:intl/intl.dart';

class Post {
  final int id;
  final String name;
  final String description;
  final double emote;
  final DateTime postedAt;

  Post({
    required this.id,
    required this.name,
    required this.description,
    required this.emote,
    required this.postedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        name: "",
        description: json['description'],
        emote: 0.0,
        postedAt: DateTime.parse(json['input_at']));
  }
}
