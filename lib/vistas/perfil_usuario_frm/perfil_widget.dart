// perfil_widget.dart
import 'package:flutter/material.dart';

class PerfilWidget extends StatelessWidget {
  final String nombre;
  final String apellido;  // Nuevo parámetro
  final String correo;
  final String telefono;
  final bool esAdmin;
  final VoidCallback onLogout;

  const PerfilWidget({
    Key? key,
    required this.nombre,
    required this.apellido,  // Nuevo parámetro
    required this.correo,
    required this.telefono,
    required this.onLogout,
    this.esAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(26, 22, 18, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '$nombre $apellido'.toLowerCase(),  // Mostrar nombre y apellido juntos
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Gracias por ser parte de la comunidad',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              height: 1.4,
                            ),
                          ),
                          if (esAdmin)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Administrador',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      child: const Icon(
                        Icons.pets,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.18), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información Personal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Apellido
                    Row(
                      children: [
                        const Icon(Icons.account_circle_outlined,
                            size: 25, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            apellido,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Nombre
                    Row(
                      children: [
                        const Icon(Icons.person_outlined,
                            size: 25, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 25, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            correo,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, size: 25, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            telefono,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onLogout,
                        icon: const Icon(Icons.logout_rounded,
                            color: Colors.redAccent, size: 24),
                        label: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.redAccent, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
