import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/donacion_model.dart';

class DonacionService {
  static Future<void> crearDonacion(DonacionModel donacion) async {
    await FirebaseFirestore.instance.collection('donaciones').add(donacion.toMap());
  }
}
