import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:huellitas/controllers/report_animal_controller.dart';


class ReportarAnimalView extends StatelessWidget {
  final ReportAnimalController controller = Get.put(ReportAnimalController());
  final _formKey = GlobalKey<FormState>();

  // Función para obtener ubicación GPS y llenar campos en controlador
  Future<void> usarUbicacion(BuildContext context) async {
    final permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado.')),
      );
      return;
    }
    final pos =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.lat.value = pos.latitude;
    controller.lng.value = pos.longitude;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final place = placemarks.first;
      String direccionBonita = [
        if (place.street != null && place.street!.isNotEmpty) place.street!,
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          place.subLocality!,
        if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty)
          place.administrativeArea!,
      ].join(', ');

      controller.direccion.value = direccionBonita.isNotEmpty
          ? direccionBonita
          : '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ubicación capturada: ${controller.direccion.value}')),
      );
    } catch (e) {
      controller.direccion.value =
          '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ubicación obtenida mediante coordenadas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        elevation: 3,
        title: const Text('Reportar Animal en Calle',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Ayúdanos a rescatar animales en necesidad 🐾',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                return _buildCard([
                  _buildSectionHeader("Ubicación del Animal", Icons.location_on_outlined),
                  const SizedBox(height: 12),
                  _buildLabel("Dirección o punto de referencia *"),
                  TextFormField(
                    initialValue: controller.direccion.value,
                    onChanged: (val) => controller.direccion.value = val,
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
                      onPressed: () => usarUbicacion(context),
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text(
                        'Usar mi ubicación GPS',
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D7864),
                        side: const BorderSide(color: Color(0xFF0D7864), width: 1.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ]);
              }),

              Obx(() {
                return _buildCard([
                  _buildSectionHeader("Fotos del Animal", Icons.photo_camera_outlined),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      await controller.pickImage();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        border: Border.all(color: const Color(0xFFFFAE35), width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.imageFile.value == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
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
                            )
                          : Image.file(
                              controller.imageFile.value!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ]);
              }),

              Obx(() {
                return _buildCard([
                  _buildSectionHeader("Información del Animal", Icons.pets_outlined),
                  const SizedBox(height: 12),
                  _buildLabel("Descripción del Animal *"),
                  TextFormField(
                    initialValue: controller.descripcion.value,
                    onChanged: (val) => controller.descripcion.value = val,
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                    decoration: _inputDecoration(
                      "Ej: Perro mediano, color negro, con collar azul...",
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  _buildLabel("Estado y Condición *"),
                  TextFormField(
                    initialValue: controller.condicion.value,
                    onChanged: (val) => controller.condicion.value = val,
                    validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                    decoration: _inputDecoration(
                      "Ej: Parece herido, cojea de una pata, asustado...",
                    ),
                    maxLines: 2,
                  ),
                ]);
              }),

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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await controller.submitReport();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('🐕 Reporte enviado correctamente. ¡Gracias por ayudar!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
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

  // Componentes visuales reutilizables
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
          Icon(icono, color: const Color(0xFF0D7864)),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
          borderSide: const BorderSide(color: Color(0xFF0D7864), width: 1.5),
        ),
      );
}
