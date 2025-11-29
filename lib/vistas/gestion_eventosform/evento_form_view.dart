import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'evento_form_widget.dart';

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

  void guardarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
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
      await ref.add(data);
      Get.back();
      Get.snackbar('Éxito', '¡Evento creado correctamente!',
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      await ref.doc(widget.id).update(data);
      Get.back();
      Get.snackbar('Éxito', '¡Evento editado correctamente!',
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventoFormWidget(
      formKey: _formKey,
      tituloCtrl: tituloCtrl,
      descripcionCtrl: descripcionCtrl,
      fechaCtrl: fechaCtrl,
      horarioCtrl: horarioCtrl,
      ubicacionCtrl: ubicacionCtrl,
      tipo: tipo,
      tipos: tipos,
      publico: publico,
      onTipoChanged: (v) => setState(() => tipo = v),
      onPublicoChanged: (v) => setState(() => publico = v),
      guardarEvento: guardarEvento,
      isEdit: widget.id != null,
    );
  }
}
