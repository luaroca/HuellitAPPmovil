class ReportAnimal {
  String direccion;
  String descripcion;
  String condicion;
  double? lat;
  double? lng;
  String imageUrl;

  ReportAnimal({
    required this.direccion,
    required this.descripcion,
    required this.condicion,
    this.lat,
    this.lng,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'direccion': direccion,
      'descripcion': descripcion,
      'condicion': condicion,
      'lat': lat,
      'lng': lng,
      'imageUrl': imageUrl,
    };
  }
}
