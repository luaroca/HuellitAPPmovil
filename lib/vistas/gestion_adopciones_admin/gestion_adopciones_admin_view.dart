import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:huellitas/vistas/gestion_adopciones_admin/widget_gestion_adopciones.dart';
import 'package:url_launcher/url_launcher.dart';


class GestionAdopcionesAdminView extends StatefulWidget {
  const GestionAdopcionesAdminView({Key? key}) : super(key: key);

  @override
  State<GestionAdopcionesAdminView> createState() =>
      _GestionAdopcionesAdminViewState();
}

class _GestionAdopcionesAdminViewState
    extends State<GestionAdopcionesAdminView> {
  String filtroEstado = 'Pendientes';

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

          // -------- FILTROS --------
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

          // -------- LISTA --------
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

                final mascotas = docs
                    .map((d) => MascotaModel.fromMap({
                          ...d.data() as Map<String, dynamic>,
                          'id': d.id,
                        }))
                    .where((m) {
                  if (m.solicitudUid == null &&
                      m.nombreUsuarioSolicitud == null &&
                      m.correoUsuarioSolicitud == null) {
                    return false;
                  }
                  if (filtroEstado == 'Pendientes') {
                    return m.solicitudAdopcion == true && m.adoptada == false;
                  } else {
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

                    return WidgetAdopcionCard(
                      mascota: mascota,
                      onLlamar: () => _llamarTelefono(mascota.telefonoUsuarioSolicitud),
                      onWhatsApp: () => _abrirWhatsApp(mascota.telefonoUsuarioSolicitud),
                      onDenegar: () => _denegarSolicitud(mascota),
                      onConfirmar: () => _confirmarSolicitud(mascota),
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

  // ------ ACCIONES ------
  Future<void> _llamarTelefono(String? telefono) async {
    if (telefono == null || telefono.trim().isEmpty) return;

    final uri = Uri(scheme: 'tel', path: telefono.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _abrirWhatsApp(String? telefono) async {
    if (telefono == null || telefono.trim().isEmpty) return;

    final phone = telefono.trim().replaceAll(' ', '');
    final uri = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _denegarSolicitud(MascotaModel mascota) async {
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
        content: Text('Solicitud denegada para ${mascota.nombre}'),
      ),
    );
  }

  Future<void> _confirmarSolicitud(MascotaModel mascota) async {
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
        content: Text('Adopción confirmada para ${mascota.nombre}'),
      ),
    );
  }
}
