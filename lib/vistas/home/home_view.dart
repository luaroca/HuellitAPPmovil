import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'widget_home_body.dart';

class HomeView extends StatelessWidget {
  final String userName;
  const HomeView({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      // ---------- ELIMINADA la bottomNavigationBar ----------
      body: SafeArea(
        child: HomeBody(userName: userName),
      ),
    );
  }
}
