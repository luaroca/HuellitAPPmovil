import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class RegisterFormWidget extends StatelessWidget {
  final AuthController authController;

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterFormWidget({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              _buildTextField(
                controller: nombresController,
                label: 'Nombres',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Campo Apellidos
              _buildTextField(
                controller: apellidosController,
                label: 'Apellidos',
                icon: Icons.badge,
              ),
              const SizedBox(height: 16),

              // Campo Correo
              _buildTextField(
                controller: emailController,
                label: 'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Campo Teléfono
              _buildTextField(
                controller: telefonoController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Campo Contraseña
              _buildTextField(
                controller: passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
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
    );
  }

  // 🔧 Campo de texto reutilizable
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18, color: Color(0xFF333333)),
        prefixIcon: Icon(icon, color: const Color(0xFFFFAE35)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}
