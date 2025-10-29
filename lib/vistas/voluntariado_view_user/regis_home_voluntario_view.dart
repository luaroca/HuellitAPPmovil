import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:huellitas/servicios/voluntario_service.dart';
import 'package:huellitas/vistas/voluntariado_view_user/registro_voluntario_view.dart';
import 'package:huellitas/vistas/voluntariado_view_user/widget_voluntariado_home.dart';

class VoluntariadoHomeView extends StatefulWidget {
  const VoluntariadoHomeView({Key? key}) : super(key: key);

  @override
  State<VoluntariadoHomeView> createState() => _VoluntariadoHomeViewState();
}

class _VoluntariadoHomeViewState extends State<VoluntariadoHomeView> {
  VoluntarioModel? voluntario;
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
      voluntario = await VoluntarioService.obtenerPorCorreo(user.email ?? '');
    }
    setState(() => loading = false);
  }

  void registrarVoluntario() async {
    await Get.to(() => const RegistroVoluntarioView());
    await cargar();
  }

  Future<void> eliminarVoluntarioConfirmado() async {
    if (voluntario != null) {
      await VoluntarioService.eliminarPorId(voluntario!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Te has retirado exitosamente del voluntariado'),
            backgroundColor: Colors.green,
          ),
        );
        await cargar();
      }
    }
  }

  void confirmarEliminarVoluntario() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Retirarse del Voluntariado',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        content: const Text(
          '¿Seguro que deseas retirarte como voluntario?',
          style: TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(fontSize: 17, color: Colors.black87)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            label: const Text(
              'Retirarme',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await eliminarVoluntarioConfirmado();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetVoluntariadoHome(
      loading: loading,
      voluntario: voluntario,
      onRegistrar: registrarVoluntario,
      onConfirmarEliminar: confirmarEliminarVoluntario,
    );
  }
}
