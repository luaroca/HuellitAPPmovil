class MascotaModel {
  String id;
  String nombre;
  String tipo;
  String genero;
  String tamanio;
  String? descripcion;
  bool vacunado;
  bool esterilizado;
  String? fotoUrl;
  bool disponible;
  String? casaPasoId;

  MascotaModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.genero,
    required this.tamanio,
    this.descripcion,
    this.fotoUrl,
    required this.vacunado,
    required this.esterilizado,
    required this.disponible,
    this.casaPasoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'genero': genero,
      'tamanio': tamanio,
      'descripcion': descripcion,
      'vacunado': vacunado,
      'esterilizado': esterilizado,
      'fotoUrl': fotoUrl,
      'disponible': disponible,
      'casaPasoId': casaPasoId,
    };
  }

  /// 🔥 PARA USO GENERAL
  factory MascotaModel.fromMap(String id, Map<String, dynamic> map) {
    return MascotaModel(
      id: id,
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? '',
      genero: map['genero'] ?? '',
      tamanio: map['tamanio'] ?? '',
      descripcion: map['descripcion'],
      vacunado: map['vacunado'] ?? false,
      esterilizado: map['esterilizado'] ?? false,
      fotoUrl: map['fotoUrl'],
      disponible: map['disponible'] ?? true,
      casaPasoId: map['casaPasoId'],
    );
  }

  /// 🔥 PARA CONSULTAS DIRECTAS DE FIRESTORE
  factory MascotaModel.fromFirestore(String id, Map<String, dynamic> map) {
    return MascotaModel.fromMap(id, map);
  }
}
