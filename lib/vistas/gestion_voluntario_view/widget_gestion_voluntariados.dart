// widget_gestion_voluntariados.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetGestionVoluntariados extends StatelessWidget {
  final String? filtroDia;
  final String? filtroInteres;
  final List<String> diasSemana;
  final List<String> intereses;
  final Function(String?) onFiltroDiaChanged;
  final Function(String?) onFiltroInteresChanged;
  final Stream<QuerySnapshot> streamVoluntarios;

  const WidgetGestionVoluntariados({
    super.key,
    required this.filtroDia,
    required this.filtroInteres,
    required this.diasSemana,
    required this.intereses,
    required this.onFiltroDiaChanged,
    required this.onFiltroInteresChanged,
    required this.streamVoluntarios,
  });

  void _llamarTelefono(BuildContext context, String telefono) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la aplicación de llamadas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        elevation: 4,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Gestión de Voluntariados',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                _filtroDias(),
                const SizedBox(height: 12),
                _filtroIntereses(),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: streamVoluntarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFAE35)),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay voluntarios registrados.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  );
                }

                // FILTROS
                final filtrados = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final dias = List<String>.from(data['dias'] ?? []);
                  final areas = List<String>.from(data['intereses'] ?? []);

                  final okDia = filtroDia == null || dias.contains(filtroDia);
                  final okArea =
                      filtroInteres == null || areas.contains(filtroInteres);

                  return okDia && okArea;
                }).toList();

                if (filtrados.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron voluntarios con esos filtros.',
                      style: TextStyle(fontSize: 18, color: Colors.black45),
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: filtrados.length,
                  itemBuilder: (context, i) {
                    final v = VoluntarioModel.fromMap(
                      filtrados[i].id,
                      filtrados[i].data() as Map<String, dynamic>,
                    );
                    return _tarjetaVoluntario(v, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _filtroDias() {
    return DropdownButtonFormField<String>(
      decoration: _decoracionFiltro('Filtrar por día'),
      value: filtroDia ?? "Todos",
      items: [
        const DropdownMenuItem(
            value: "Todos", child: Text("Todos los días")),
        ...diasSemana.map((d) => DropdownMenuItem(value: d, child: Text(d))),
      ],
      onChanged: onFiltroDiaChanged,
    );
  }

  Widget _filtroIntereses() {
    return DropdownButtonFormField<String>(
      decoration: _decoracionFiltro('Filtrar por área'),
      value: filtroInteres ?? "Todas",
      items: [
        const DropdownMenuItem(
            value: "Todas", child: Text("Todas las áreas")),
        ...intereses.map((a) => DropdownMenuItem(value: a, child: Text(a))),
      ],
      onChanged: onFiltroInteresChanged,
    );
  }

  InputDecoration _decoracionFiltro(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: const Color(0xFFFFFCF5), 
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFFAE35), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  

  Widget _tarjetaVoluntario(VoluntarioModel v, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: const Color(0xFFFFFCF5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                const Icon(Icons.volunteer_activism,
                    size: 30, color: Color(0xFF226776)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    v.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () => _llamarTelefono(context, v.telefono),
                  icon: const Icon(Icons.phone, color: Colors.white, size: 22),
                  label: const Text('Contactar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),
            _fila(Icons.email_outlined, 'Correo', v.correo),
            _fila(Icons.phone, 'Teléfono', v.telefono),
            _fila(Icons.access_time, 'Horario', v.horario),
            _fila(Icons.calendar_today, 'Días', v.dias.join(', ')),
            _fila(Icons.category, 'Intereses', v.intereses.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icon, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFFAE35), size: 22),
          const SizedBox(width: 8),
          Text(
            '$titulo: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
