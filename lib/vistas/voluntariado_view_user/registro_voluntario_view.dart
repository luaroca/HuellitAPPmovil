import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:huellitas/controllers/voluntario_controller.dart';

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
    'Lunes','Martes','Miércoles','Jueves','Viernes','Sábados','Domingos'
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debes seleccionar al menos un día.'),
      ));
      return;
    }
    if (interesesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Selecciona mínimo un área de interés.'),
      ));
      return;
    }
    if(horarioCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debes ingresar tu horario disponible.'),
      ));
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
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF476AE8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Únete como Voluntario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Sé parte del cambio', style: TextStyle(fontSize: 13, color: Colors.white70)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 410,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.03), blurRadius: 4)],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _inputDecorado(
                    controller: nombreCtrl,
                    label: 'Nombre Completo *',
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 13),
                  _inputDecorado(
                    controller: correoCtrl,
                    label: 'Correo Electrónico *',
                    inputType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 13),
                  _inputDecorado(
                    controller: telefonoCtrl,
                    label: 'Teléfono',
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Disponibilidad *',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[900])),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: diasSemana.map((dia) => FilterChip(
                      label: Text(dia),
                      selected: diasSeleccionados.contains(dia),
                      onSelected: (sel) {
                        setState(() {
                          sel ? diasSeleccionados.add(dia) : diasSeleccionados.remove(dia);
                        });
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 15),
                  _inputDecorado(
                    controller: horarioCtrl,
                    label: 'Horario disponible (ej: 8am-12pm, tardes...)',
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Áreas de Interés *',
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[900])),
                  ),
                  const SizedBox(height: 7),
                  Column(
                    children: interesesList.map((interes) => CheckboxListTile(
                      value: interesesSeleccionados.contains(interes),
                      onChanged: (v) {
                        setState(() {
                          v!
                            ? interesesSeleccionados.add(interes)
                            : interesesSeleccionados.remove(interes);
                        });
                      },
                      title: Text(interes),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: controller.cargando.value ? null : enviar,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF476AE8), Color(0xFF6F8CEF)]
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: controller.cargando.value
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text(
                              'Registrarme como Voluntario',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
