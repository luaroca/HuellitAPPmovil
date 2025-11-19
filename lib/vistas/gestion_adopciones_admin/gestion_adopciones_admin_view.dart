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
      backgroundColor: const Color(0xFFF1F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        centerTitle: true,
        title: const Text(
          'Gestión de Solicitudes',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 2,
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
                'No hay solicitudes pendientes.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
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
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-----------------------------------------------------
                      //             IMAGEN PRINCIPAL (SOLAMENTE ESTA)
                      //-----------------------------------------------------
                      if (mascota.fotoUrl != null &&
                          mascota.fotoUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            mascota.fotoUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 14),

                      //-----------------------------------------
                      //   INFO DE LA MASCOTA (SIN IMAGEN PEQUEÑA)
                      //-----------------------------------------
                      Text(
                        mascota.nombre,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${mascota.tipo} • ${mascota.genero}',
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 18),
                      ),
                      Text(
                        'Tamaño: ${mascota.tamanio}',
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 18),
                      ),
                      Text(
                        'Vacunado: ${mascota.vacunado ? "Sí" : "No"}',
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 18),
                      ),
                      Text(
                        'Esterilizado: ${mascota.esterilizado ? "Sí" : "No"}',
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 18),
                      ),

                      if (mascota.descripcion != null &&
                          mascota.descripcion!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'Descripción: ${mascota.descripcion}',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),
                      const Divider(),

                      //-----------------------------------------
                      //  DATOS DEL SOLICITANTE
                      //-----------------------------------------
                      const SizedBox(height: 10),
                      const Text(
                        "Datos del Solicitante:",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "👤 Nombre: ${mascota.nombreUsuarioSolicitud ?? '-'}",
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 17),
                      ),
                      Text(
                        "📧 Correo: ${mascota.correoUsuarioSolicitud ?? '-'}",
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 17),
                      ),
                      Text(
                        "📱 Teléfono: ${mascota.telefonoUsuarioSolicitud ?? '-'}",
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 17),
                      ),

                      const SizedBox(height: 20),

                      //-----------------------------------------
                      //  BOTONES
                      //-----------------------------------------
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.red.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Denegar',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('mascotas')
                                    .doc(mascota.id)
                                    .update({
                                  'solicitudAdopcion': false,
                                  'solicitudUid': null,
                                  'nombreUsuarioSolicitud': null,
                                  'correoUsuarioSolicitud': null,
                                  'telefonoUsuarioSolicitud': null,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Solicitud denegada para ${mascota.nombre}'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF4DB6AC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Confirmar',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
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
                                        'Adopción confirmada para ${mascota.nombre}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
