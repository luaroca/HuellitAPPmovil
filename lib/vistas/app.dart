import 'package:flutter/material.dart';
import 'package:huellitas/vistas/loginform/login.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoginPage()
    );
  }
}