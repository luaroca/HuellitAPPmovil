import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotaFormView extends StatefulWidget {
  final MascotaModel? mascota;
  const MascotaFormView({Key? key, this.mascota}) : super(key: key);

  @override
  State<MascotaFormView> createState() => _MascotaFormViewState();
}

class _MascotaFormViewState extends State<MascotaFormView> {
  final _formKey = GlobalKey<FormState>();
  final MascotaController controller = Get.find();
  final nombreCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  String tipo = 'Perro';
  String genero = 'Macho';
  String tamanio = 'Mediano';
  bool vacunado = false;
  bool esterilizado = false;
  bool disponible = true;

  // Imagen para Cloudinary
  File? _imageFile;
  bool _subiendoImagen = false;

  final cloudinary = CloudinaryPublic(
    'dhwrxmehx',        // Tu cloud name
    'huellitas_preset', // Tu upload preset sin firma (unsigned)
    cache: false,
  );
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.mascota != null) {
      final m = widget.mascota!;
      nombreCtrl.text = m.nombre;
      tipo = m.tipo;
      genero = m.genero;
      tamanio = m.tamanio;
      descripcionCtrl.text = m.descripcion ?? '';
      vacunado = m.vacunado;
      esterilizado = m.esterilizado;
      disponible = m.disponible;
      // NO recuperamos foto directamente aquí, la mostramos solo si existe
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> seleccionarImagen() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<String?> _subirImagenACloudinary(File imageFile) async {
    try {
      setState(() {
        _subiendoImagen = true;
      });

      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'mascotas',
        ),
      );
      return res.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint('Cloudinary error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir imagen: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      setState(() {
        _subiendoImagen = false;
      });
    }
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.mascota != null;
      String? fotoUrl = isEdit ? widget.mascota?.fotoUrl : null;

      // Si seleccionaste imagen, súbela a Cloudinary antes de guardar
      if (_imageFile != null) {
        fotoUrl = await _subirImagenACloudinary(_imageFile!);
        if (fotoUrl == null) return; // Si falla la subida, no continue
      }

      final mascota = MascotaModel(
        id: isEdit ? widget.mascota!.id : Uuid().v4(),
        nombre: nombreCtrl.text.trim(),
        tipo: tipo,
        genero: genero,
        tamanio: tamanio,
        descripcion: descripcionCtrl.text.trim(),
        vacunado: vacunado,
        esterilizado: esterilizado,
        fotoUrl: fotoUrl,
        disponible: disponible,
        casaPasoId: isEdit ? widget.mascota?.casaPasoId : null,
        solicitudAdopcion: isEdit ? widget.mascota!.solicitudAdopcion : false,
        adoptada: isEdit ? widget.mascota!.adoptada : false,
        fechaIngresoCasa: isEdit ? widget.mascota?.fechaIngresoCasa : null,
        fechaSalidaCasa: isEdit ? widget.mascota?.fechaSalidaCasa : null,
        solicitudUid: isEdit ? widget.mascota?.solicitudUid : null,
        nombreUsuarioSolicitud: isEdit ? widget.mascota?.nombreUsuarioSolicitud : null,
        correoUsuarioSolicitud: isEdit ? widget.mascota?.correoUsuarioSolicitud : null,
        telefonoUsuarioSolicitud: isEdit ? widget.mascota?.telefonoUsuarioSolicitud : null,
      );

      if (!isEdit) {
        await controller.agregarMascota(mascota);
        Get.back();
        Get.snackbar('Mascota registrada', 'La mascota fue registrada correctamente');
      } else {
        await controller.actualizarMascota(mascota);
        Get.back();
        Get.snackbar('Mascota actualizada', 'La mascota fue actualizada');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        elevation: 3,
        centerTitle: true,
        title: Text(
          widget.mascota == null ? 'Agregar Nueva Mascota' : 'Editar Mascota',
          style: const TextStyle(fontFamily: "Roboto", fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO
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
                      onTap: _subiendoImagen ? null : seleccionarImagen,
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _imageFile!,
                                width: 150, height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : widget.mascota?.fotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    widget.mascota!.fotoUrl!,
                                    width: 150, height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  children: const [
                                    Icon(Icons.add_photo_alternate_rounded, color: Color(0xFF4DB6AC), size: 50),
                                    SizedBox(height: 10),
                                    Text(
                                      'Subir foto (opcional)\nJPG, PNG o GIF (máx. 5MB)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "Roboto", fontSize: 15, color: Colors.black54),
                                    ),
                                  ],
                                ),
                    ),
                    if (_subiendoImagen)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(minHeight: 4, color: Color(0xFF4DB6AC)),
                      ),
                    if (!_subiendoImagen && _imageFile != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Toca para cambiar foto", style: TextStyle(color: Colors.black54)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // EL RESTO ES IGUAL, NO CAMBIA...
              Text(
                "Información de la mascota",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nombreCtrl,
                      style: const TextStyle(fontSize: 18, fontFamily: "Roboto"),
                      decoration: _input("Nombre *", "Ej: Luna"),
                      validator: (v) => v!.trim().isEmpty ? 'Obligatorio' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tipo,
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black87),
                      items: const [
                        DropdownMenuItem(value: 'Perro', child: Text('🐶 Perro')),
                        DropdownMenuItem(value: 'Gato', child: Text('🐱 Gato')),
                        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                      ],
                      onChanged: (v) => setState(() => tipo = v!),
                      decoration: _input("Tipo *", null),
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
                      dropdownColor: Colors.white,
                      decoration: _input("Género *", null),
                      style: const TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black87),
                      items: const [
                        DropdownMenuItem(value: 'Macho', child: Text('♂ Macho')),
                        DropdownMenuItem(value: 'Hembra', child: Text('♀ Hembra')),
                      ],
                      onChanged: (v) => setState(() => genero = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tamanio,
                      dropdownColor: Colors.white,
                      decoration: _input("Tamaño *", null),
                      style: const TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.black87),
                      items: const [
                        DropdownMenuItem(value: 'Pequeño', child: Text('Pequeño')),
                        DropdownMenuItem(value: 'Mediano', child: Text('Mediano')),
                        DropdownMenuItem(value: 'Grande', child: Text('Grande')),
                      ],
                      onChanged: (v) => setState(() => tamanio = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descripcionCtrl,
                style: const TextStyle(fontSize: 18, fontFamily: "Roboto"),
                maxLines: 4,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: _input("Descripción", "Temperamento, características..."),
              ),
              const SizedBox(height: 25),
              Text(
                "Estado de salud",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  CheckboxListTile(
                    value: vacunado,
                    title: const Text("Vacunado", style: TextStyle(fontSize: 18, fontFamily: "Roboto")),
                    onChanged: (v) => setState(() => vacunado = v!),
                    activeColor: const Color(0xFF4DB6AC),
                  ),
                  CheckboxListTile(
                    value: esterilizado,
                    title: const Text("Esterilizado", style: TextStyle(fontSize: 18, fontFamily: "Roboto")),
                    onChanged: (v) => setState(() => esterilizado = v!),
                    activeColor: const Color(0xFF4DB6AC),
                  ),
                  CheckboxListTile(
                    value: disponible,
                    title: const Text("Disponible para adopción", style: TextStyle(fontSize: 18, fontFamily: "Roboto")),
                    onChanged: (v) => setState(() => disponible = v!),
                    activeColor: const Color(0xFF4DB6AC),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: _botonSecundario(),
                      child: const Text("Cancelar", style: TextStyle(fontSize: 18, fontFamily: "Roboto")),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _subiendoImagen ? null : _guardar,
                      style: _botonPrincipal(),
                      child: const Text("Guardar Mascota", style: TextStyle(fontSize: 18, fontFamily: "Roboto", color: Colors.white)),
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

  InputDecoration _input(String label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontSize: 17, fontFamily: "Roboto"),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  ButtonStyle _botonPrincipal() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4DB6AC),
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  ButtonStyle _botonSecundario() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF4DB6AC),
      side: const BorderSide(color: Color(0xFF4DB6AC), width: 2),
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
