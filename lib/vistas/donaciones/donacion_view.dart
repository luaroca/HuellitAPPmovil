import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:huellitas/modelos/donacion_model.dart';
import 'package:huellitas/servicios/donacion_service.dart';
import 'donacion_form_widget.dart';

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

    final pos =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ubicación capturada: $direccionBonita')),
      );
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
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.only(bottom: 12, left: 20, right: 20),
            child: Center(
              child: Text(
                ' Tu donación ayuda a cuidar a los peluditos rescatados ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      body: DonacionFormWidget(
        formKey: _formKey,
        nombreCtrl: nombreCtrl,
        telefonoCtrl: telefonoCtrl,
        itemsCtrl: itemsCtrl,
        direccionCtrl: direccionCtrl,
        notasCtrl: notasCtrl,
        usarUbicacion: usarUbicacion,
        enviarDonacion: enviarDonacion,
      ),
    );
  }
}
