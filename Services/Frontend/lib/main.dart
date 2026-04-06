import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko/viewmodels/auth_viewmodel.dart';
import 'package:toko/viewmodels/post_viewmodel.dart';
import 'package:toko/views/home_view.dart';
import 'package:toko/views/login_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final key = await SharedPreferences.getInstance();
  final status = key.getBool("statusLogin") ?? false;

  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthViewmodel()),
      ChangeNotifierProvider(create: (_) => PostViewmodel())
    ],
    child: MyApp(statusLogin: status,),));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.statusLogin});
  bool statusLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auth",
      home: statusLogin ? HomeView() : LoginView(),
    );
  }
}

// ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['pesan']), backgroundColor: Colors.green,));
//php artisan serve --host=0.0.0.0 --port=8000
// http://10.0.2.2:8000/api
// {'Content-Type': 'application/json'}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
