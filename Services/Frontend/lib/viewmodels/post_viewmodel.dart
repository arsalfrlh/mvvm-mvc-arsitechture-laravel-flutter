import 'package:flutter/foundation.dart';
import 'package:toko/models/post.dart';
import 'package:toko/models/post_image.dart';
import 'package:toko/models/user.dart';
import 'package:toko/services/api_service.dart';

class PostViewmodel extends ChangeNotifier {
  final _apiService = ApiService();
  User? currentUser;
  List<Post> postList = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isAction = false;
  bool isFetchMore = false;
  String? message;

  Future<void> fetchPost() async {
    isLoading = true;
    notifyListeners();
    final response = await _apiService.getAllPost(1);
    postList = (response['data']['post'] as List).map((item) => Post.fromJson(item)).toList();
    currentPage = response['data']['pagination']['current_page'] ?? 1;
    lastPage = response['data']['pagination']['last_page'] ?? 1;
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePost()async{
    if(currentPage >= lastPage || isFetchMore) return;
    isFetchMore = true;
    notifyListeners();
    final response = await _apiService.getAllPost(currentPage + 1);
    postList.addAll((response['data']['post'] as List).map((item) => Post.fromJson(item)).toList());
    currentPage = response['data']['pagination']['current_page'] ?? 1;
    lastPage = response['data']['pagination']['last_page'] ?? 1;
    isFetchMore = false;
    notifyListeners();
  }

  Future<bool> addPost(String caption, List<String> imagePaths)async{
    isAction = true;
    message = null;
    notifyListeners();
    final newPost = Post(
      id: 0,
      caption: caption,
      postImage: imagePaths.map((item) => PostImage(id: 0, imagePath: item)).toList()
    );
    final response = await _apiService.addPost(newPost);
    if(response['success'] == true){
      postList.add(Post.fromJson(response['data']));
    }
    message = response['message'];
    isAction = false;
    notifyListeners();
    return(response['success'] as bool);
  }
}
