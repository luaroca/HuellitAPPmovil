import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotasAdopcionView extends StatefulWidget {
  const MascotasAdopcionView({Key? key}) : super(key: key);

  @override
  State<MascotasAdopcionView> createState() => _MascotasAdopcionViewState();
}

class _MascotasAdopcionViewState extends State<MascotasAdopcionView> {
  final MascotaController controller = Get.find();

  // Estos nunca serán null con la lógica corregida
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

  @override
  Widget build(BuildContext context) {
    final tipos = ['Todos', 'Perro', 'Gato', 'Otro'];
    final generos = ['Todos', 'Macho', 'Hembra'];
    final tamanios = ['Todos', 'Pequeño', 'Mediano', 'Grande'];

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
                      onChanged: (v) =>
                          setState(() => filtroTipo = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _dropdownFiltro(
                      label: "Género",
                      valorActual: filtroGenero,
                      opciones: generos,
                      onChanged: (v) =>
                          setState(() => filtroGenero = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _dropdownFiltro(
                      label: "Tamaño",
                      valorActual: filtroTamanio,
                      opciones: tamanios,
                      onChanged: (v) =>
                          setState(() => filtroTamanio = v ?? 'Todos'),
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
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: mascotasFiltradas.length,
                      itemBuilder: (_, idx) {
                        final m = mascotasFiltradas[idx];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: m.fotoUrl != null &&
                                          m.fotoUrl!.isNotEmpty
                                      ? Image.network(
                                          m.fotoUrl!,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              _iconoPorDefecto(),
                                        )
                                      : _iconoPorDefecto(),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${m.nombre} (${m.tipo})",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${m.genero} - ${m.tamanio}",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
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
                                    ],
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
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      items: opciones
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _iconoPorDefecto() => Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.pets, size: 36, color: Colors.teal),
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
            color: activo ? colorTrue : colorFalse, fontWeight: FontWeight.w600),
      ),
    );
  }
}
