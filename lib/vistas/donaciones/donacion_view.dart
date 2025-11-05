import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/donacion_model.dart';
import 'package:huellitas/servicios/donacion_service.dart';

class DonacionView extends StatefulWidget {
  const DonacionView({Key? key}) : super(key: key);

  @override
  State<DonacionView> createState() => _DonacionViewState();
}

class _DonacionViewState extends State<DonacionView> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final itemsCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final notasCtrl = TextEditingController();

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
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        nombreCtrl.text = (data['nombres'] ?? '').toString();
        telefonoCtrl.text = (data['telefono'] ?? '').toString();
        setState(() {}); // Refresca la vista al cargar los datos
      }
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    itemsCtrl.dispose();
    direccionCtrl.dispose();
    notasCtrl.dispose();
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
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = pos.latitude;
    lng = pos.longitude;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
      final place = placemarks.first;
      String direccionBonita = [
        if (place.street != null && place.street!.isNotEmpty) place.street!,
        if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality!,
        if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea!,
        if (place.country != null && place.country!.isNotEmpty) place.country!,
      ].join(', ');

      setState(() {
        direccionCtrl.text = direccionBonita.isNotEmpty
            ? direccionBonita
            : '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ubicación capturada: $direccionBonita')),
      );
    } catch (e) {
      setState(() {
        direccionCtrl.text = '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la dirección, usando coordenadas.')),
      );
    }
  }

  Future<void> enviarDonacion() async {
    if (!_formKey.currentState!.validate()) return;
    final modelo = DonacionModel(
      id: '',
      nombre: nombreCtrl.text.trim(),
      telefono: telefonoCtrl.text.trim(),
      items: itemsCtrl.text.trim(),
      direccion: direccionCtrl.text.trim(),
      lat: lat,
      lng: lng,
      notas: notasCtrl.text.trim(),
      fecha: DateTime.now(),
      estado: EstadoDonacion.pendiente,
    );
    await DonacionService.crearDonacion(modelo);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Donación registrada correctamente!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAE35),
        elevation: 4,
        title: const Text(
          'Donar Alimentos o Insumos',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Tu donación ayuda a cuidar a los peluditos rescatados 🐾',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard([
                _buildLabel('Nombre Completo *'),
                _buildTextField(nombreCtrl, 'Ingresa tu nombre completo'),
                const SizedBox(height: 16),
                _buildLabel('Teléfono de Contacto *'),
                _buildTextField(telefonoCtrl, '+57 300 123 4567', tipo: TextInputType.phone),
              ]),
              _buildCard([
                _buildLabel('¿Qué deseas donar? *'),
                _buildTextField(itemsCtrl, 'Ej: Alimento para perros, mantas, medicamentos...'),
              ]),
              _buildCard([
                _buildLabel('Dirección para Recogida *'),
                TextFormField(
                  controller: direccionCtrl,
                  validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                  decoration: _inputDecoration(
                    'Dirección completa',
                    icono: const Icon(Icons.location_on_outlined, color: Color(0xFF0D7864)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                _buildTextField(notasCtrl, 'Horarios disponibles, instrucciones especiales...', maxLines: 3),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }

  // ---------- COMPONENTES VISUALES ---------- //

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

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType tipo = TextInputType.text,
    int maxLines = 1,
  }) {
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
}
