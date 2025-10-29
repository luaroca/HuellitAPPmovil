import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/voluntario_model.dart';

class GestionVoluntariadosAdminView extends StatefulWidget {
  const GestionVoluntariadosAdminView({Key? key}) : super(key: key);

  @override
  State<GestionVoluntariadosAdminView> createState() => _GestionVoluntariadosAdminViewState();
}

class _GestionVoluntariadosAdminViewState extends State<GestionVoluntariadosAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF476AE8),
        title: const Text(
          'Gestión de Voluntariados',
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
        stream: FirebaseFirestore.instance.collection('voluntarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF476AE8)));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay voluntarios registrados.',
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, i) {
              final v = VoluntarioModel.fromMap(
                docs[i].id, docs[i].data() as Map<String, dynamic>
              );
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.045),
                      blurRadius: 8,
                      offset: const Offset(0, 3)
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.volunteer_activism, color: Color(0xFF476AE8), size: 29),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            v.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Chip(
                          backgroundColor: const Color(0xFFDDE6FF),
                          label: Text(
                            v.dias.join(', '),
                            style: const TextStyle(color: Color(0xFF476AE8), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 7),
                    _rowIconInfo(Icons.email_outlined, 'Correo', v.correo),
                    _rowIconInfo(Icons.phone, 'Teléfono', v.telefono.isEmpty ? '-' : v.telefono),
                    _rowIconInfo(Icons.access_time, 'Horario', v.horario),
                    _rowIconInfo(Icons.category, 'Áreas de Interés', v.intereses.join(', ')),
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
          Icon(icon, size: 19, color: Colors.blue[300]),
          const SizedBox(width: 9),
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
