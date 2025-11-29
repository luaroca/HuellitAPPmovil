import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/controllers/casa_paso_controller.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'casa_paso_form_widget.dart';

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
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        nombreCtrl.text = (data['nombres'] ?? '').toString();
        telefonoCtrl.text = (data['telefono'] ?? '').toString();
      }
      setState(() {});
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
      desiredAccuracy: LocationAccuracy.high,
    );

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

      setState(
        () => direccionCtrl.text = direccionBonita.isNotEmpty
            ? direccionBonita
            : '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}',
      );
    } catch (e) {
      setState(() {
        direccionCtrl.text =
            '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo obtener la dirección, usando coordenadas.',
          ),
        ),
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

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CasaPasoFormWidget(
      formKey: _formKey,
      nombreCtrl: nombreCtrl,
      telefonoCtrl: telefonoCtrl,
      direccionCtrl: direccionCtrl,
      capacidadCtrl: capacidadCtrl,
      comentariosCtrl: comentariosCtrl,
      tipoMascota: tipoMascota,
      experiencia: experiencia,
      patio: patio,
      tiposMascotas: tiposMascotas,
      cargando: controller.cargando,
      usarUbicacion: usarUbicacion,
      onTipoMascota: (v) => setState(() => tipoMascota = v),
      onExperiencia: (v) => setState(() => experiencia = v),
      onPatio: (v) => setState(() => patio = v),
      onEnviar: enviar,
    );
  }
}
