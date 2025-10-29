import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/voluntario_model.dart';


class VoluntarioService {
  static Future<void> registrar(VoluntarioModel modelo) async {
    await FirebaseFirestore.instance.collection('voluntarios').add(modelo.toMap());
  }

  static Future<VoluntarioModel?> obtenerPorCorreo(String correo) async {
  final snap = await FirebaseFirestore.instance
      .collection('voluntarios')
      .where('correo', isEqualTo: correo)
      .limit(1)
      .get();
  if (snap.docs.isEmpty) return null;
  final doc = snap.docs.first;
  return VoluntarioModel.fromMap(doc.id, doc.data());
}

static Future<void> eliminarPorId(String id) async {
  await FirebaseFirestore.instance.collection('voluntarios').doc(id).delete();
}

}
