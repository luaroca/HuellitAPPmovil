import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/controllers/casa_paso_controller.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';

class CasaPasoView extends StatefulWidget {
  final String userId;
  const CasaPasoView({Key? key, required this.userId}) : super(key: key);

  @override
  State<CasaPasoView> createState() => _CasaPasoViewState();
}

class _CasaPasoViewState extends State<CasaPasoView> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final capacidadCtrl = TextEditingController();
  final comentariosCtrl = TextEditingController();

  String tipoMascota = 'Perros y gatos';
  bool experiencia = false;
  bool patio = false;

  final tiposMascotas = [
    'Perros y gatos',
    'Solo perros',
    'Solo gatos',
    'Otras especies'
  ];

  final controller = Get.put(CasaPasoController());
  double? lat;
  double? lng;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Future<void> cargarDatosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        nombreCtrl.text = (data['nombres'] ?? '').toString();
        telefonoCtrl.text = (data['telefono'] ?? '').toString();
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    direccionCtrl.dispose();
    capacidadCtrl.dispose();
    comentariosCtrl.dispose();
    super.dispose();
  }

  Future<void> usarUbicacion() async {
    final permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado.')),
      );
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = pos.latitude;
    lng = pos.longitude;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
      final place = placemarks.first;
      String direccionBonita = [
        if (place.street != null && place.street!.isNotEmpty) place.street!,
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          place.subLocality!,
        if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          place.administrativeArea!,
        if (place.country != null && place.country!.isNotEmpty) place.country!,
      ].join(', ');

      setState(() {
        direccionCtrl.text = direccionBonita.isNotEmpty
            ? direccionBonita
            : '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });
      // 🔹 Eliminado mensaje de "Ubicación capturada"
    } catch (e) {
      setState(() {
        direccionCtrl.text =
            '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No se pudo obtener la dirección, usando coordenadas.')),
      );
    }
  }

  void enviar() async {
    if (!_formKey.currentState!.validate()) return;

    final model = CasaPasoModel(
      userId: widget.userId,
      nombre: nombreCtrl.text.trim(),
      telefono: telefonoCtrl.text.trim(),
      direccion: direccionCtrl.text.trim(),
      capacidad: int.tryParse(capacidadCtrl.text.trim()) ?? 0,
      tipoMascotas: tipoMascota,
      experiencia: experiencia,
      tienePatio: patio,
      comentarios: comentariosCtrl.text.trim(),
    );

    await controller.registrarCasa(model);

    if (mounted) {
     
      Navigator.pop(context);
    }
  }

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
        prefixIcon: Icon(icon, color: const Color(0xFF14BF9B), size: 25),
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
            padding:
                const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Form(
              key: _formKey,
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
                      icon: const Icon(Icons.gps_fixed,
                          color: Color(0xFF14BF9B)),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
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
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                    ),
                    items: tiposMascotas
                        .map((tipo) =>
                            DropdownMenuItem(value: tipo, child: Text(tipo)))
                        .toList(),
                    onChanged: (v) => setState(() => tipoMascota = v!),
                  ),
                  const SizedBox(height: 20),

                  CheckboxListTile(
                    value: experiencia,
                    onChanged: (v) => setState(() => experiencia = v ?? false),
                    title: const Text(
                      'Tengo experiencia cuidando mascotas',
                      style: TextStyle(fontSize: 17),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF18C59B),
                  ),
                  CheckboxListTile(
                    value: patio,
                    onChanged: (v) => setState(() => patio = v ?? false),
                    title: const Text(
                      'Mi casa tiene patio o jardín',
                      style: TextStyle(fontSize: 17),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF18C59B),
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Campo de comentarios con botón ✓ en el teclado
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
                          borderRadius: BorderRadius.circular(10)),
                      hintText:
                          'Cuéntanos más sobre tu hogar y disponibilidad...',
                      fillColor: Colors.grey[50],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🔹 Botones del mismo tamaño y “Enviar” en lugar de “Enviar solicitud”
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.close, color: Color(0xFF118A74)),
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
                            onPressed: controller.cargando.value ? null : enviar,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: controller.cargando.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
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
