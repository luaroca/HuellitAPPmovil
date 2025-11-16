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
        backgroundColor: const Color(0xFF4DB6AC),
        title: const Text(
          'Gestión de Voluntariados',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 600;
                  return narrow
                      ? Column(
                          children: [
                            _filtroDias(),
                            const SizedBox(height: 10),
                            _filtroIntereses(),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _filtroDias()),
                            const SizedBox(width: 10),
                            Expanded(child: _filtroIntereses()),
                          ],
                        );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: streamVoluntarios,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF4DB6AC)),
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

                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _filtroDias() {
    return DropdownButtonFormField<String>(
      decoration: _decoracion('Filtrar por día'),
      value: filtroDia ?? "Todos",
      dropdownColor: Colors.white,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      items: [
        const DropdownMenuItem(
          value: "Todos",
          child: Text("Todos los días", style: TextStyle(color: Colors.black)),
        ),
        ...diasSemana.map(
          (d) => DropdownMenuItem(
            value: d,
            child: Text(d, style: const TextStyle(color: Colors.black)),
          ),
        ),
      ],
      onChanged: onFiltroDiaChanged,
    );
  }

  Widget _filtroIntereses() {
    return DropdownButtonFormField<String>(
      decoration: _decoracion('Área de interés'),
      value: filtroInteres ?? "Todas",
      dropdownColor: Colors.white,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      items: [
        const DropdownMenuItem(
          value: "Todas",
          child: Text("Todas las áreas", style: TextStyle(color: Colors.black)),
        ),
        ...intereses.map(
          (a) => DropdownMenuItem(
            value: a,
            child: Text(a, style: const TextStyle(color: Colors.black)),
          ),
        ),
      ],
      onChanged: onFiltroInteresChanged,
    );
  }

  InputDecoration _decoracion(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    );
  }

  Widget _tarjetaVoluntario(VoluntarioModel v, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6F1E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volunteer_activism,
                  color: Color(0xFF4DB6AC), size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  v.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.black87,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone, size: 24),
                label: const Text('Contactar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB6AC),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _llamarTelefono(context, v.telefono);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fila(Icons.email_outlined, 'Correo', v.correo),
          _fila(Icons.phone, 'Teléfono',
              v.telefono.isNotEmpty ? v.telefono : '-'),
          _fila(Icons.access_time, 'Horario', v.horario),
          _fila(Icons.calendar_today, 'Días', v.dias.join(', ')),
          _fila(Icons.category, 'Intereses', v.intereses.join(', ')),
        ],
      ),
    );
  }

  void _llamarTelefonoo(BuildContext context, String telefono) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la aplicación de llamadas')),
      );
    }
  }

  Widget _fila(IconData icon, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4DB6AC), size: 22),
          const SizedBox(width: 8),
          Text(
            '$titulo: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                height: 1.3,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
