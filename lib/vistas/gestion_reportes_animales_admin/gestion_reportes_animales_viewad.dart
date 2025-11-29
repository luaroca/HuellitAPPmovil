import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/reporte_animal_controller.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';

class GestionReportesAnimalesView extends StatefulWidget {
  const GestionReportesAnimalesView({Key? key}) : super(key: key);

  @override
  State<GestionReportesAnimalesView> createState() =>
      _GestionReportesAnimalesViewState();
}

class _GestionReportesAnimalesViewState
    extends State<GestionReportesAnimalesView> {
  String filtroEstado = 'pendiente';

  @override
  Widget build(BuildContext context) {
    final reporteController = Get.find<ReporteAnimalController>();

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Reportes de Animales',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // Filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    "Filtrar:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: DropdownButton<String>(
                        value: filtroEstado,
                        underline: Container(),
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        items: const [
                          DropdownMenuItem(
                            value: "pendiente",
                            child: Text("Pendientes"),
                          ),
                          DropdownMenuItem(
                            value: "revisado",
                            child: Text("Revisados"),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => filtroEstado = v);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {
              final reportes = reporteController.reportes
                  .where((r) => r.estado == filtroEstado)
                  .toList();

              if (reportes.isEmpty) {
                return const Center(
                  child: Text(
                    "No hay reportes para este estado.",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 18),
                itemCount: reportes.length,
                itemBuilder: (_, index) {
                  final reporte = reportes[index];
                  final fecha = reporte.fechaCreacion.toDate();

                  final fechaString =
                      "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
                  final horaString =
                      "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}";

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                          // Header
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
                                backgroundColor:
                                    reporte.estado == 'pendiente'
                                        ? Colors.orange
                                        : Colors.green,
                                label: Text(
                                  reporte.estado.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Divider(),

                          // Info animal
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

                          if (reporte.fotoUrl != null &&
                              reporte.fotoUrl!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
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

                          // Info usuario
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

                          const SizedBox(height: 10),

                          // Fecha y hora
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

                          const SizedBox(height: 18),

                          
                          Center(
                            child: Wrap(
                              spacing: 14,
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
                                    onPressed: () async {
                                      final actualizado = ReporteAnimalModel(
                                        id: reporte.id,
                                        uid: reporte.uid,
                                        nombreUsuario: reporte.nombreUsuario,
                                        correoUsuario: reporte.correoUsuario,
                                        telefonoUsuario:
                                            reporte.telefonoUsuario,
                                        direccion: reporte.direccion,
                                        descripcion: reporte.descripcion,
                                        condicion: reporte.condicion,
                                        lat: reporte.lat,
                                        lng: reporte.lng,
                                        estado: "revisado",
                                        fotoUrl: reporte.fotoUrl,
                                        fechaCreacion: reporte.fechaCreacion,
                                      );

                                      await reporteController
                                          .actualizarReporte(actualizado);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Marcado como revisado.')));
                                    },
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
                                    onPressed: () async {
                                      final actualizado = ReporteAnimalModel(
                                        id: reporte.id,
                                        uid: reporte.uid,
                                        nombreUsuario: reporte.nombreUsuario,
                                        correoUsuario: reporte.correoUsuario,
                                        telefonoUsuario:
                                            reporte.telefonoUsuario,
                                        direccion: reporte.direccion,
                                        descripcion: reporte.descripcion,
                                        condicion: reporte.condicion,
                                        lat: reporte.lat,
                                        lng: reporte.lng,
                                        estado: "pendiente",
                                        fotoUrl: reporte.fotoUrl,
                                        fechaCreacion: reporte.fechaCreacion,
                                      );

                                      await reporteController
                                          .actualizarReporte(actualizado);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Marcado como pendiente.')));
                                    },
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
