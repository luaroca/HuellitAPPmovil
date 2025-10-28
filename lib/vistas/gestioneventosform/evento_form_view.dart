import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Puedes recibir los datos por argumentos si estás editando
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
      Get.snackbar('Exito', '¡Evento creado correctamente!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      await ref.doc(widget.id).update(evento);
      Get.back();
      Get.snackbar('Exito', '¡Evento editado correctamente!',
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232B47),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(widget.id == null ? 'Nuevo Evento' : 'Editar Evento', style: const TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 8),
              child: Text(
                widget.id == null
                    ? 'Completa la información del evento'
                    : 'Modifica la información del evento',
                style: TextStyle(color: Colors.white.withOpacity(.7), fontSize: 15),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.03), blurRadius: 4)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Título
                  TextFormField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título del Evento *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 13),
                  // Tipo de evento
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Evento *',
                      border: OutlineInputBorder(),
                    ),
                    value: tipo.isEmpty ? null : tipo,
                    items: tipos.map((opt) =>
                      DropdownMenuItem(value: opt, child: Text(opt))).toList(),
                    onChanged: (v) => setState(() => tipo = v ?? ''),
                    validator: (v) => (v == null || v.isEmpty) ? 'Selecciona un tipo' : null,
                  ),
                  const SizedBox(height: 13),
                  // Descripción
                  TextFormField(
                    controller: descripcionCtrl,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Descripción *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: TextFormField(
                          controller: fechaCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Fecha *',
                            hintText: 'dd/mm/aaaa',
                            border: OutlineInputBorder(),
                          ),
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
                          decoration: const InputDecoration(
                            labelText: 'Horario *',
                            hintText: 'Ej: 09:00 AM - 03:00 PM',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v!.trim().isEmpty ? 'Completa el horario' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  // Ubicación
                  TextFormField(
                    controller: ubicacionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.trim().isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Checkbox(
                        value: publico,
                        onChanged: (v) => setState(() => publico = v ?? false),
                      ),
                      const Text('Publicar evento (visible para usuarios)'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _guardarEvento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF232B47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(widget.id == null ? 'Crear Evento' : 'Guardar Cambios', style: const TextStyle(fontSize: 17)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
