import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MascotasAdopcionView extends StatefulWidget {
  const MascotasAdopcionView({Key? key}) : super(key: key);

  @override
  State<MascotasAdopcionView> createState() => _MascotasAdopcionViewState();
}

class _MascotasAdopcionViewState extends State<MascotasAdopcionView> {
  final MascotaController controller = Get.find();

  String filtroTipo = 'Todos';
  String filtroGenero = 'Todos';
  String filtroTamanio = 'Todos';

  List<MascotaModel> _filtrarMascotas(List<MascotaModel> mascotas) {
    return mascotas.where((m) {
      if (!m.disponible) return false;
      if (filtroTipo != 'Todos' && m.tipo != filtroTipo) return false;
      if (filtroGenero != 'Todos' && m.genero != filtroGenero) return false;
      if (filtroTamanio != 'Todos' && m.tamanio != filtroTamanio) return false;
      return true;
    }).toList();
  }

  Future<void> _solicitarAdopcion(MascotaModel m) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Debes iniciar sesión para solicitar adopción');
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final usuarioData = userDoc.data() ?? {};

    await FirebaseFirestore.instance
        .collection('mascotas')
        .doc(m.id)
        .update({
      'solicitudAdopcion': true,
      'solicitudUid': user.uid,
      'nombreUsuarioSolicitud': usuarioData['nombres'] ?? '',
      'correoUsuarioSolicitud': usuarioData['email'] ?? user.email ?? '',
      'telefonoUsuarioSolicitud': usuarioData['telefono'] ?? '',
    });

    Get.snackbar(
      'Solicitud enviada',
      'Solicitud para adoptar a ${m.nombre} enviada correctamente',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tipos = ['Todos', 'Perro', 'Gato', 'Otro'];
    final generos = ['Todos', 'Macho', 'Hembra'];
    final tamanios = ['Todos', 'Pequeño', 'Mediano', 'Grande'];
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        centerTitle: true,
        title: const Text(
          'Mascotas para adopción',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFFA8E6CF),
      body: Obx(() {
        final mascotas = controller.mascotas;
        final mascotasFiltradas = _filtrarMascotas(mascotas);

        return Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: _dropdownFiltro(
                      label: "Tipo",
                      valorActual: filtroTipo,
                      opciones: tipos,
                      onChanged: (v) => setState(() => filtroTipo = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _dropdownFiltro(
                      label: "Género",
                      valorActual: filtroGenero,
                      opciones: generos,
                      onChanged: (v) => setState(() => filtroGenero = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _dropdownFiltro(
                      label: "Tamaño",
                      valorActual: filtroTamanio,
                      opciones: tamanios,
                      onChanged: (v) => setState(() => filtroTamanio = v ?? 'Todos'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: mascotasFiltradas.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "No hay mascotas disponibles con los filtros seleccionados.",
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: mascotasFiltradas.length,
                      itemBuilder: (_, idx) {
                        final m = mascotasFiltradas[idx];

                        final solicitudEnviadaPorMi =
                            m.solicitudAdopcion == true &&
                                m.solicitudUid != null &&
                                user != null &&
                                m.solicitudUid == user.uid;

                        return Card(
                          margin:
                              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FOTO GRANDE ÚNICA
                                if (m.fotoUrl != null && m.fotoUrl!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      m.fotoUrl!,
                                      height: 230,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _iconoPorDefecto(),
                                    ),
                                  ),

                                const SizedBox(height: 14),

                                Text(
                                  "${m.nombre} (${m.tipo})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "${m.genero} - ${m.tamanio}",
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),

                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 6,
                                  children: [
                                    _chipEstado(
                                      icon: Icons.check_circle,
                                      activo: m.vacunado,
                                      labelTrue: 'Vacunado',
                                      labelFalse: 'No vacunado',
                                      colorTrue: Colors.green,
                                      colorFalse: Colors.grey,
                                    ),
                                    _chipEstado(
                                      icon: Icons.medical_services,
                                      activo: m.esterilizado,
                                      labelTrue: 'Esterilizado',
                                      labelFalse: 'No esterilizado',
                                      colorTrue: Colors.blue,
                                      colorFalse: Colors.grey,
                                    ),
                                    _chipEstado(
                                      icon: Icons.pets,
                                      activo: m.disponible,
                                      labelTrue: 'Adoptable',
                                      labelFalse: 'No adoptable',
                                      colorTrue: Colors.orange,
                                      colorFalse: Colors.grey,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                ElevatedButton(
                                  onPressed: (m.solicitudAdopcion == true)
                                      ? null
                                      : () => _solicitarAdopcion(m),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    (m.solicitudAdopcion == true &&
                                            solicitudEnviadaPorMi)
                                        ? "Solicitud enviada"
                                        : (m.solicitudAdopcion == true)
                                            ? "No disponible temporalmente"
                                            : "Solicitar adopción",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _dropdownFiltro({
    required String label,
    required String valorActual,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: opciones.contains(valorActual) ? valorActual : opciones.first,
      decoration: InputDecoration(
        hintText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      items:
          opciones.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _iconoPorDefecto() => Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.pets, size: 70, color: Colors.teal),
      );

  Widget _chipEstado({
    required IconData icon,
    required bool activo,
    required String labelTrue,
    required String labelFalse,
    required Color colorTrue,
    required Color colorFalse,
  }) {
    return Chip(
      avatar: Icon(icon, size: 18, color: activo ? colorTrue : colorFalse),
      backgroundColor: (activo ? colorTrue : colorFalse).withOpacity(0.15),
      label: Text(
        activo ? labelTrue : labelFalse,
        style: TextStyle(
            color: activo ? colorTrue : colorFalse,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
