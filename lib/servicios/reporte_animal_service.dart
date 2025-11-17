import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';

class ReporteAnimalService {
  static final _ref =
      FirebaseFirestore.instance.collection('reportes_animales');

  static Future<void> crearReporte(ReporteAnimalModel reporte) async {
    await _ref.doc(reporte.id).set(reporte.toMap());
  }

  static Future<void> actualizarReporte(ReporteAnimalModel reporte) async {
    await _ref.doc(reporte.id).update(reporte.toMap());
  }

  static Future<void> eliminarReporte(String id) async {
    await _ref.doc(id).delete();
  }

  static Stream<List<ReporteAnimalModel>> obtenerReportes() {
    return _ref
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ReporteAnimalModel.fromMap(d.data()))
            .toList());
  }

  static Future<ReporteAnimalModel?> obtenerPorId(String id) async {
    final doc = await _ref.doc(id).get();
    if (!doc.exists) return null;
    return ReporteAnimalModel.fromMap(doc.data()!);
  }
}
