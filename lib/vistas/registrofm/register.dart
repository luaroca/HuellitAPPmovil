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
      backgroundColor: const Color(0xFFA8E6CF), // Verde agua claro
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Ícono principal
                CircleAvatar(
                  backgroundColor: const Color(0xFFFFDFA5),
                  radius: 50,
                  child: const Icon(Icons.groups, color: Color(0xFFFFAE35), size: 60),
                ),

                const SizedBox(height: 24),

                // Título
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Únete a la familia Huellitas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Contenedor del formulario
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
                      // Campo Nombres
                      TextField(
                        controller: nombresController,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          prefixIcon: const Icon(Icons.person, color: Color(0xFFFFAE35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 16),

                      // Campo Apellidos
                      TextField(
                        controller: apellidosController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          prefixIcon: const Icon(Icons.badge, color: Color(0xFFFFAE35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 16),

                      // Campo Correo
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          prefixIcon: const Icon(Icons.email, color: Color(0xFFFFAE35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 16),

                      // Campo Teléfono
                      TextField(
                        controller: telefonoController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          prefixIcon: const Icon(Icons.phone, color: Color(0xFFFFAE35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 16),

                      // Campo Contraseña
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFAE35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 28),

                      // Botón principal
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFAE35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            authController.register(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              nombres: nombresController.text.trim(),
                              apellidos: apellidosController.text.trim(),
                              telefono: telefonoController.text.trim(),
                            );
                          },
                          child: const Text(
                            'Crear Cuenta',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Enlace a inicio de sesión
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            '¿Ya tienes cuenta? Inicia Sesión',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 18,
                              decoration: TextDecoration.underline,
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
