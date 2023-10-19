import 'package:logger/logger.dart';

class Post {
  final int id;
  String name;
  String description;
  int nices;
  final DateTime createdAt;
  List<Post> replies;

  Post({
    required this.id,
    required this.name,
    required this.description,
    required this.nices,
    required this.createdAt,
    required this.replies,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<dynamic> replies = json['replies'] ?? [];
    List<Post> rep = replies.isNotEmpty
        ? replies.map((e) {
            Logger().d(e);
            return Post.fromJson(e);
          }).toList()
        : [];
    return Post(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        nices: json['nices'],
        createdAt: DateTime.parse(json['created_at']),
        replies: rep);
  }
}
