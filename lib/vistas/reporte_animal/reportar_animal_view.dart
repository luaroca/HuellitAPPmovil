import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'reportar_animal_widget.dart';
import 'package:huellitas/controllers/reporte_animal_controller.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';

class ReportarAnimalView extends StatefulWidget {
  const ReportarAnimalView({Key? key}) : super(key: key);

  @override
  State<ReportarAnimalView> createState() => _ReportarAnimalViewState();
}

class _ReportarAnimalViewState extends State<ReportarAnimalView> {
  final _formKey = GlobalKey<FormState>();

  final direccionCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final condicionCtrl = TextEditingController();

  double? lat;
  double? lng;

  final ReporteAnimalController reporteController = Get.find();

  @override
  void dispose() {
    direccionCtrl.dispose();
    descripcionCtrl.dispose();
    condicionCtrl.dispose();
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
        if (place.locality != null && place.locality!.isNotEmpty)
          place.locality!,
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          place.administrativeArea!,
      ].join(', ');

      setState(() {
        direccionCtrl.text = direccionBonita.isNotEmpty
            ? direccionBonita
            : '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });
    } catch (e) {
      setState(() {
        direccionCtrl.text =
            '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ubicación obtenida mediante coordenadas.')),
      );
    }
  }

  Future<void> enviarReporte() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para reportar.')),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final dataUser = userDoc.data() ?? {};

    final reporte = ReporteAnimalModel(
      id: const Uuid().v4(),
      uid: user.uid,
      nombreUsuario: dataUser['nombres'] ?? '',
      correoUsuario: dataUser['email'] ?? user.email ?? '',
      telefonoUsuario: dataUser['telefono'] ?? '',
      direccion: direccionCtrl.text.trim(),
      descripcion: descripcionCtrl.text.trim(),
      condicion: condicionCtrl.text.trim(),
      lat: lat,
      lng: lng,
      fotoUrl: null, // por ahora no hay storage
      estado: 'pendiente',
    );

    await reporteController.crearReporte(reporte);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reporte enviado'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ReportarAnimalWidget(
      formKey: _formKey,
      direccionCtrl: direccionCtrl,
      descripcionCtrl: descripcionCtrl,
      condicionCtrl: condicionCtrl,
      usarUbicacion: usarUbicacion,
      enviarReporte: enviarReporte,
    );
  }
}
