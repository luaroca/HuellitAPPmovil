import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:huellitas/controllers/voluntario_controller.dart';
import 'registro_voluntario_widget.dart';

class RegistroVoluntarioView extends StatefulWidget {
  const RegistroVoluntarioView({super.key});

  @override
  State<RegistroVoluntarioView> createState() => _RegistroVoluntarioViewState();
}

class _RegistroVoluntarioViewState extends State<RegistroVoluntarioView> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final horarioCtrl = TextEditingController();

  final diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábados', 'Domingos'
  ];
  final interesesList = [
    'Rescates', 'Jornadas de adopción', 'Esterilización',
    'Alimentación', 'Redes sociales', 'Eventos y campañas'
  ];

  List<String> diasSeleccionados = [];
  List<String> interesesSeleccionados = [];

  final controller = Get.put(VoluntarioController());

  @override
  void dispose() {
    nombreCtrl.dispose();
    correoCtrl.dispose();
    telefonoCtrl.dispose();
    horarioCtrl.dispose();
    super.dispose();
  }

  void enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar al menos un día.')),
      );
      return;
    }
    if (interesesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona mínimo un área de interés.')),
      );
      return;
    }
    if (horarioCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes ingresar tu horario disponible.')),
      );
      return;
    }

    final modelo = VoluntarioModel(
      nombre: nombreCtrl.text.trim(),
      correo: correoCtrl.text.trim(),
      telefono: telefonoCtrl.text.trim(),
      dias: diasSeleccionados,
      horario: horarioCtrl.text.trim(),
      intereses: interesesSeleccionados,
    );

    await controller.registrarVoluntario(modelo);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Registro exitoso!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFF476AE8),
        title: const Text(
          'Registro de Voluntariado',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RegistroVoluntarioWidget(
        formKey: _formKey,
        nombreCtrl: nombreCtrl,
        correoCtrl: correoCtrl,
        telefonoCtrl: telefonoCtrl,
        horarioCtrl: horarioCtrl,
        diasSemana: diasSemana,
        interesesList: interesesList,
        diasSeleccionados: diasSeleccionados,
        interesesSeleccionados: interesesSeleccionados,
        onEnviar: enviar,
        controller: controller,
        onActualizarDias: (List<String> nuevosDias) {
          setState(() => diasSeleccionados = nuevosDias);
        },
        onActualizarIntereses: (List<String> nuevosIntereses) {
          setState(() => interesesSeleccionados = nuevosIntereses);
        },
      ),
    );
  }
}
