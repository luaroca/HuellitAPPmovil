import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF), // Verde agua claro
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Logo
                CircleAvatar(
                  backgroundColor: const Color(0xFFFFDFA5),
                  radius: 50,
                  child: const Icon(Icons.pets, color: Color(0xFFFFAE35), size: 60),
                ),

                const SizedBox(height: 28),

                // Título principal
                const Text(
                  'Bienvenido a Huellitas',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Subtítulo
                const Text(
                  'Inicia sesión para ayudar a rescatar y proteger animales',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // Contenedor principal
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFFFFF9ED),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Campo email
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 22),

                      // Campo contraseña
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 28),

                      // Botón de iniciar sesión
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFAE35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Línea divisoria
                      Row(
                        children: const [
                          Expanded(child: Divider(thickness: 1.2)),
                          Text(
                            "  ¿No tienes una cuenta?  ",
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Expanded(child: Divider(thickness: 1.2)),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Botón de crear cuenta
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Color(0xFFFFAE35), width: 2),
                          ),
                          child: const Text(
                            'Crear cuenta nueva',
                            style: TextStyle(
                              color: Color(0xFFFFAE35),
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
