import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/donacion_model.dart';


class DonacionService {
  static final _ref = FirebaseFirestore.instance.collection('donaciones');

  static Future<void> crearDonacion(DonacionModel don) async {
    await _ref.add(don.toMap());
  }

  static Stream<List<DonacionModel>> streamDonaciones() {
    return _ref.snapshots().map((qs) =>
      qs.docs.map((d) => DonacionModel.fromMap(d.data(), d.id)).toList()
    );
  }

  static Future<void> actualizarEstado(String id, EstadoDonacion nuevoEstado) async {
    await _ref.doc(id).update({'estado': nuevoEstado.name});
  }
}
