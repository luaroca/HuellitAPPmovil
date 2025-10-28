class DonacionModel {
  String id;
  String nombre;
  String telefono;
  String items;
  String direccion;
  double? lat;
  double? lng;
  String notas;
  DateTime fecha;

  DonacionModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.items,
    required this.direccion,
    this.lat,
    this.lng,
    required this.notas,
    required this.fecha,
  });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'telefono': telefono,
    'items': items,
    'direccion': direccion,
    'lat': lat,
    'lng': lng,
    'notas': notas,
    'fecha': fecha.toIso8601String(),
  };

  factory DonacionModel.fromMap(Map<String, dynamic> map, String id) => DonacionModel(
    id: id,
    nombre: map['nombre'] ?? '',
    telefono: map['telefono'] ?? '',
    items: map['items'] ?? '',
    direccion: map['direccion'] ?? '',
    lat: map['lat'],
    lng: map['lng'],
    notas: map['notas'] ?? '',
    fecha: DateTime.parse(map['fecha']),
  );
}
