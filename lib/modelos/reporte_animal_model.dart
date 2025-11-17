import 'package:cloud_firestore/cloud_firestore.dart';

class ReporteAnimalModel {
  String id;
  String uid; // usuario que reporta
  String nombreUsuario;
  String correoUsuario;
  String telefonoUsuario;
  String direccion;
  String descripcion;
  String condicion;
  double? lat;
  double? lng;
  String? fotoUrl; // opcional, por ahora null
  String estado; // p.ej. "pendiente"
  Timestamp fechaCreacion;

  ReporteAnimalModel({
    required this.id,
    required this.uid,
    required this.nombreUsuario,
    required this.correoUsuario,
    required this.telefonoUsuario,
    required this.direccion,
    required this.descripcion,
    required this.condicion,
    this.lat,
    this.lng,
    this.fotoUrl,
    this.estado = 'pendiente',
    Timestamp? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'nombreUsuario': nombreUsuario,
      'correoUsuario': correoUsuario,
      'telefonoUsuario': telefonoUsuario,
      'direccion': direccion,
      'descripcion': descripcion,
      'condicion': condicion,
      'lat': lat,
      'lng': lng,
      'fotoUrl': fotoUrl,
      'estado': estado,
      'fechaCreacion': fechaCreacion,
    };
  }

  factory ReporteAnimalModel.fromMap(Map<String, dynamic> map) {
    return ReporteAnimalModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      nombreUsuario: map['nombreUsuario'] ?? '',
      correoUsuario: map['correoUsuario'] ?? '',
      telefonoUsuario: map['telefonoUsuario'] ?? '',
      direccion: map['direccion'] ?? '',
      descripcion: map['descripcion'] ?? '',
      condicion: map['condicion'] ?? '',
      lat: map['lat'] != null ? (map['lat'] as num).toDouble() : null,
      lng: map['lng'] != null ? (map['lng'] as num).toDouble() : null,
      fotoUrl: map['fotoUrl'],
      estado: map['estado'] ?? 'pendiente',
      fechaCreacion: map['fechaCreacion'] ?? Timestamp.now(),
    );
  }
}
