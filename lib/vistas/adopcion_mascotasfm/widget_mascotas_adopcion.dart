import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotasAdopcionWidget extends StatelessWidget {
  final String filtroTipo;
  final String filtroGenero;
  final String filtroTamanio;

  final List<String> tipos;
  final List<String> generos;
  final List<String> tamanios;

  final List<MascotaModel> mascotasFiltradas;
  final User? user;

  final ValueChanged<String?> onFiltroTipo;
  final ValueChanged<String?> onFiltroGenero;
  final ValueChanged<String?> onFiltroTamanio;

  final Function(MascotaModel) onAdoptar;

  const MascotasAdopcionWidget({
    Key? key,
    required this.filtroTipo,
    required this.filtroGenero,
    required this.filtroTamanio,
    required this.tipos,
    required this.generos,
    required this.tamanios,
    required this.mascotasFiltradas,
    required this.user,
    required this.onFiltroTipo,
    required this.onFiltroGenero,
    required this.onFiltroTamanio,
    required this.onAdoptar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          _filtros(),
          const SizedBox(height: 14),
          Expanded(child: _listaMascotas()),
        ],
      ),
    );
  }

  Widget _filtros() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _dropdownFiltro(
              label: "Tipo",
              valorActual: filtroTipo,
              opciones: tipos,
              onChanged: onFiltroTipo,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _dropdownFiltro(
              label: "Género",
              valorActual: filtroGenero,
              opciones: generos,
              onChanged: onFiltroGenero,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _dropdownFiltro(
              label: "Tamaño",
              valorActual: filtroTamanio,
              opciones: tamanios,
              onChanged: onFiltroTamanio,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaMascotas() {
    if (mascotasFiltradas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "No hay mascotas disponibles con los filtros seleccionados.",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: mascotasFiltradas.length,
      itemBuilder: (_, idx) {
        final m = mascotasFiltradas[idx];

        final solicitudEnviadaPorMi =
            m.solicitudAdopcion == true &&
                m.solicitudUid != null &&
                user != null &&
                m.solicitudUid == user!.uid;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.fotoUrl != null && m.fotoUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      m.fotoUrl!,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _iconoPorDefecto(),
                    ),
                  ),

                const SizedBox(height: 14),

                Text(
                  "${m.nombre} (${m.tipo})",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),

                const SizedBox(height: 6),

                Text(
                  "${m.genero} - ${m.tamanio}",
                  style:
                      const TextStyle(color: Colors.black54, fontSize: 16),
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
                  onPressed: (m.solicitudAdopcion == true) ? null : () => onAdoptar(m),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    (m.solicitudAdopcion == true && solicitudEnviadaPorMi)
                        ? "Solicitud enviada"
                        : (m.solicitudAdopcion == true)
                            ? "No disponible temporalmente"
                            : "Solicitar adopción",
                  ),
                )
              ],
            ),
          ),
        );
      },
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
