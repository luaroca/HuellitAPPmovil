class CasaPasoModel {
  String id;
  String userId; 
  String nombre;
  String telefono;
  String direccion;
  int capacidad;
  String tipoMascotas;
  bool experiencia;
  bool tienePatio;
  String comentarios;

  CasaPasoModel({
    this.id = '',
    required this.userId,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.capacidad,
    required this.tipoMascotas,
    required this.experiencia,
    required this.tienePatio,
    required this.comentarios,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'nombre': nombre,
    'telefono': telefono,
    'direccion': direccion,
    'capacidad': capacidad,
    'tipoMascotas': tipoMascotas,
    'experiencia': experiencia,
    'tienePatio': tienePatio,
    'comentarios': comentarios,
  };

  factory CasaPasoModel.fromMap(String id, Map<String, dynamic> map) => CasaPasoModel(
    id: id,
    userId: map['userId'] ?? '',
    nombre: map['nombre'] ?? '',
    telefono: map['telefono'] ?? '',
    direccion: map['direccion'] ?? '',
    capacidad: map['capacidad'] ?? 0,
    tipoMascotas: map['tipoMascotas'] ?? '',
    experiencia: map['experiencia'] ?? false,
    tienePatio: map['tienePatio'] ?? false,
    comentarios: map['comentarios'] ?? '',
  );
}
