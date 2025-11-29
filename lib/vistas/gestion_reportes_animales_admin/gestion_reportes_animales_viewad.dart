import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/reporte_animal_controller.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';
import 'package:huellitas/vistas/gestion_reportes_animales_admin/widget_reporte_animal_admin.dart';


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
          const SizedBox(height: 16),

          // ---------------- FILTRO ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
                    child: DropdownButtonFormField<String>(
                      value: filtroEstado,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: const Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "pendiente", child: Text("Pendientes")),
                        DropdownMenuItem(
                            value: "revisado", child: Text("Revisados")),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => filtroEstado = v);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ---------------- LISTA DE REPORTES ----------------
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
                padding:
                    const EdgeInsets.only(left: 18, right: 18, bottom: 20),
                itemCount: reportes.length,
                itemBuilder: (_, index) {
                  final reporte = reportes[index];

                  return WidgetReporteCard(
                    reporte: reporte,
                    index: index,
                    onCambiarEstado: (nuevoEstado) async {
                      final actualizado = ReporteAnimalModel(
                        id: reporte.id,
                        uid: reporte.uid,
                        nombreUsuario: reporte.nombreUsuario,
                        correoUsuario: reporte.correoUsuario,
                        telefonoUsuario: reporte.telefonoUsuario,
                        direccion: reporte.direccion,
                        descripcion: reporte.descripcion,
                        condicion: reporte.condicion,
                        lat: reporte.lat,
                        lng: reporte.lng,
                        estado: nuevoEstado,
                        fotoUrl: reporte.fotoUrl,
                        fechaCreacion: reporte.fechaCreacion,
                      );

                      await reporteController.actualizarReporte(actualizado);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Estado cambiado a $nuevoEstado'),
                        ),
                      );
                    },
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
