import 'package:cloud_firestore/cloud_firestore.dart';

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
  Timestamp? fechaIngresoCasa;
  Timestamp? fechaSalidaCasa;
  // ADOPCIÓN/SOLICITANTE
  bool solicitudAdopcion;
  bool adoptada;
  String? solicitudUid;
  String? nombreUsuarioSolicitud;
  String? correoUsuarioSolicitud;
  String? telefonoUsuarioSolicitud;

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
    this.fechaIngresoCasa,
    this.fechaSalidaCasa,
    this.solicitudAdopcion = false,
    this.adoptada = false,
    this.solicitudUid,
    this.nombreUsuarioSolicitud,
    this.correoUsuarioSolicitud,
    this.telefonoUsuarioSolicitud,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'fechaIngresoCasa': fechaIngresoCasa,
      'fechaSalidaCasa': fechaSalidaCasa,
      'solicitudAdopcion': solicitudAdopcion,
      'adoptada': adoptada,
      'solicitudUid': solicitudUid,
      'nombreUsuarioSolicitud': nombreUsuarioSolicitud,
      'correoUsuarioSolicitud': correoUsuarioSolicitud,
      'telefonoUsuarioSolicitud': telefonoUsuarioSolicitud,
    };
  }

  factory MascotaModel.fromMap(Map<String, dynamic> map) {
    return MascotaModel(
      id: map['id'] ?? '',
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
      fechaIngresoCasa: map['fechaIngresoCasa'],
      fechaSalidaCasa: map['fechaSalidaCasa'],
      solicitudAdopcion: map['solicitudAdopcion'] ?? false,
      adoptada: map['adoptada'] ?? false,
      solicitudUid: map['solicitudUid'],
      nombreUsuarioSolicitud: map['nombreUsuarioSolicitud'],
      correoUsuarioSolicitud: map['correoUsuarioSolicitud'],
      telefonoUsuarioSolicitud: map['telefonoUsuarioSolicitud'],
    );
  }
}
