import 'post_model.dart';

class User {
  int id;
  String name;
  List<Post> posts;
  User(this.id, this.name, this.posts);
}
