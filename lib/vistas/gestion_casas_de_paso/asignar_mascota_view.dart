import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class AsignarMascotaView extends StatefulWidget {
  final CasaPasoModel casaDePaso;
  const AsignarMascotaView({Key? key, required this.casaDePaso})
      : super(key: key);

  @override
  State<AsignarMascotaView> createState() => _AsignarMascotaViewState();
}

class _AsignarMascotaViewState extends State<AsignarMascotaView> {
  String? selectedMascotaId;
  List<MascotaModel> mascotas = [];
  DateTime? fechaIngreso;
  DateTime? fechaSalida;
  TimeOfDay? horaSalida;
  bool loading = false;
  String? errorMsg;

  Future<void> _cargarMascotas() async {
    final snap = await FirebaseFirestore.instance
        .collection('mascotas')
        .where('disponible', isEqualTo: false)
        .get();

    final docs = snap.docs;
    setState(() {
      mascotas = docs
          .where((e) =>
              !e.data().containsKey('casaPasoId') ||
              e.get('casaPasoId') == null ||
              (e.get('casaPasoId') is String && e.get('casaPasoId').isEmpty))
          .map((e) => MascotaModel.fromMap({...e.data(), 'id': e.id}))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarMascotas();
  }

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
                        items: mascotas
                            .map((m) => DropdownMenuItem(
                                  value: m.id,
                                  child: Text(
                                    '${m.nombre} (${m.genero} - ${m.tamanio})',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ))
                            .toList(),
                        value: selectedMascotaId,
                        onChanged: (v) {
                          setState(() => selectedMascotaId = v);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // feecha de ingresoooooooooooooo
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
                            setState(() => fechaIngreso = fecha);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Fecha y hora de salida
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
                            setState(() {
                              fechaSalida = fecha;
                              horaSalida = hora;
                            });
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
                        onPressed: loading
                            ? null
                            : () async {
                                setState(() {
                                  errorMsg = null;
                                  loading = true;
                                });

                                if (selectedMascotaId == null ||
                                    fechaIngreso == null ||
                                    fechaSalida == null ||
                                    horaSalida == null) {
                                  setState(() {
                                    errorMsg =
                                        "Seleccione mascota, fecha de ingreso y salida.";
                                    loading = false;
                                  });
                                  return;
                                }

                                final fechaSalidaCompleta = DateTime(
                                  fechaSalida!.year,
                                  fechaSalida!.month,
                                  fechaSalida!.day,
                                  horaSalida!.hour,
                                  horaSalida!.minute,
                                );

                                await FirebaseFirestore.instance
                                    .collection('mascotas')
                                    .doc(selectedMascotaId!)
                                    .update({
                                  'casaPasoId': widget.casaDePaso.id,
                                  'disponible': false,
                                  'fechaIngresoCasa':
                                      Timestamp.fromDate(fechaIngreso!),
                                  'fechaSalidaCasa':
                                      Timestamp.fromDate(fechaSalidaCompleta),
                                });

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Mascota asignada correctamente')),
                                  );
                                }
                              },
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
      labelStyle:
          const TextStyle(fontSize: 18, color: Colors.black87),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
