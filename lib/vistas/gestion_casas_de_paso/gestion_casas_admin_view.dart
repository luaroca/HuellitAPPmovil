import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class GestionCasasPasoAdminView extends StatefulWidget {
  const GestionCasasPasoAdminView({Key? key}) : super(key: key);

  @override
  State<GestionCasasPasoAdminView> createState() =>
      _GestionCasasPasoAdminViewState();
}

class _GestionCasasPasoAdminViewState
    extends State<GestionCasasPasoAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12B497),
        title: const Text(
          'Gestión de Casas de Paso',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('casas_paso')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF12B497)));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay casas de paso registradas.',
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            );
          }

          return ListView.separated(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, i) {
              final c = CasaPasoModel.fromMap(
                  docs[i].id, docs[i].data() as Map<String, dynamic>);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.teal.withOpacity(0.045),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home_work,
                            color: Color(0xFF12B497), size: 29),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Chip(
                          backgroundColor: const Color(0xFFA8E6CF),
                          label: Text(
                            c.tipoMascotas,
                            style: const TextStyle(
                                color: Color(0xFF12B497),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                        thickness: 1, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 7),
                    _rowIconInfo(Icons.phone, 'Teléfono', c.telefono),
                    _rowIconInfo(Icons.location_on, 'Dirección', c.direccion),
                    _rowIconInfo(
                        Icons.pets, 'Capacidad', '${c.capacidad} mascotas'),
                    _rowIconInfo(Icons.check_circle, 'Patio/Jardín',
                        c.tienePatio ? 'Sí' : 'No'),
                    _rowIconInfo(Icons.star, 'Experiencia',
                        c.experiencia ? 'Sí' : 'No'),
                    if (c.comentarios.isNotEmpty)
                      _rowIconInfo(
                          Icons.comment, 'Comentarios', c.comentarios),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF12B497),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _asignarMascota(context, c),
                        icon: const Icon(Icons.pets),
                        label: const Text("Asignar mascota"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _rowIconInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: Colors.teal[300]),
          const SizedBox(width: 9),
          Text(
            '$title: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(color: Colors.black87, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // MOSTRAR MASCOTAS DISPONIBLES PARA ASIGNAR
  // ==================================================
  Future<void> _asignarMascota(
      BuildContext context, CasaPasoModel casa) async {
    
    // Normalizar tipo
    final tipoCasa = casa.tipoMascotas.trim().toLowerCase();

    final query = await FirebaseFirestore.instance
        .collection('mascotas')
        .where('disponible', isEqualTo: true)
        .get();

    final mascotas = <MascotaModel>[];

    for (final doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final sinCasa = data['casaPasoId'] == null || data['casaPasoId'] == '';

      final tipoMascota =
          (data['tipo'] ?? '').toString().trim().toLowerCase();

      if (sinCasa && tipoMascota == tipoCasa) {
        mascotas.add(
          MascotaModel.fromFirestore(doc.id, data),
        );
      }
    }

    if (mascotas.isEmpty) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text('Sin mascotas disponibles'),
            content: Text(
                'No hay mascotas de este tipo disponibles y sin asignar.'),
          ),
        );
      }
      return;
    }

    MascotaModel? selected;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Asignar mascota'),
          content: DropdownButtonFormField<MascotaModel>(
            isExpanded: true,
            value: selected,
            decoration:
                const InputDecoration(labelText: 'Selecciona mascota'),
            items: mascotas.map((m) {
              return DropdownMenuItem(
                  value: m,
                  child:
                      Text(m.nombre.isNotEmpty ? m.nombre : '(Sin nombre)'));
            }).toList(),
            onChanged: (val) => setDialogState(() => selected = val),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (selected == null) return;

                await FirebaseFirestore.instance
                    .collection('mascotas')
                    .doc(selected!.id)
                    .update({
                  'casaPasoId': casa.id,
                  'disponible': false,
                });

                if (context.mounted) Navigator.pop(ctx);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mascota asignada correctamente.'),
                    ),
                  );
                }
              },
              child: const Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }
}
