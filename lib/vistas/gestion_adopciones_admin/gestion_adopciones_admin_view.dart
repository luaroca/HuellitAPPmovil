import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class GestionAdopcionesAdminView extends StatelessWidget {
  const GestionAdopcionesAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('mascotas')
        .where('solicitudAdopcion', isEqualTo: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Solicitudes de Adopción'),
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
            return const Center(child: Text('No hay solicitudes pendientes.'));
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Datos de la mascota
                      Row(
                        children: [
                          mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty
                              ? Image.network(mascota.fotoUrl!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.pets,
                                  size: 56, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mascota.nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text('${mascota.tipo} - ${mascota.genero}'),
                                Text('Tamaño: ${mascota.tamanio}'),
                                Text('Vacunado: ${mascota.vacunado ? "Sí" : "No"}'),
                                Text('Esterilizado: ${mascota.esterilizado ? "Sí" : "No"}')
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Datos del usuario solicitante
                      Text("Solicitante:",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                          "Nombre: ${mascota.nombreUsuarioSolicitud ?? '-'}",
                          style: const TextStyle(fontSize: 15)),
                      Text(
                          "Correo: ${mascota.correoUsuarioSolicitud ?? '-'}",
                          style: const TextStyle(fontSize: 15)),
                      Text(
                          "Teléfono: ${mascota.telefonoUsuarioSolicitud ?? '-'}",
                          style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          child: const Text('Confirmar Adopción'),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('mascotas')
                                .doc(mascota.id)
                                .update({
                              'solicitudAdopcion': false,
                              'adoptada': true,
                              'disponible': false,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Adopción confirmada para ${mascota.nombre}')),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
