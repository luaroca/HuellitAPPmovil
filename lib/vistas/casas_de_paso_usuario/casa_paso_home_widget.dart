import 'package:flutter/material.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';

class CasaPasoHomeWidget extends StatelessWidget {
  final bool loading;
  final CasaPasoModel? casa;

  final VoidCallback onAgregarCasa;
  final VoidCallback onEliminarCasa;
  final VoidCallback onVolver;

  const CasaPasoHomeWidget({
    super.key,
    required this.loading,
    required this.casa,
    required this.onAgregarCasa,
    required this.onEliminarCasa,
    required this.onVolver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12B497),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Casas de Paso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: onVolver,
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF12B497)))
          : casa == null
              ? _noCasaWidget()
              : _casaCardWidget(),
    );
  }

  Widget _noCasaWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined, size: 90, color: Colors.teal[300]),
            const SizedBox(height: 25),
            const Text(
              'Aún no tienes registrada una casa de paso',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_home, size: 26),
              label: const Text(
                'Registrar Casa de Paso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF12B497),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              onPressed: onAgregarCasa,
            ),
          ],
        ),
      ),
    );
  }

  Widget _casaCardWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
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
                    const Icon(Icons.home_rounded, color: Color(0xFF12B497), size: 35),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        casa!.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 10),
                _infoRow(Icons.phone, 'Teléfono', casa!.telefono),
                _infoRow(Icons.location_on, 'Dirección', casa!.direccion),
                _infoRow(Icons.pets, 'Capacidad', '${casa!.capacidad} mascotas'),
                _infoRow(Icons.category, 'Mascotas', casa!.tipoMascotas),
                if (casa!.experiencia) _infoRow(Icons.star, 'Experiencia', 'Sí'),
                if (casa!.tienePatio) _infoRow(Icons.park, 'Patio/jardín', 'Sí'),
                if (casa!.comentarios.isNotEmpty)
                  _infoRow(Icons.comment, 'Comentarios', casa!.comentarios),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    onPressed: onEliminarCasa,
                    icon: const Icon(Icons.delete_outline, size: 22),
                    label: const Text('Eliminar', style: TextStyle(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF12B497), size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: valor,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
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
