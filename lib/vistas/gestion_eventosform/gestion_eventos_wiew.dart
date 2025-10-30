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
        title: const Text(
          'Gestión de Eventos y Avisos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFFAE35),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFA8E6CF),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFAE35)),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          int total = docs.length;
          int publicados = docs.where((e) => (e['publico'] ?? false)).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Row(
                  children: [
                    Expanded(
                      child: _ContadorBonito(
                        icon: Icons.event,
                        count: total,
                        color: const Color(0xFFFFB74D),
                        bgColor: const Color(0xFFFFF4E3), 
                        title: 'Total de eventos',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ContadorBonito(
                        icon: Icons.public,
                        count: publicados,
                        color: const Color(0xFF4DB6AC),
                        bgColor: const Color(0xFFE8F6F4),
                        title: 'Publicados',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

               
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/crearEvento'),
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.white, size: 26),
                    label: const Text(
                      'Crear Nuevo Evento',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAE35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                
                ListView.builder(
                  itemCount: docs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, idx) {
                    final doc = docs[idx];
                    final evento = doc.data() as Map<String, dynamic>;
                    final publicado = evento['publico'] ?? false;

                    return Card(
                      color: const Color(0xFFFFFCF5),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _Etiqueta(
                                  text: evento['tipo'] ?? 'Sin tipo',
                                  color: const Color(0xFF226776),
                                ),
                                _Etiqueta(
                                  text: publicado ? 'Publicado' : 'Borrador',
                                  color: publicado
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Text(
                              evento['titulo'] ?? 'Sin título',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),

                            if ((evento['descripcion'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  evento['descripcion'] ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.event,
                                    size: 20, color: Color(0xFFFFAE35)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    evento['fecha'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.access_time,
                                    size: 20, color: Color(0xFF226776)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    evento['horario'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Get.toNamed('/editarEvento', arguments: {
                                      'id': doc.id,
                                      ...evento,
                                    });
                                  },
                                  icon: const Icon(Icons.edit,
                                      size: 18, color: Color(0xFF1565C0)),
                                  label: const Text(
                                    'Editar',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF1565C0)),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    await doc.reference
                                        .update({'publico': !publicado});
                                  },
                                  icon: Icon(
                                    publicado
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 18,
                                    color: const Color(0xFF0D7864),
                                  ),
                                  label: Text(
                                    publicado ? 'Ocultar' : 'Publicar',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF0D7864),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Confirmar eliminación'),
                                        content: const Text(
                                            '¿Estás seguro que quieres eliminar este evento?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancelar')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Eliminar')),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await doc.reference.delete();
                                    }
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 18),
                                  label: const Text(
                                    'Eliminar',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class _ContadorBonito extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final Color color;
  final Color bgColor;

  const _ContadorBonito({
    required this.icon,
    required this.count,
    required this.title,
    required this.color,
    required this.bgColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
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
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
