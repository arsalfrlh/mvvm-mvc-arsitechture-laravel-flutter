import 'package:toko/models/post_image.dart';
import 'package:toko/models/user.dart';

class Post {
  final int id;
  final String caption;
  final DateTime? createAt;
  final User? user;
  final List<PostImage> postImage;

  Post({required this.id, required this.caption, this.createAt, this.user, required this.postImage});
  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'],
      caption: json['caption'],
      createAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      postImage: (json['post_image'] as List).map((item) => PostImage.fromJson(item)).toList()
    );
  }
}
