import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class GestionAdopcionesAdminView extends StatefulWidget {
  const GestionAdopcionesAdminView({Key? key}) : super(key: key);

  @override
  State<GestionAdopcionesAdminView> createState() =>
      _GestionAdopcionesAdminViewState();
}

class _GestionAdopcionesAdminViewState
    extends State<GestionAdopcionesAdminView> {
  String filtroEstado = 'Pendientes'; // Pendientes | Aceptadas

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('mascotas');

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        centerTitle: true,
        elevation: 4,
        title: const Text(
          'Gestión de Solicitudes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Mostrar:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: DropdownButton<String>(
                      value: filtroEstado,
                      isExpanded: true,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pendientes',
                          child: Text('Pendientes'),
                        ),
                        DropdownMenuItem(
                          value: 'Aceptadas',
                          child: Text('Aceptadas'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => filtroEstado = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFAE35),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                // Convertir a modelos y filtrar en memoria
                final mascotas = docs
                    .map((d) => MascotaModel.fromMap({
                          ...d.data() as Map<String, dynamic>,
                          'id': d.id,
                        }))
                    .where((m) {
                  // Solo mostrar mascotas que alguna vez tuvieron solicitud
                  if (m.solicitudUid == null &&
                      m.nombreUsuarioSolicitud == null &&
                      m.correoUsuarioSolicitud == null) {
                    return false;
                  }
                  if (filtroEstado == 'Pendientes') {
                    return m.solicitudAdopcion == true && m.adoptada == false;
                  } else {
                    // Aceptadas
                    return m.adoptada == true;
                  }
                }).toList();

                if (mascotas.isEmpty) {
                  return Center(
                    child: Text(
                      filtroEstado == 'Pendientes'
                          ? 'No hay solicitudes pendientes.'
                          : 'No hay solicitudes aceptadas.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mascotas.length,
                  itemBuilder: (context, index) {
                    final mascota = mascotas[index];

                    return Card(
                      color: const Color(0xFFFFFCF5),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (mascota.fotoUrl != null &&
                                mascota.fotoUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  mascota.fotoUrl!,
                                  height: 210,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 210,
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.pets,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _chipInfo(
                                    mascota.tipo, const Color(0xFF226776)),
                                _chipInfo(
                                    mascota.genero, const Color(0xFF0D7864)),
                                _chipInfo(
                                    "Tamaño: ${mascota.tamanio}",
                                    const Color(0xFF4DB6AC)),
                                _chipInfo(
                                    mascota.vacunado
                                        ? "Vacunado"
                                        : "No vacunado",
                                    mascota.vacunado
                                        ? Colors.green
                                        : Colors.orange),
                                _chipInfo(
                                    mascota.esterilizado
                                        ? "Esterilizado"
                                        : "Sin esterilizar",
                                    mascota.esterilizado
                                        ? Colors.green
                                        : Colors.redAccent),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    mascota.nombre,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: mascota.adoptada
                                        ? Colors.green.withOpacity(0.15)
                                        : Colors.orange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    mascota.adoptada
                                        ? 'Aceptada'
                                        : 'Pendiente',
                                    style: TextStyle(
                                      color: mascota.adoptada
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (mascota.descripcion != null &&
                                mascota.descripcion!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  mascota.descripcion!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 14),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              "Datos del Solicitante",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF226776),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _infoRow(
                              icon: Icons.person,
                              label: "Nombre",
                              value: mascota.nombreUsuarioSolicitud,
                            ),
                            _infoRow(
                              icon: Icons.email,
                              label: "Correo",
                              value: mascota.correoUsuarioSolicitud,
                            ),
                            _infoRow(
                              icon: Icons.phone,
                              label: "Teléfono",
                              value: mascota.telefonoUsuarioSolicitud,
                            ),
                            const SizedBox(height: 22),
                            if (!mascota.adoptada)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
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

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Solicitud denegada para ${mascota.nombre}'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Denegar',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('mascotas')
                                            .doc(mascota.id)
                                            .update({
                                          'solicitudAdopcion': false,
                                          'adoptada': true,
                                          'disponible': false,
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Adopción confirmada para ${mascota.nombre}'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFFAE35),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              const Center(
                                child: Text(
                                  'Esta solicitud ya fue aceptada.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipInfo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFAE35)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: ${value ?? '-'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
