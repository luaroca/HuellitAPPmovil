import 'dart:io';
import 'package:flutter/material.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotaFormUI extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final MascotaModel? mascota;

  final TextEditingController nombreCtrl;
  final TextEditingController descripcionCtrl;

  final String tipo;
  final String genero;
  final String tamanio;

  final bool vacunado;
  final bool esterilizado;
  final bool disponible;

  final File? imageFile;
  final bool subiendoImagen;

  final VoidCallback onSelectImage;
  final void Function(String) onChangeTipo;
  final void Function(String) onChangeGenero;
  final void Function(String) onChangeTamanio;
  final void Function(bool) onChangeVacunado;
  final void Function(bool) onChangeEsterilizado;
  final void Function(bool) onChangeDisponible;

  final VoidCallback onGuardar;

  const MascotaFormUI({
    Key? key,
    required this.formKey,
    required this.mascota,

    required this.nombreCtrl,
    required this.descripcionCtrl,

    required this.tipo,
    required this.genero,
    required this.tamanio,
    required this.vacunado,
    required this.esterilizado,
    required this.disponible,

    required this.imageFile,
    required this.subiendoImagen,

    required this.onSelectImage,
    required this.onChangeTipo,
    required this.onChangeGenero,
    required this.onChangeTamanio,
    required this.onChangeVacunado,
    required this.onChangeEsterilizado,
    required this.onChangeDisponible,

    required this.onGuardar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        elevation: 3,
        centerTitle: true,
        title: Text(
          mascota == null ? "Agregar Nueva Mascota" : "Editar Mascota",
          style: const TextStyle(
            fontFamily: "Roboto",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------
              //       FOTO
              // --------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4DB6AC), width: 1.5),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: subiendoImagen ? null : onSelectImage,
                      child: imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                imageFile!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : mascota?.fotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    mascota!.fotoUrl!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  children: const [
                                    Icon(Icons.add_photo_alternate_rounded,
                                        color: Color(0xFF4DB6AC), size: 50),
                                    SizedBox(height: 10),
                                    Text(
                                      'Subir foto (opcional)\nJPG, PNG o GIF (máx. 5MB)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                    ),

                    if (subiendoImagen)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          color: Color(0xFF4DB6AC),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------
              //  INFORMACIÓN DE LA MASCOTA
              // --------------------------
              _title("Información de la mascota"),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nombreCtrl,
                      decoration: _input("Nombre *", "Ej: Luna"),
                      validator: (v) =>
                          v!.trim().isEmpty ? "Obligatorio" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tipo,
                      decoration: _input("Tipo *", null),
                      items: const [
                        DropdownMenuItem(value: "Perro", child: Text("Perro")),
                        DropdownMenuItem(value: "Gato", child: Text("Gato")),
                        DropdownMenuItem(value: "Otro", child: Text("Otro")),
                      ],
                      onChanged: (v) => onChangeTipo(v!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: genero,
                      decoration: _input("Género *", null),
                      items: const [
                        DropdownMenuItem(value: "Macho", child: Text("Macho")),
                        DropdownMenuItem(value: "Hembra", child: Text("Hembra")),
                      ],
                      onChanged: (v) => onChangeGenero(v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tamanio,
                      decoration: _input("Tamaño *", null),
                      items: const [
                        DropdownMenuItem(value: "Pequeño", child: Text("Pequeño")),
                        DropdownMenuItem(value: "Mediano", child: Text("Mediano")),
                        DropdownMenuItem(value: "Grande", child: Text("Grande")),
                      ],
                      onChanged: (v) => onChangeTamanio(v!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descripcionCtrl,
                maxLines: 4,
                decoration: _input(
                    "Descripción", "Temperamento, características..."),
              ),

              const SizedBox(height: 25),

              // --------------------------
              //    ESTADO DE SALUD
              // --------------------------
              _title("Estado de salud"),

              CheckboxListTile(
                value: vacunado,
                title: const Text("Vacunado"),
                activeColor: const Color(0xFF4DB6AC),
                onChanged: (v) => onChangeVacunado(v!),
              ),

              CheckboxListTile(
                value: esterilizado,
                title: const Text("Esterilizado"),
                activeColor: const Color(0xFF4DB6AC),
                onChanged: (v) => onChangeEsterilizado(v!),
              ),

              CheckboxListTile(
                value: disponible,
                title: const Text("Disponible para adopción"),
                activeColor: const Color(0xFF4DB6AC),
                onChanged: (v) => onChangeDisponible(v!),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(
                            color: Color(0xFF4DB6AC), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Color(0xFF4DB6AC),
                            fontFamily: "Roboto",
                            fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB6AC),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onGuardar,
                      child: const Text(
                        "Guardar Mascota",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------
  //      WIDGET AUXILIARES
  // --------------------------
  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontFamily: "Roboto",
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  InputDecoration _input(String label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
