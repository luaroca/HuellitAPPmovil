import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widget_mascotas_adopcion.dart';

class MascotasAdopcionView extends StatefulWidget {
  const MascotasAdopcionView({Key? key}) : super(key: key);

  @override
  State<MascotasAdopcionView> createState() => _MascotasAdopcionViewState();
}

class _MascotasAdopcionViewState extends State<MascotasAdopcionView> {
  final MascotaController controller = Get.find();

  String filtroTipo = 'Todos';
  String filtroGenero = 'Todos';
  String filtroTamanio = 'Todos';

  List<MascotaModel> _filtrarMascotas(List<MascotaModel> mascotas) {
    return mascotas.where((m) {
      if (!m.disponible) return false;
      if (filtroTipo != 'Todos' && m.tipo != filtroTipo) return false;
      if (filtroGenero != 'Todos' && m.genero != filtroGenero) return false;
      if (filtroTamanio != 'Todos' && m.tamanio != filtroTamanio) return false;
      return true;
    }).toList();
  }

  Future<void> _solicitarAdopcion(MascotaModel m) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Debes iniciar sesión para solicitar adopción');
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final usuarioData = userDoc.data() ?? {};

    await FirebaseFirestore.instance
        .collection('mascotas')
        .doc(m.id)
        .update({
      'solicitudAdopcion': true,
      'solicitudUid': user.uid,
      'nombreUsuarioSolicitud': usuarioData['nombres'] ?? '',
      'correoUsuarioSolicitud': usuarioData['email'] ?? user.email ?? '',
      'telefonoUsuarioSolicitud': usuarioData['telefono'] ?? '',
    });

   
  }

  @override
  Widget build(BuildContext context) {
    final tipos = ['Todos', 'Perro', 'Gato', 'Otro'];
    final generos = ['Todos', 'Macho', 'Hembra'];
    final tamanios = ['Todos', 'Pequeño', 'Mediano', 'Grande'];
    final user = FirebaseAuth.instance.currentUser;

    return Obx(() {
      final mascotas = controller.mascotas;
      final mascotasFiltradas = _filtrarMascotas(mascotas);

      return MascotasAdopcionWidget(
        filtroTipo: filtroTipo,
        filtroGenero: filtroGenero,
        filtroTamanio: filtroTamanio,
        tipos: tipos,
        generos: generos,
        tamanios: tamanios,
        mascotasFiltradas: mascotasFiltradas,
        user: user,
        onFiltroTipo: (v) => setState(() => filtroTipo = v ?? 'Todos'),
        onFiltroGenero: (v) => setState(() => filtroGenero = v ?? 'Todos'),
        onFiltroTamanio: (v) => setState(() => filtroTamanio = v ?? 'Todos'),
        onAdoptar: _solicitarAdopcion,
      );
    });
  }
}
