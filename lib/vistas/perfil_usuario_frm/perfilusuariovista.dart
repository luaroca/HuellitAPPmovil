// perfilusuariovista.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/perfil_usuario_frm/perfil_widget.dart';

class PerfilUsuarioView extends StatelessWidget {
  final String nombre;
  final String apellido;  // Nuevo parámetro
  final String correo;
  final String telefono;
  final bool esAdmin;

  const PerfilUsuarioView({
    Key? key,
    required this.nombre,
    required this.apellido,  // Nuevo parámetro
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
          apellido: apellido,  // Pasar nuevo parámetro
          correo: correo,
          telefono: telefono,
          esAdmin: esAdmin,
          onLogout: authController.logout,
        ),
      ),
    );
  }
}
