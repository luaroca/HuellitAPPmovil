import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'asignar_mascota_view.dart';
import 'widget_casa_paso_card.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';

class GestionCasasPasoAdminView extends StatefulWidget {
  const GestionCasasPasoAdminView({Key? key}) : super(key: key);

  @override
  State<GestionCasasPasoAdminView> createState() =>
      _GestionCasasPasoAdminViewState();
}

class _GestionCasasPasoAdminViewState extends State<GestionCasasPasoAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0FAF95),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Gestión de Casas de Paso',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 29),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('casas_paso').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0FAF95)),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay casas de paso registradas.',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 22),
            itemBuilder: (context, i) {
              final casa = CasaPasoModel.fromMap(
                docs[i].id,
                docs[i].data() as Map<String, dynamic>,
              );

              return WidgetCasaPasoCard(
                casa: casa,
                onAsignar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AsignarMascotaView(casaDePaso: casa),
                    ),
                  );
                },
                onRetirarMascota: (mascotaId) async {
                  await FirebaseFirestore.instance
                      .collection('mascotas')
                      .doc(mascotaId)
                      .update({
                    'casaPasoId': null,
                    'fechaIngresoCasa': null,
                    'fechaSalidaCasa': null,
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mascota retirada de la casa de paso')),
                    );
                  }
                },
                onLlamar: (telefono) {
                  _llamarTelefono(context, telefono);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _llamarTelefono(BuildContext context, String telefono) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la aplicación de llamadas')),
      );
    }
  }
}
