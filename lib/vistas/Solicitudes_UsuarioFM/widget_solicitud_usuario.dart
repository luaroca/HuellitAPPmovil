import 'package:flutter/material.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class WidgetSolicitudCard extends StatelessWidget {
  final MascotaModel mascota;

  const WidgetSolicitudCard({
    Key? key,
    required this.mascota,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 22),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ------------------ FOTO ------------------
            if (mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  mascota.fotoUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.pets,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 18),

            /// ------------------ NOMBRE ------------------
            Text(
              mascota.nombre,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// ------------------ DATOS ------------------
            Text(
              '${mascota.tipo} • ${mascota.genero}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
              ),
            ),
            Text(
              'Tamaño: ${mascota.tamanio}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
              ),
            ),
            Text(
              'Vacunado: ${mascota.vacunado ? "Sí" : "No"}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
              ),
            ),
            Text(
              'Esterilizado: ${mascota.esterilizado ? "Sí" : "No"}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
              ),
            ),

            /// ------------------ DESCRIPCIÓN ------------------
            if (mascota.descripcion != null &&
                mascota.descripcion!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  'Descripción: ${mascota.descripcion}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
              ),

            const SizedBox(height: 14),

            /// ------------------ MENSAJE DE CONFIRMACIÓN ------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF4DB6AC).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4DB6AC),
                  width: 1.5,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF4DB6AC),
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Solicitud Confirmada",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Color(0xFF4DB6AC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
