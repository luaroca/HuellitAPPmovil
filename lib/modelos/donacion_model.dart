enum EstadoDonacion { pendiente, confirmado, recogido, entregado }

EstadoDonacion estadoFromString(String value) {
  switch (value) {
    case "confirmado":
      return EstadoDonacion.confirmado;
    case "recogido":
      return EstadoDonacion.recogido;
    case "entregado":
      return EstadoDonacion.entregado;
    default:
      return EstadoDonacion.pendiente;
  }
}

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
  EstadoDonacion estado;

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
    this.estado = EstadoDonacion.pendiente,
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
    'estado': estado.name,
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
    estado: estadoFromString(map['estado'] ?? 'pendiente'),
  );
}
