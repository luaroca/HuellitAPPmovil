import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class LoginFormWidget extends StatelessWidget {
  final AuthController authController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginFormWidget({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),

        
        CircleAvatar(
          backgroundColor: const Color(0xFFFFDFA5),
          radius: 50,
          child: const Icon(Icons.pets, color: Color(0xFFFFAE35), size: 60),
        ),

        const SizedBox(height: 28),

        
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
             
              _buildTextField(
                controller: emailController,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 22),

             
              _buildTextField(
                controller: passwordController,
                label: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 28),

              
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
                    side: const BorderSide(
                      color: Color(0xFFFFAE35),
                      width: 2,
                    ),
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
    );
  }

  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}
