class EventoModel {
  String id;
  String titulo;
  String tipo;
  String descripcion;
  String fecha;
  String horario;
  String ubicacion;
  bool publico;

  EventoModel({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    required this.horario,
    required this.ubicacion,
    required this.publico,
  });

  factory EventoModel.fromMap(Map<String,dynamic> map, String id) => EventoModel(
    id: id,
    titulo: map['titulo'] ?? '',
    tipo: map['tipo'] ?? '',
    descripcion: map['descripcion'] ?? '',
    fecha: map['fecha'] ?? '',
    horario: map['horario'] ?? '',
    ubicacion: map['ubicacion'] ?? '',
    publico: map['publico'] ?? false,
  );

  Map<String,dynamic> toMap() => {
    'titulo': titulo,
    'tipo': tipo,
    'descripcion': descripcion,
    'fecha': fecha,
    'horario': horario,
    'ubicacion': ubicacion,
    'publico': publico,
  };
}
