import 'package:flutter/material.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class AsignarMascotaWidget extends StatelessWidget {
  final List<MascotaModel> mascotas;
  final String? selectedMascotaId;

  final DateTime? fechaIngreso;
  final DateTime? fechaSalida;
  final TimeOfDay? horaSalida;

  final bool loading;
  final String? errorMsg;

  final Function(String?) onMascotaChanged;
  final Function(DateTime fecha) onSelectFechaIngreso;
  final Function(DateTime fecha, TimeOfDay? hora) onSelectFechaSalida;
  final Function() onAsignar;

  const AsignarMascotaWidget({
    Key? key,
    required this.mascotas,
    required this.selectedMascotaId,
    required this.fechaIngreso,
    required this.fechaSalida,
    required this.horaSalida,
    required this.loading,
    required this.errorMsg,
    required this.onMascotaChanged,
    required this.onSelectFechaIngreso,
    required this.onSelectFechaSalida,
    required this.onAsignar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF12B497),
        title: const Text(
          "Asignar Mascota",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: mascotas.isEmpty
          ? const Center(
              child: Text(
                "No hay mascotas disponibles para asignar.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCard(
                      child: DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Elegir mascota"),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        isExpanded: true,
                        value: selectedMascotaId,
                        items: mascotas
                            .map((m) => DropdownMenuItem(
                                  value: m.id,
                                  child: Text(
                                    '${m.nombre} (${m.genero} - ${m.tamanio})',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                        onChanged: onMascotaChanged,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildCard(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_month,
                            size: 32, color: Colors.black87),
                        title: Text(
                          fechaIngreso != null
                              ? 'Ingreso: ${_formatDate(fechaIngreso!)}'
                              : 'Seleccione fecha de ingreso',
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now(),
                          );
                          if (fecha != null) {
                            onSelectFechaIngreso(fecha);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildCard(
                      child: ListTile(
                        leading: const Icon(Icons.access_time,
                            size: 32, color: Colors.black87),
                        title: Text(
                          (fechaSalida != null && horaSalida != null)
                              ? 'Salida: ${_formatDate(fechaSalida!)} - ${horaSalida!.format(context)}'
                              : 'Seleccione fecha y hora de salida',
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDate: fechaIngreso ?? DateTime.now(),
                          );
                          if (fecha != null) {
                            final hora = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            onSelectFechaSalida(fecha, hora);
                          }
                        },
                      ),
                    ),

                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          errorMsg!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check, size: 26),
                        label: const Text(
                          "Asignar",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF12B497),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: loading ? null : onAsignar,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 18, color: Colors.black87),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
