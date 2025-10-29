import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/donacion_controller.dart';
import 'package:huellitas/vistas/gestion_donacionform/gestion_donativos_widget.dart';

class GestionDonativosView extends StatelessWidget {
  const GestionDonativosView({super.key});

  @override
  Widget build(BuildContext context) {
    // Aseguramos una única instancia para esta vista
    final c = Get.put(DonacionController());

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF), // Fondo verde menta pastel
      appBar: AppBar(
        backgroundColor: const Color(0xFF5594A3),
        title: const Text(
          'Gestión de Donativos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.onInit(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Administra las donaciones recibidas',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      // Pasamos el controller al widget visual (el widget se encargará de sus Obx internos)
      body: GestionDonativosWidget(controller: c),
    );
  }
}
