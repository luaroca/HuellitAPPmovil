import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Próximos Eventos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Ver todos',
                    style: TextStyle(color: Colors.teal[700], fontSize: 16)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('eventos')
                  .where('publico', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aún no hay eventos publicados.',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 18),
                  itemBuilder: (context, i) {
                    final ev = docs[i].data() as Map<String, dynamic>;
                    final tipo = ev['tipo'] ?? '';
                    final esAdopcion = tipo == 'Adopción';
                    final esEst = tipo == 'Esterilización';
                    final colorEtiqueta = esAdopcion
                        ? const Color(0xFFFF9800)
                        : (esEst
                            ? const Color(0xFF7E57C2)
                            : Colors.blueGrey);
                    final colorFondoEtiqueta = esAdopcion
                        ? const Color(0xFFFFF3E0)
                        : (esEst
                            ? const Color(0xFFEDE7F6)
                            : Colors.blueGrey.shade50);

                    return Container(
                      width: 270,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.teal.shade100, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorFondoEtiqueta,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.folder,
                                    color: colorEtiqueta, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  tipo,
                                  style: TextStyle(
                                    color: colorEtiqueta,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ev['titulo'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ev['descripcion'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.event,
                                  size: 16, color: Colors.teal[700]),
                              const SizedBox(width: 5),
                              Text(ev['fecha'] ?? '',
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 10),
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.teal[400]),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  ev['horario'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_pin,
                                  size: 16, color: Colors.redAccent),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  ev['ubicacion'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
