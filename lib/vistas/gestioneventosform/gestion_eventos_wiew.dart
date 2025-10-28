import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GestionEventosView extends StatelessWidget {
  const GestionEventosView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventosRef = FirebaseFirestore.instance.collection('eventos');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos y Avisos'),
        backgroundColor: Colors.orange[700],
        leading: BackButton(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF7F7F9),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          int total = docs.length;
          int publicados = docs.where((e) => (e['publico'] ?? false)).length;
          int borradores = docs.where((e) => !(e['publico'] ?? false)).length;

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contadores superiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Contador(title: 'Total eventos', count: total, color: Colors.grey[700]!),
                    _Contador(title: 'Publicados', count: publicados, color: Colors.green),
                    _Contador(title: 'Borradores', count: borradores, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega al formulario de crear evento
                      Get.toNamed('/crearEvento');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('+ Crear Nuevo Evento', style: TextStyle(fontSize: 17)),
                  ),
                ),
                const SizedBox(height: 12),
                // Lista de eventos
                Expanded(
                  child: ListView(
                    children: docs.map((doc) {
                      final evento = doc.data() as Map<String,dynamic>;
                      final publicado = evento['publico'] ?? false;
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Etiquetas/listado resumen
                              Row(
                                children: [
                                  _Etiqueta(text: evento['tipo'] ?? 'Tipo', color: Colors.purple),
                                  const SizedBox(width: 8),
                                  _Etiqueta(text: publicado ? 'Publicado' : 'Borrador', color: publicado ? Colors.green : Colors.orange),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Text(evento['titulo'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              const SizedBox(height: 3),
                              Text(evento['descripcion'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[800])),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Icon(Icons.event, size: 18, color: Colors.orange[300]),
                                  const SizedBox(width: 4),
                                  Text(evento['fecha'] ?? '', style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 12),
                                  Icon(Icons.access_time, size: 18, color: Colors.blue[300]),
                                  const SizedBox(width: 4),
                                  Text(evento['horario'] ?? '', style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      // Editar evento: abrir formulario con datos
                                      Get.toNamed('/editarEvento', arguments: {'id': doc.id, ...evento});
                                    },
                                    icon: const Icon(Icons.edit, size: 20),
                                    label: const Text('Editar'),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton.icon(
                                    onPressed: () async {
                                      // Ocultar/mostrar
                                      await doc.reference.update({'publico': !publicado});
                                    },
                                    icon: Icon(publicado ? Icons.visibility_off : Icons.visibility, size: 20),
                                    label: Text(publicado ? 'Ocultar' : 'Publicar'),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await doc.reference.delete();
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    label: const Text(''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  const _Contador({required this.title, required this.count, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
        Text(title, style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String text;
  final Color color;
  const _Etiqueta({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.13), borderRadius: BorderRadius.circular(7),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
