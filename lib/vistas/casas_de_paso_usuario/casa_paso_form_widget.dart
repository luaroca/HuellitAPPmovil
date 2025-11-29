import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CasaPasoFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nombreCtrl;
  final TextEditingController telefonoCtrl;
  final TextEditingController direccionCtrl;
  final TextEditingController capacidadCtrl;
  final TextEditingController comentariosCtrl;

  final String tipoMascota;
  final bool experiencia;
  final bool patio;
  final List<String> tiposMascotas;

  final RxBool cargando;

  final Function() usarUbicacion;
  final Function(String) onTipoMascota;
  final Function(bool) onExperiencia;
  final Function(bool) onPatio;
  final Function() onEnviar;

  const CasaPasoFormWidget({
    super.key,
    required this.formKey,
    required this.nombreCtrl,
    required this.telefonoCtrl,
    required this.direccionCtrl,
    required this.capacidadCtrl,
    required this.comentariosCtrl,
    required this.tipoMascota,
    required this.experiencia,
    required this.patio,
    required this.tiposMascotas,
    required this.cargando,
    required this.usarUbicacion,
    required this.onTipoMascota,
    required this.onExperiencia,
    required this.onPatio,
    required this.onEnviar,
  });

  Widget _inputDecorado({
    required TextEditingController controller,
    required IconData icon,
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
        prefixIcon: Icon(icon, color: Color(0xFF14BF9B), size: 25),
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14BF9B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Registro de Casa de Paso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Formulario de Registro',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF118A74),
                    ),
                  ),
                  const SizedBox(height: 22),

                  _inputDecorado(
                    controller: nombreCtrl,
                    icon: Icons.person,
                    label: 'Nombre completo',
                    validator: (v) =>
                        v!.isEmpty ? 'Por favor, ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 15),

                  _inputDecorado(
                    controller: telefonoCtrl,
                    icon: Icons.phone,
                    label: 'Teléfono',
                    inputType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Por favor, ingresa tu teléfono' : null,
                  ),
                  const SizedBox(height: 15),

                  _inputDecorado(
                    controller: direccionCtrl,
                    icon: Icons.location_on,
                    label: 'Dirección',
                    validator: (v) =>
                        v!.isEmpty ? 'Por favor, ingresa una dirección' : null,
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: usarUbicacion,
                      icon:
                          const Icon(Icons.gps_fixed, color: Color(0xFF14BF9B)),
                      label: const Text(
                        'Usar mi ubicación actual',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF14BF9B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF14BF9B), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _inputDecorado(
                    controller: capacidadCtrl,
                    icon: Icons.pets,
                    label: 'Capacidad (número de mascotas)',
                    inputType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Indica la cantidad de mascotas';
                      if (int.tryParse(v) == null || int.parse(v) <= 0) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tipo de mascotas que puedes alojar',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: tipoMascota,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                    ),
                    items: tiposMascotas
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => onTipoMascota(v!),
                  ),
                  const SizedBox(height: 20),

                  CheckboxListTile(
                    value: experiencia,
                    onChanged: (v) => onExperiencia(v ?? false),
                    title: const Text(
                      'Tengo experiencia cuidando mascotas',
                      style: TextStyle(fontSize: 17),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF18C59B),
                  ),

                  CheckboxListTile(
                    value: patio,
                    onChanged: (v) => onPatio(v ?? false),
                    title: const Text(
                      'Mi casa tiene patio o jardín',
                      style: TextStyle(fontSize: 17),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF18C59B),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: comentariosCtrl,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                      labelText: 'Comentarios adicionales (opcional)',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText:
                          'Cuéntanos más sobre tu hogar y disponibilidad...',
                      fillColor: Colors.grey[50],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              color: Color(0xFF118A74)),
                          label: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF118A74),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF12B497), width: 1.6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Obx(
                          () => ElevatedButton.icon(
                            onPressed: cargando.value ? null : onEnviar,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: cargando.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Enviar',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF18C59B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
