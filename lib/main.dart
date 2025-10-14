
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:huellitas/vistas/home/home_view.dart';
import 'package:huellitas/vistas/loginform/login.dart';

import 'controllers/auth_controller.dart';
import 'vistas/registrofm/register.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Huellitas',
      initialRoute: '/login',
     getPages: [
  GetPage(name: '/login', page: () => LoginView()),
  GetPage(name: '/register', page: () => RegisterView()),
  GetPage(
    name: '/userHome',
    page: () {
      final args = Get.arguments as Map<String, dynamic>? ?? {};
      return HomeView(userName: args['userName'] ?? 'Usuario');
    },
  ),
 
],
    );
  }
}
