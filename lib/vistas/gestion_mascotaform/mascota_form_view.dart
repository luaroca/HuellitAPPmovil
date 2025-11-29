import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/vistas/gestion_mascotaform/widget_mascota_admin_form.dart';
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

  File? _imageFile;
  bool _subiendoImagen = false;

  final ImagePicker _picker = ImagePicker();

  final cloudinary = CloudinaryPublic(
    'dhwrxmehx',
    'huellitas_preset',
    cache: false,
  );

  @override
  void initState() {
    super.initState();

    if (widget.mascota != null) {
      final m = widget.mascota!;
      nombreCtrl.text = m.nombre;
      descripcionCtrl.text = m.descripcion ?? '';

      tipo = m.tipo;
      genero = m.genero;
      tamanio = m.tamanio;
      vacunado = m.vacunado;
      esterilizado = m.esterilizado;
      disponible = m.disponible;
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  // --------------------------
  //     SELECCIONAR IMAGEN
  // --------------------------
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

  // --------------------------
  //     SUBIR A CLOUDINARY
  // --------------------------
  Future<String?> subirImagen(File image) async {
    try {
      setState(() => _subiendoImagen = true);

      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "mascotas",
        ),
      );

      return res.secureUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al subir imagen")),
      );
      return null;
    } finally {
      setState(() => _subiendoImagen = false);
    }
  }

  // --------------------------
  //           GUARDAR
  // --------------------------
  Future<void> guardar() async {
    if (_formKey.currentState!.validate()) {
      final edit = widget.mascota != null;
      String? fotoUrl = edit ? widget.mascota!.fotoUrl : null;

      if (_imageFile != null) {
        final url = await subirImagen(_imageFile!);
        if (url == null) return;
        fotoUrl = url;
      }

      final mascota = MascotaModel(
        id: edit ? widget.mascota!.id : Uuid().v4(),
        nombre: nombreCtrl.text.trim(),
        tipo: tipo,
        genero: genero,
        tamanio: tamanio,
        descripcion: descripcionCtrl.text.trim(),
        vacunado: vacunado,
        esterilizado: esterilizado,
        disponible: disponible,
        fotoUrl: fotoUrl,

        casaPasoId: edit ? widget.mascota!.casaPasoId : null,
        solicitudAdopcion: edit ? widget.mascota!.solicitudAdopcion : false,
        adoptada: edit ? widget.mascota!.adoptada : false,
        fechaIngresoCasa: edit ? widget.mascota!.fechaIngresoCasa : null,
        fechaSalidaCasa: edit ? widget.mascota!.fechaSalidaCasa : null,
        solicitudUid: edit ? widget.mascota!.solicitudUid : null,
        nombreUsuarioSolicitud: edit ? widget.mascota!.nombreUsuarioSolicitud : null,
        correoUsuarioSolicitud: edit ? widget.mascota!.correoUsuarioSolicitud : null,
        telefonoUsuarioSolicitud: edit ? widget.mascota!.telefonoUsuarioSolicitud : null,
      );

      if (!edit) {
        await controller.agregarMascota(mascota);
        Get.back();
        Get.snackbar("Registro", "Mascota registrada");
      } else {
        await controller.actualizarMascota(mascota);
        Get.back();
        Get.snackbar("Actualización", "Mascota actualizada");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MascotaFormUI(
      formKey: _formKey,
      mascota: widget.mascota,

      // Controladores
      nombreCtrl: nombreCtrl,
      descripcionCtrl: descripcionCtrl,

      // Variables
      tipo: tipo,
      genero: genero,
      tamanio: tamanio,
      vacunado: vacunado,
      esterilizado: esterilizado,
      disponible: disponible,

      // Imagen
      imageFile: _imageFile,
      subiendoImagen: _subiendoImagen,

      // Callbacks
      onSelectImage: seleccionarImagen,
      onChangeTipo: (v) => setState(() => tipo = v),
      onChangeGenero: (v) => setState(() => genero = v),
      onChangeTamanio: (v) => setState(() => tamanio = v),
      onChangeVacunado: (v) => setState(() => vacunado = v),
      onChangeEsterilizado: (v) => setState(() => esterilizado = v),
      onChangeDisponible: (v) => setState(() => disponible = v),

      onGuardar: guardar,
    );
  }
}
