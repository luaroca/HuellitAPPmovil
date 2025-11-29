import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventoFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController tituloCtrl;
  final TextEditingController descripcionCtrl;
  final TextEditingController fechaCtrl;
  final TextEditingController horarioCtrl;
  final TextEditingController ubicacionCtrl;

  final List<String> tipos;
  final String tipo;
  final bool publico;

  final Function(String) onTipoChanged;
  final Function(bool) onPublicoChanged;

  final VoidCallback guardarEvento;
  final bool isEdit;

  const EventoFormWidget({
    super.key,
    required this.formKey,
    required this.tituloCtrl,
    required this.descripcionCtrl,
    required this.fechaCtrl,
    required this.horarioCtrl,
    required this.ubicacionCtrl,
    required this.tipo,
    required this.tipos,
    required this.publico,
    required this.onTipoChanged,
    required this.onPublicoChanged,
    required this.guardarEvento,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C1A7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? 'Editar Evento' : 'Nuevo Evento',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    'Formulario de Evento',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF226776),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: tituloCtrl,
                    decoration: _inputDecoration('Título del Evento *'),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Tipo de Evento *'),
                    value: tipo.isEmpty ? null : tipo,
                    items: tipos.map((opt) =>
                        DropdownMenuItem(value: opt, child: Text(opt))).toList(),
                    onChanged: (v) => onTipoChanged(v ?? ''),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Selecciona un tipo' : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: descripcionCtrl,
                    minLines: 3,
                    maxLines: 6,
                    decoration: _inputDecoration('Descripción *'),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: TextFormField(
                          controller: fechaCtrl,
                          decoration: _inputDecoration('Fecha *', hint: 'dd/mm/aaaa'),
                          validator: (v) => v!.trim().isEmpty ? 'Completa la fecha' : null,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023, 1, 1),
                              lastDate: DateTime(2100, 12, 31),
                            );
                            if (picked != null) {
                              fechaCtrl.text =
                                  "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 13,
                        child: TextFormField(
                          controller: horarioCtrl,
                          decoration: _inputDecoration('Horario *',
                              hint: 'Ej: 09:00 AM - 03:00 PM'),
                          validator: (v) => v!.trim().isEmpty ? 'Completa el horario' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: ubicacionCtrl,
                    decoration: _inputDecoration('Ubicación *'),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        activeColor: const Color(0xFF55C1A7),
                        value: publico,
                        onChanged: (v) => onPublicoChanged(v ?? false),
                      ),
                      const Text(
                        'Publicar evento (visible para usuarios)',
                        style: TextStyle(color: Color(0xFF226776)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: guardarEvento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55C1A7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        isEdit ? 'Guardar Cambios' : 'Crear Evento',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF226776)),
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF55C1A7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF55C1A7), width: 2),
      ),
    );
  }
}
