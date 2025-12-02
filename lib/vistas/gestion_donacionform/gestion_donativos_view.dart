import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/donacion_controller.dart';
import 'package:huellitas/vistas/gestion_donacionform/gestion_donativos_widget.dart';

class GestionDonativosView extends StatelessWidget {
  const GestionDonativosView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DonacionController());

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5594A3),
        centerTitle: true,
        title: const Text(
          'Gestión de Donativos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestionDonativosWidget(controller: c),
    );
  }
}
