import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class PerfilUsuarioView extends StatelessWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final bool esAdmin;

  const PerfilUsuarioView({
    Key? key,
    required this.nombre,
    required this.correo,
    required this.telefono,
    this.esAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Sin color naranja arriba
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFFFF9ED),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Header tipo "Hola, camilo andres..."
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange[800],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(26, 20, 18, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texto izquierda
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hola,",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.93),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17)),
                              Text(nombre.toLowerCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 21,
                                  )),
                              const SizedBox(height: 2),
                              Text(
                                "Gracias por ser parte de la familia\nHuellitas 🐾",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.89),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.3),
                              ),
                              if (esAdmin)
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.19),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Administrador",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Icono huella a la derecha
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white.withOpacity(0.27),
                            child: const Icon(Icons.pets,
                                size: 28, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.13),
                        width: 1.1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Información Personal',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 11),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 21, color: Colors.black54),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(correo,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black87)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 11),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 21, color: Colors.black54),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(telefono,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black87)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => authController.logout(),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            if (esAdmin)
              const BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Donativos',
              )
            else
              const BottomNavigationBarItem(
                icon: Icon(Icons.pets),
                label: 'Adoptar',
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
          currentIndex: 2,
          onTap: (index) async {
            final user = authController.auth.currentUser;
            if (user == null) return;
            final doc =
                await authController.firestore.collection('users').doc(user.uid).get();
            final data = doc.data();
            if (data == null) return;
            final nombre = data['nombres'] ?? '';
            final esAdminUser = (data['role'] ?? '') == 'admin';

            if (index == 0) {
              if (esAdminUser) {
                Get.offAllNamed('/adminHome', arguments: {'adminName': nombre});
              } else {
                Get.offAllNamed('/userHome', arguments: {'userName': nombre});
              }
            } else if (index == 1) {
              if (esAdminUser) {
                Get.toNamed('/gestionDonativos');
              } else {
                Get.toNamed('/adoptar');
              }
            }
          },
          selectedItemColor: Colors.orange[800],
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
