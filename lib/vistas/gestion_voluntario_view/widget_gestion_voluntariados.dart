import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/voluntario_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14BF9B),
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
                  final isNarrow = constraints.maxWidth < 600;
                  return isNarrow
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
                        child:
                            CircularProgressIndicator(color: Color(0xFF14BF9B)));
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay voluntarios registrados.',
                        style: TextStyle(
                            fontSize: 18, color: Colors.black54, height: 1.4),
                      ),
                    );
                  }

                  
                  final filtrados = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final dias = List<String>.from(data['dias'] ?? []);
                    final areas = List<String>.from(data['intereses'] ?? []);
                    final diaOk =
                        filtroDia == null || dias.contains(filtroDia);
                    final interesOk =
                        filtroInteres == null || areas.contains(filtroInteres);
                    return diaOk && interesOk;
                  }).toList();

                  if (filtrados.isEmpty) {
                    return const Center(
                      child: Text(
                        'No se encontraron voluntarios con esos filtros.',
                        style:
                            TextStyle(fontSize: 18, color: Colors.black45),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemCount: filtrados.length,
                    itemBuilder: (context, i) {
                      final v = VoluntarioModel.fromMap(
                        filtrados[i].id,
                        filtrados[i].data() as Map<String, dynamic>,
                      );
                      return _tarjetaVoluntario(v, textTheme);
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
      decoration: InputDecoration(
        labelText: 'Filtrar por día',
        labelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      value: filtroDia,
      items: [
        const DropdownMenuItem(value: null, child: Text('Todos los días')),
        ...diasSemana.map((d) => DropdownMenuItem(value: d, child: Text(d))),
      ],
      onChanged: onFiltroDiaChanged,
    );
  }

  
  Widget _filtroIntereses() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Área de interés',
        labelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      value: filtroInteres,
      items: [
        const DropdownMenuItem(value: null, child: Text('Todas las áreas')),
        ...intereses.map((a) => DropdownMenuItem(value: a, child: Text(a))),
      ],
      onChanged: onFiltroInteresChanged,
    );
  }

  
  Widget _tarjetaVoluntario(VoluntarioModel v, TextTheme textTheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volunteer_activism,
                  color: Color(0xFF14BF9B), size: 30),
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
            ],
          ),
          const SizedBox(height: 12),
          _infoFila(Icons.email_outlined, 'Correo', v.correo),
          _infoFila(Icons.phone, 'Teléfono',
              v.telefono.isNotEmpty ? v.telefono : '-'),
          _infoFila(Icons.access_time, 'Horario', v.horario),
          _infoFila(Icons.calendar_today, 'Días disponibles',
              v.dias.join(', ')),
          _infoFila(
              Icons.category, 'Áreas de Interés', v.intereses.join(', ')),
        ],
      ),
    );
  }

  
  Widget _infoFila(IconData icon, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal[400], size: 22),
          const SizedBox(width: 8),
          Text(
            '$titulo: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontSize: 17,
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
