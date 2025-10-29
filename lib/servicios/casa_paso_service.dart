import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';


class CasaPasoService {
  static final ref = FirebaseFirestore.instance.collection('casas_paso');

  static Future<void> registrar(CasaPasoModel model) async {
    await ref.add(model.toMap());
  }

  static Future<CasaPasoModel?> obtenerPorUserId(String userId) async {
    final res = await ref.where('userId', isEqualTo: userId).limit(1).get();
    if (res.docs.isEmpty) return null;
    final doc = res.docs.first;
    return CasaPasoModel.fromMap(doc.id, doc.data());
  }

  static Future<void> eliminarPorId(String id) async {
    await ref.doc(id).delete();
  }
}
