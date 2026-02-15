import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko/view/audio_view.dart';
import 'package:toko/view/barang_page.dart';
import 'package:toko/view/home_view.dart';
import 'package:toko/view/login_view.dart';
import 'package:toko/view/video_view.dart';
import 'package:toko/viewmodels/audio_viewmodel.dart';
import 'package:toko/viewmodels/auth_viewmodel.dart';
import 'package:toko/viewmodels/barang_viewmodel.dart';
import 'package:toko/viewmodels/video_viewmodel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final key = await SharedPreferences.getInstance();
  final status = key.getBool('statusLogin') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthViewmodel()), //tambahkan class view model di main
      ChangeNotifierProvider(create: (_) => BarangViewmodel()),
      ChangeNotifierProvider(create: (_) => AudioViewmodel()),
      ChangeNotifierProvider(create: (_) => VideoViewmodel())
    ],
    child: MyApp(status: status,),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({required this.status});
  bool status;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MVVM",
      home: status ? VideoView() : LoginView(),
    );
  }
}

//php artisan serve --host=0.0.0.0 --port=8000
// {'Content-Type': 'application/json'}
// http://192.168.1.245:8000
//192.168.1.245 cek dengan ipconfig di cmd
//http://10.0.2.2:8000/api khusus emulator

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }