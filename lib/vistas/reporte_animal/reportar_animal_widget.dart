import 'package:flutter/material.dart';

class ReportarAnimalWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController direccionCtrl;
  final TextEditingController descripcionCtrl;
  final TextEditingController condicionCtrl;
  final Future<void> Function() usarUbicacion;
  final VoidCallback enviarReporte;

  const ReportarAnimalWidget({
    Key? key,
    required this.formKey,
    required this.direccionCtrl,
    required this.descripcionCtrl,
    required this.condicionCtrl,
    required this.usarUbicacion,
    required this.enviarReporte,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        elevation: 3,
        automaticallyImplyLeading: true,
        title: const Text(
          'Reportar Animal en Calle',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Ayúdanos a rescatar animales en necesidad 🐾',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              
              _buildCard([
                _buildSectionHeader("Ubicación del Animal", Icons.location_on_outlined),
                const SizedBox(height: 12),
                _buildLabel("Dirección o punto de referencia *"),
                TextFormField(
                  controller: direccionCtrl,
                  validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  decoration: _inputDecoration(
                    "Ej: Calle 45 # 23-15, cerca del parque...",
                    icono: const Icon(Icons.place, color: Color(0xFF0D7864)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: usarUbicacion,
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text(
                      'Usar mi ubicación GPS',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D7864),
                      side: const BorderSide(color: Color(0xFF0D7864), width: 1.3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ]),

              
              _buildCard([
                _buildSectionHeader("Fotos del Animal", Icons.photo_camera_outlined),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función de subir foto próximamente.')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      border: Border.all(color: const Color(0xFFFFAE35), width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, color: Color(0xFFFFAE35), size: 32),
                        SizedBox(height: 7),
                        Text(
                          'Subir foto',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),

              
              _buildCard([
                _buildSectionHeader("Información del Animal", Icons.pets_outlined),
                const SizedBox(height: 12),
                _buildLabel("Descripción del Animal *"),
                TextFormField(
                  controller: descripcionCtrl,
                  validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  decoration: _inputDecoration(
                    "Ej: Perro mediano, color negro, con collar azul...",
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                _buildLabel("Estado y Condición *"),
                TextFormField(
                  controller: condicionCtrl,
                  validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  decoration: _inputDecoration(
                    "Ej: Parece herido, cojea de una pata, asustado...",
                  ),
                  maxLines: 2,
                ),
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
                      onPressed: enviarReporte,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAE35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Enviar Reporte',
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
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildCard(List<Widget> children) => Card(
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

  Widget _buildSectionHeader(String titulo, IconData icono) => Row(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Icon(icono, color: Color(0xFF0D7864)),
        ],
      );

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Colors.black87,
          ),
        ),
      );

  InputDecoration _inputDecoration(String hint, {Icon? icono}) => InputDecoration(
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
