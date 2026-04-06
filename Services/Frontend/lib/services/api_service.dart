import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko/models/post.dart';
import 'package:toko/models/user.dart';

class ApiService {
  final dio = Dio(BaseOptions(
    baseUrl: "http://192.168.0.123:8000/api",
    sendTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20)
  ));
  
  ApiService(){
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async{
        final key = await SharedPreferences.getInstance();
        final token = key.getString("token");

        if(token != null){
          options.headers['Authorization'] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password)async{
    try{
      final response = await dio.post("/login", data: {
        "email": email,
        "password": password
      });

      if(response.data['success'] == true){
        final key = await SharedPreferences.getInstance();
        await key.setString("token", response.data['data']['token']);
        await key.setBool("statusLogin", true);
      }
      return response.data;
    }on DioException catch(e){
      return{
        "success": e.response?.data['success'] ?? false,
        "message": e.response?.data['message'].toString()
      };
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{
    try{
      final response = await dio.post("/register", data: {
        "name": name,
        "email": email,
        "password": password
      });

      return response.data;
    }on DioException catch(e){
      return{
        "success": false,
        "message": e.response?.data['message'].toString()
      };
    }
  }

  Future<Map<String, dynamic>> verify(int otp)async{
    try{
      final response = await dio.post("/verify", data: {
        "otp": otp
      });

      if(response.data['success'] == true){
        final key = await SharedPreferences.getInstance();
        await key.setString("token", response.data['data']['token']);
        await key.setBool("statusLogin", true);
      }
      return response.data;
    }on DioException catch(e){
      return{
        "success": false,
        "message": e.response?.data['message']
      };
    }
  }

  Future<User> currentUser()async{
    try{
      final response = await dio.get("/user");
      return User.fromJson(response.data);
    }on DioException catch(e){
      throw Exception(e.response);
    }
  }

  Future<Map<String, dynamic>> getAllPost(int page)async{
    try{
      final response = await dio.get("/post?page=$page");
      return response.data;
    }on DioException catch(e){
      return{
        "success": false,
        "message": e.response.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> addPost(Post post)async{
    try{
      List<MultipartFile> imagePaths = [];
      for(var image in post.postImage){
        imagePaths.add(await MultipartFile.fromFile(image.imagePath));
      }

      final request = FormData.fromMap({
        "caption": post.caption,
        "images[]": imagePaths
      });
      final response = await dio.post("/post", data: request);
      return response.data;
    }on DioException catch(e){
      return{
        "success": false,
        "message": e.response.toString()
      };
    }
  }
}
