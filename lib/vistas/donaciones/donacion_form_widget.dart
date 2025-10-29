import 'package:flutter/material.dart';

class DonacionFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreCtrl;
  final TextEditingController telefonoCtrl;
  final TextEditingController itemsCtrl;
  final TextEditingController direccionCtrl;
  final TextEditingController notasCtrl;
  final Future<void> Function() usarUbicacion;
  final Future<void> Function() enviarDonacion;

  const DonacionFormWidget({
    Key? key,
    required this.formKey,
    required this.nombreCtrl,
    required this.telefonoCtrl,
    required this.itemsCtrl,
    required this.direccionCtrl,
    required this.notasCtrl,
    required this.usarUbicacion,
    required this.enviarDonacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildCard([
              _buildLabel('Nombre Completo *'),
              _buildTextField(nombreCtrl, 'Ingresa tu nombre completo'),
              const SizedBox(height: 16),
              _buildLabel('Teléfono de Contacto *'),
              _buildTextField(
                telefonoCtrl,
                '+57 300 123 4567',
                tipo: TextInputType.phone,
              ),
            ]),
            _buildCard([
              _buildLabel('¿Qué deseas donar? *'),
              _buildTextField(itemsCtrl,
                  'Ej: Alimento para perros, mantas, medicamentos...'),
            ]),
            _buildCard([
              _buildLabel('Dirección para Recogida *'),
              TextFormField(
                controller: direccionCtrl,
                validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                decoration: _inputDecoration(
                  'Dirección completa',
                  icono: const Icon(Icons.location_on_outlined,
                      color: Color(0xFF0D7864)),
                ),
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D7864),
                    side: const BorderSide(color: Color(0xFF0D7864), width: 1.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text(
                    'Usar mi ubicación GPS',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  onPressed: usarUbicacion,
                ),
              ),
              const SizedBox(height: 18),
              _buildLabel('Notas Adicionales'),
              _buildTextField(notasCtrl,
                  'Horarios disponibles, instrucciones especiales...',
                  maxLines: 3),
            ]),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.black26),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: enviarDonacion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAE35),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Enviar Donación',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------- COMPONENTES DE UI ---------- //

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType tipo = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
      style: const TextStyle(fontSize: 17),
    );
  }

  InputDecoration _inputDecoration(String hint, {Icon? icono}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icono,
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Color(0xFF0D7864), width: 1.5),
      ),
    );
  }
}
