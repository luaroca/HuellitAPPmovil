import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotaService {
  static final _ref = FirebaseFirestore.instance.collection('mascotas');

  static Future<void> crearMascota(MascotaModel mascota) async {
    await _ref.doc(mascota.id).set(mascota.toMap());
  }

  static Future<void> actualizarMascota(MascotaModel mascota) async {
    await _ref.doc(mascota.id).update(mascota.toMap());
  }

  static Future<void> eliminarMascota(String id) async {
    await _ref.doc(id).delete();
  }

  static Stream<List<MascotaModel>> obtenerMascotas() {
    return _ref.snapshots().map(
      (snap) => snap.docs
          .map((d) => MascotaModel.fromMap(d.id, d.data()))
          .toList(),
    );
  }

  static Future<MascotaModel?> obtenerPorId(String id) async {
    final doc = await _ref.doc(id).get();
    if (!doc.exists) return null;

    return MascotaModel.fromMap(doc.id, doc.data()!);
  }
}
