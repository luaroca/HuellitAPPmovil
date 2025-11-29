import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:huellitas/vistas/Solicitudes_UsuarioFM/widget_solicitud_usuario.dart';


class SolicitudesUsuarioView extends StatelessWidget {
  const SolicitudesUsuarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final ref = FirebaseFirestore.instance
        .collection('mascotas')
        .where('adoptada', isEqualTo: true)
        .where('solicitudUid', isEqualTo: uid);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Estado De Solicitud',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No tienes solicitudes confirmadas.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final mascota = MascotaModel.fromMap({
                ...docs[index].data() as Map<String, dynamic>,
                'id': docs[index].id,
              });

              return WidgetSolicitudCard(mascota: mascota);
            },
          );
        },
      ),
    );
  }
}
