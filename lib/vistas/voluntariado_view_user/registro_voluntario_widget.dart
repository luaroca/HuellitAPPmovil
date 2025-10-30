import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/voluntario_controller.dart';

class RegistroVoluntarioWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreCtrl;
  final TextEditingController correoCtrl;
  final TextEditingController telefonoCtrl;
  final TextEditingController horarioCtrl;
  final List<String> diasSemana;
  final List<String> interesesList;
  final List<String> diasSeleccionados;
  final List<String> interesesSeleccionados;
  final VoidCallback onEnviar;
  final VoluntarioController controller;
  final Function(List<String>) onActualizarDias;
  final Function(List<String>) onActualizarIntereses;

  const RegistroVoluntarioWidget({
    super.key,
    required this.formKey,
    required this.nombreCtrl,
    required this.correoCtrl,
    required this.telefonoCtrl,
    required this.horarioCtrl,
    required this.diasSemana,
    required this.interesesList,
    required this.diasSeleccionados,
    required this.interesesSeleccionados,
    required this.onEnviar,
    required this.controller,
    required this.onActualizarDias,
    required this.onActualizarIntereses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFA8E6CF),
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulario de Registro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F4E60),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _inputDecorado(
                    controller: nombreCtrl,
                    label: 'Nombre Completo *',
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 15),

                  _inputDecorado(
                    controller: correoCtrl,
                    label: 'Correo Electrónico *',
                    inputType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 15),

                  _inputDecorado(
                    controller: telefonoCtrl,
                    label: 'Teléfono',
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Disponibilidad *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: diasSemana.map((dia) {
                      final seleccionado = diasSeleccionados.contains(dia);
                      return FilterChip(
                        label: Text(
                          dia,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: seleccionado ? Colors.white : Colors.black87,
                          ),
                        ),
                        selected: seleccionado,
                        onSelected: (sel) {
                          final nuevos = List<String>.from(diasSeleccionados);
                          sel ? nuevos.add(dia) : nuevos.remove(dia);
                          onActualizarDias(nuevos);
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color(0xFF226776),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _inputDecorado(
                    controller: horarioCtrl,
                    label: 'Horario disponible (ej: 8am - 12pm, tardes...) *',
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Áreas de Interés *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: interesesList.map((interes) {
                      final seleccionado =
                          interesesSeleccionados.contains(interes);
                      return CheckboxListTile(
                        value: seleccionado,
                        onChanged: (v) {
                          final nuevos =
                              List<String>.from(interesesSeleccionados);
                          v! ? nuevos.add(interes) : nuevos.remove(interes);
                          onActualizarIntereses(nuevos);
                        },
                        title:
                            Text(interes, style: const TextStyle(fontSize: 17)),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF226776),
                        dense: false,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),

                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF1F4E60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                          ),
                          onPressed: controller.cargando.value ? null : onEnviar,
                          child: controller.cargando.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Registrarme como Voluntario',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _inputDecorado({
    required TextEditingController controller,
    required String label,
    TextInputType? inputType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 17, color: Colors.black87),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
