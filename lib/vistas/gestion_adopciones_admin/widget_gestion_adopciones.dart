import 'package:flutter/material.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class WidgetAdopcionCard extends StatelessWidget {
  final MascotaModel mascota;
  final VoidCallback onLlamar;
  final VoidCallback onWhatsApp;
  final VoidCallback onDenegar;
  final VoidCallback onConfirmar;

  const WidgetAdopcionCard({
    Key? key,
    required this.mascota,
    required this.onLlamar,
    required this.onWhatsApp,
    required this.onDenegar,
    required this.onConfirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFCF5),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            if (mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  mascota.fotoUrl!,
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 210,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.pets, size: 60, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 14),

            // CHIPS
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _chipInfo(mascota.tipo, const Color(0xFF226776)),
                _chipInfo(mascota.genero, const Color(0xFF0D7864)),
                _chipInfo("Tamaño: ${mascota.tamanio}", const Color(0xFF4DB6AC)),
                _chipInfo(
                  mascota.vacunado ? "Vacunado" : "No vacunado",
                  mascota.vacunado ? Colors.green : Colors.orange,
                ),
                _chipInfo(
                  mascota.esterilizado ? "Esterilizado" : "Sin esterilizar",
                  mascota.esterilizado ? Colors.green : Colors.redAccent,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // NOMBRE + ESTADO
            Row(
              children: [
                Expanded(
                  child: Text(
                    mascota.nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: mascota.adoptada
                        ? Colors.green.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    mascota.adoptada ? 'Aceptada' : 'Pendiente',
                    style: TextStyle(
                      color: mascota.adoptada ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            if (mascota.descripcion != null &&
                mascota.descripcion!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  mascota.descripcion!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),

            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),

            // DATOS DEL SOLICITANTE
            const Text(
              "Datos del Solicitante",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF226776),
              ),
            ),
            const SizedBox(height: 10),

            _infoRow(Icons.person, "Nombre", mascota.nombreUsuarioSolicitud),
            _infoRow(Icons.email, "Correo", mascota.correoUsuarioSolicitud),
            _infoRow(Icons.phone, "Teléfono", mascota.telefonoUsuarioSolicitud),

            const SizedBox(height: 14),

            // BOTONES DE CONTACTO
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLlamar,
                    icon: const Icon(Icons.call),
                    label: const Text("Llamar"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D7864),
                      side: const BorderSide(color: Color(0xFF0D7864)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onWhatsApp,
                    icon: Icon(Icons.message, color: Colors.green.shade700),
                    label: const Text("WhatsApp"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ACCIONES DE ADOPCIÓN
            if (!mascota.adoptada)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDenegar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Denegar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAE35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Text(
                  'Esta solicitud ya fue aceptada.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ------------ WIDGETS INTERNOS -------------------

  Widget _chipInfo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFAE35)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: ${value ?? '-'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
