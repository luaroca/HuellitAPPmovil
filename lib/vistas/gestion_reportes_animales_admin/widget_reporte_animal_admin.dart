import 'package:flutter/material.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';

class WidgetReporteCard extends StatelessWidget {
  final ReporteAnimalModel reporte;
  final int index;
  final Function(String nuevoEstado) onCambiarEstado;

  const WidgetReporteCard({
    Key? key,
    required this.reporte,
    required this.index,
    required this.onCambiarEstado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fecha = reporte.fechaCreacion.toDate();
    final fechaString =
        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
    final horaString =
        "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Reporte #${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: reporte.estado == 'pendiente'
                      ? Colors.orange
                      : Colors.green,
                  label: Text(
                    reporte.estado.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            // ---------------- INFO ANIMAL ----------------
            const Text(
              "Animal reportado:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),

            Text("Descripción: ${reporte.descripcion}",
                style: const TextStyle(fontSize: 16)),
            Text("Condición: ${reporte.condicion}",
                style: const TextStyle(fontSize: 16)),
            Text("Dirección: ${reporte.direccion}",
                style: const TextStyle(fontSize: 16)),

            if (reporte.fotoUrl != null && reporte.fotoUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    reporte.fotoUrl!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const Divider(),

            // ---------------- INFO USUARIO ----------------
            const Text(
              "Reporte realizado por:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text("Nombre: ${reporte.nombreUsuario}",
                style: const TextStyle(fontSize: 16)),
            Text("Correo: ${reporte.correoUsuario}",
                style: const TextStyle(fontSize: 16)),
            Text("Teléfono: ${reporte.telefonoUsuario}",
                style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 12),

            // ---------------- FECHA ----------------
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 22, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Fecha: $fechaString",
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black54)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 22, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Hora: $horaString",
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black54)),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------- BOTONES ----------------
            Center(
              child: Wrap(
                spacing: 16,
                children: [
                  if (reporte.estado == "pendiente")
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle,
                          size: 26, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => onCambiarEstado("revisado"),
                      label: const Text(
                        "Revisado",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  if (reporte.estado == "revisado")
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh,
                          size: 26, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => onCambiarEstado("pendiente"),
                      label: const Text(
                        "Pendiente",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
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
