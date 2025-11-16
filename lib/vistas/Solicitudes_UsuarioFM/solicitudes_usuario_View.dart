import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/mascota_model.dart';

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
      appBar: AppBar(
        title: const Text('Mis Solicitudes de Adopción'),
        backgroundColor: const Color(0xFF4DB6AC),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No tienes solicitudes confirmadas.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final mascota = MascotaModel.fromMap({
                ...docs[index].data() as Map<String, dynamic>,
                'id': docs[index].id,
              });
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty
                      ? Image.network(mascota.fotoUrl!,
                          width: 56, height: 56, fit: BoxFit.cover)
                      : const Icon(Icons.pets, size: 56, color: Colors.grey),
                  title: Text(mascota.nombre),
                  subtitle: Text('${mascota.tipo} - ${mascota.genero}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
