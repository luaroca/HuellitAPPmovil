import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventoFormView extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? initialData;
  const EventoFormView({Key? key, this.id, this.initialData}) : super(key: key);

  @override
  State<EventoFormView> createState() => _EventoFormViewState();
}

class _EventoFormViewState extends State<EventoFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();
  final TextEditingController fechaCtrl = TextEditingController();
  final TextEditingController horarioCtrl = TextEditingController();
  final TextEditingController ubicacionCtrl = TextEditingController();
  String tipo = '';
  bool publico = false;

  final tipos = ['Esterilización', 'Adopción', 'Otro'];

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    if (d != null) {
      tituloCtrl.text = d['titulo'] ?? '';
      descripcionCtrl.text = d['descripcion'] ?? '';
      tipo = d['tipo'] ?? '';
      fechaCtrl.text = d['fecha'] ?? '';
      horarioCtrl.text = d['horario'] ?? '';
      ubicacionCtrl.text = d['ubicacion'] ?? '';
      publico = d['publico'] ?? false;
    }
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    fechaCtrl.dispose();
    horarioCtrl.dispose();
    ubicacionCtrl.dispose();
    super.dispose();
  }

  void _guardarEvento() async {
    if (!_formKey.currentState!.validate()) return;
    final evento = {
      'titulo': tituloCtrl.text.trim(),
      'tipo': tipo,
      'descripcion': descripcionCtrl.text.trim(),
      'fecha': fechaCtrl.text.trim(),
      'horario': horarioCtrl.text.trim(),
      'ubicacion': ubicacionCtrl.text.trim(),
      'publico': publico,
    };

    final ref = FirebaseFirestore.instance.collection('eventos');
    if (widget.id == null) {
      await ref.add(evento);
      Get.back();
      Get.snackbar('Éxito', '¡Evento creado correctamente!',
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      await ref.doc(widget.id).update(evento);
      Get.back();
      Get.snackbar('Éxito', '¡Evento editado correctamente!',
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

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
          widget.id == null ? 'Nuevo Evento' : 'Editar Evento',
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
              key: _formKey,
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
                    items: tipos
                        .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                        .toList(),
                    onChanged: (v) => setState(() => tipo = v ?? ''),
                    validator: (v) => (v == null || v.isEmpty) ? 'Selecciona un tipo' : null,
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
                          decoration: _inputDecoration('Horario *', hint: 'Ej: 09:00 AM - 03:00 PM'),
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
                        onChanged: (v) => setState(() => publico = v ?? false),
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
                      onPressed: _guardarEvento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55C1A7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        widget.id == null ? 'Crear Evento' : 'Guardar Cambios',
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
