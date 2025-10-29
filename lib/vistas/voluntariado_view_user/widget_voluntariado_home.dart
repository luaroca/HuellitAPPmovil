import 'package:flutter/material.dart';
import 'package:huellitas/modelos/voluntario_model.dart';

class WidgetVoluntariadoHome extends StatelessWidget {
  final bool loading;
  final VoluntarioModel? voluntario;
  final VoidCallback onRegistrar;
  final VoidCallback onConfirmarEliminar;

  const WidgetVoluntariadoHome({
    super.key,
    required this.loading,
    required this.voluntario,
    required this.onRegistrar,
    required this.onConfirmarEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF476AE8),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Voluntariado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF476AE8)))
          : voluntario == null
              ? _noVoluntarioWidget()
              : _voluntarioCardWidget(voluntario!),
    );
  }

  /// Vista cuando el usuario no está registrado
  Widget _noVoluntarioWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism, size: 110, color: Colors.blue[500]),
            const SizedBox(height: 30),
            const Text(
              'Aún no te has registrado como voluntario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 28),
              label: const Text(
                'Registrarme como Voluntario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF476AE8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
              onPressed: onRegistrar,
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta con los datos del voluntario
  Widget _voluntarioCardWidget(VoluntarioModel voluntario) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF4F8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volunteer_activism_rounded,
                        color: Color(0xFF476AE8), size: 36),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        voluntario.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 1.2, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 10),
                _infoRow(Icons.email_outlined, 'Correo', voluntario.correo),
                _infoRow(Icons.phone, 'Teléfono',
                    voluntario.telefono.isEmpty ? '-' : voluntario.telefono),
                _infoRow(Icons.calendar_month_rounded, 'Días disponibles',
                    voluntario.dias.join(', ')),
                _infoRow(Icons.access_time_filled, 'Horario disponible', voluntario.horario),
                _infoRow(Icons.favorite_rounded, 'Áreas de Interés',
                    voluntario.intereses.join(', ')),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    onPressed: onConfirmarEliminar,
                    icon: const Icon(Icons.logout_rounded, size: 24),
                    label: const Text(
                      'Retirarse del voluntariado',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fila con ícono + texto grande y legible
  Widget _infoRow(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF476AE8), size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: valor,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
