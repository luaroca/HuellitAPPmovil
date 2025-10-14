import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find();

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icono y título
                const Icon(Icons.groups, size: 46, color: Color(0xff9c4dcc)),
                const SizedBox(height: 12),
                Text(
                  'Crear Cuenta',
                  style: TextStyle(fontSize: 28, color: Color(0xff9c4dcc), fontWeight: FontWeight.w600),
                ),
                const Text('Únete a la familia Huellitas', style: TextStyle(fontSize: 15, color: Colors.black54)),
                const SizedBox(height: 30),

                TextField(
                  controller: nombresController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    prefixIcon: Icon(Icons.badge),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xff9c4dcc),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      authController.register(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        nombres: nombresController.text.trim(),
                        apellidos: apellidosController.text.trim(),
                        telefono: telefonoController.text.trim(),
                      );
                    },
                    child: const Text('Crear Cuenta', style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Text('¿Ya tienes cuenta? Inicia Sesión', style: TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
