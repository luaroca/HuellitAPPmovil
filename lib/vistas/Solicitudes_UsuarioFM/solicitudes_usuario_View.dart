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

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                margin: const EdgeInsets.only(bottom: 22),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-----------------------------------------
                      //  MASCOTA
                      //-----------------------------------------
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: mascota.fotoUrl != null &&
                                    mascota.fotoUrl!.isNotEmpty
                                ? Image.network(
                                    mascota.fotoUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.pets,
                                      size: 45,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 18),

                          // Datos principales
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mascota.nombre,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${mascota.tipo} • ${mascota.genero}',
                                  style: const TextStyle(
                                      fontFamily: 'Roboto', fontSize: 17),
                                ),
                                Text(
                                  'Tamaño: ${mascota.tamanio}',
                                  style: const TextStyle(
                                      fontFamily: 'Roboto', fontSize: 17),
                                ),
                                Text(
                                  'Vacunado: ${mascota.vacunado ? "Sí" : "No"}',
                                  style: const TextStyle(
                                      fontFamily: 'Roboto', fontSize: 17),
                                ),
                                Text(
                                  'Esterilizado: ${mascota.esterilizado ? "Sí" : "No"}',
                                  style: const TextStyle(
                                      fontFamily: 'Roboto', fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //-----------------------------------------
                      //  DESCRIPCIÓN
                      //-----------------------------------------
                      if (mascota.descripcion != null &&
                          mascota.descripcion!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            'Descripción: ${mascota.descripcion}',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      //-----------------------------------------
                      //  ETIQUETA DE CONFIRMACIÓN
                      //-----------------------------------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DB6AC).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF4DB6AC),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,
                                color: Color(0xFF4DB6AC), size: 26),
                            SizedBox(width: 10),
                            Text(
                              "Solicitud Confirmada",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: Color(0xFF4DB6AC),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
