import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/registro_fm/register_form_widget.dart';


class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: RegisterFormWidget(authController: authController),
          ),
        ),
      ),
    );
  }
}
