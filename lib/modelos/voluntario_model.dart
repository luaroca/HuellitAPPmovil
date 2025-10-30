class VoluntarioModel {
  String id;
  String nombre;
  String correo;
  String telefono;
  List<String> dias;
  String horario; 
  List<String> intereses;

  VoluntarioModel({
    this.id = '',
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.dias,
    required this.horario,
    required this.intereses,
  });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'correo': correo,
    'telefono': telefono,
    'dias': dias,
    'horario': horario,
    'intereses': intereses,
  };

  factory VoluntarioModel.fromMap(String id, Map<String, dynamic> map) => VoluntarioModel(
    id: id,
    nombre: map['nombre'] ?? '',
    correo: map['correo'] ?? '',
    telefono: map['telefono'] ?? '',
    dias: List<String>.from(map['dias'] ?? []),
    horario: map['horario'] ?? '',
    intereses: List<String>.from(map['intereses'] ?? []),
  );
}
