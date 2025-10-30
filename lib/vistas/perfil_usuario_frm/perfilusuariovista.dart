import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/perfil_usuario_frm/perfil_widget.dart';


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
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFA8E6CF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: PerfilWidget(
          nombre: nombre,
          correo: correo,
          telefono: telefono,
          esAdmin: esAdmin,
          onLogout: () => authController.logout(),
        ),

       
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          selectedFontSize: 15,
          unselectedFontSize: 13,
          selectedItemColor: Colors.orange[800],
          unselectedItemColor: Colors.grey,
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
            final doc = await authController.firestore
                .collection('users')
                .doc(user.uid)
                .get();
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
        ),
      ),
    );
  }
}
