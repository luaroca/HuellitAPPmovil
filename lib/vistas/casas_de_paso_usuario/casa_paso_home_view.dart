import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/servicios/casa_paso_service.dart';
import 'package:huellitas/vistas/casas_de_paso_usuario/casa_paso_view.dart';
import 'casa_paso_home_widget.dart';

class CasaPasoHomeView extends StatefulWidget {
  const CasaPasoHomeView({Key? key}) : super(key: key);

  @override
  State<CasaPasoHomeView> createState() => _CasaPasoHomeViewState();
}

class _CasaPasoHomeViewState extends State<CasaPasoHomeView> {
  CasaPasoModel? casa;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      casa = await CasaPasoService.obtenerPorUserId(user.uid);
    }
    setState(() => loading = false);
  }

  void agregarCasa() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Get.to(() => CasaPasoView(userId: user.uid));
      await cargar();
    }
  }

  Future<void> eliminarCasaConfirmada() async {
    if (casa != null) {
      await CasaPasoService.eliminarPorId(casa!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa de paso eliminada exitosamente')),
        );
        await cargar();
      }
    }
  }

  void confirmarEliminarCasa() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Eliminar Casa de Paso',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          '¿Seguro que deseas eliminar tu casa de paso?',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(fontSize: 17)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar', style: TextStyle(fontSize: 17)),
            onPressed: () async {
              Navigator.pop(context);
              await eliminarCasaConfirmada();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CasaPasoHomeWidget(
      loading: loading,
      casa: casa,
      onAgregarCasa: agregarCasa,
      onEliminarCasa: confirmarEliminarCasa,
      onVolver: () => Navigator.pop(context),
    );
  }
}
