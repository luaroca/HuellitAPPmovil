import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado.')));
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
        SnackBar(content: Text('No se pudo obtener la dirección, usando coordenadas.')),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'Donar Alimentos o Insumos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(22),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tu donación ayuda a cuidar a los peluditos rescatados',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 15, 14, 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nombre Completo *", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: nombreCtrl,
                        validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Teléfono de Contacto*", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: telefonoCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "+57 300 123 4567",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("¿Qué deseas donar? *", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: itemsCtrl,
                        validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Ej: Alimento para perros, Mantas, Medicamentos...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dirección para Recogida *", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: direccionCtrl,
                        validator: (v) => v!.isEmpty ? 'Completa este campo' : null,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Dirección completa",
                          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.green),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green[700],
                            side: BorderSide(color: Colors.green[300]!),
                          ),
                          icon: Icon(Icons.gps_fixed),
                          label: Text('Usar mi ubicación GPS'),
                          onPressed: usarUbicacion,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Notas Adicionales", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: notasCtrl,
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Horarios disponibles, instrucciones especiales...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        backgroundColor: Colors.grey[100],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text('Cancelar'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: enviarDonacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Enviar Donación',
                        style: TextStyle(
                          color: const Color.fromARGB(233, 39, 15, 15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
