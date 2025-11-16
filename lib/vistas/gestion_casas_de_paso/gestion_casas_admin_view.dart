import 'package:flutter/material.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'asignar_mascota_view.dart';

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
        stream:
            FirebaseFirestore.instance.collection('casas_paso').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF0FAF95)));
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

              return _CasaCard(
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
                        content: Text('Mascota retirada de la casa de paso'),
                      ),
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

class _CasaCard extends StatelessWidget {
  final CasaPasoModel casa;
  final VoidCallback onAsignar;
  final Function(String mascotaId) onRetirarMascota;
  final Function(String telefono) onLlamar;

  const _CasaCard({
    required this.casa,
    required this.onAsignar,
    required this.onRetirarMascota,
    required this.onLlamar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home_work_rounded,
                  color: Color(0xFF0FAF95), size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  casa.nombre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone, size: 22),
                label: const Text("Contactar"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0FAF95),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (casa.telefono.isNotEmpty) {
                    onLlamar(casa.telefono);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Este contacto no tiene número')));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE5E5E5)),
          const SizedBox(height: 10),
          _rowIconInfo(Icons.phone, 'Teléfono', casa.telefono),
          _rowIconInfo(Icons.location_on, 'Dirección', casa.direccion),
          _rowIconInfo(Icons.pets, 'Capacidad', '${casa.capacidad} mascotas'),
          _rowIconInfo(Icons.check_circle, 'Patio/Jardín',
              casa.tienePatio ? 'Sí' : 'No'),
          _rowIconInfo(Icons.star, 'Experiencia',
              casa.experiencia ? 'Sí' : 'No'),
          if (casa.comentarios.isNotEmpty)
            _rowIconInfo(Icons.comment, 'Comentarios', casa.comentarios),
          const SizedBox(height: 20),

          /// Mascotas asignadas
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('mascotas')
                .where('casaPasoId', isEqualTo: casa.id)
                .snapshots(),
            builder: (context, snapMascotas) {
              if (snapMascotas.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final mascotasDocs = snapMascotas.data?.docs ?? [];

              if (mascotasDocs.isEmpty) {
                return const Text(
                  "No hay mascotas actualmente asignadas.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mascotas asignadas:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0FAF95),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...mascotasDocs.map((doc) {
                    final mascota = MascotaModel.fromMap({
                      ...doc.data() as Map<String, dynamic>,
                      'id': doc.id
                    });

                    final fechaIng = mascota.fechaIngresoCasa != null
                        ? _formatDate(mascota.fechaIngresoCasa!.toDate())
                        : '---';

                    final fechaSal = mascota.fechaSalidaCasa != null
                        ? _formatDateHora(mascota.fechaSalidaCasa!.toDate())
                        : '---';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FFFD),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFBDEEE1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.pets,
                              color: Color(0xFF0FAF95), size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${mascota.nombre} (${mascota.tipo})\n'
                              'Ingreso: $fechaIng\n'
                              'Salida: $fechaSal',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.undo, size: 18),
                            label: const Text('Retirar',
                                style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[300],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => onRetirarMascota(mascota.id),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.pets, size: 22),
              label: const Text(
                "Asignar mascota",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0FAF95),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAsignar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowIconInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: Colors.teal[600]),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String _formatDateHora(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} - $h:$m';
  }
}
