import 'dart:io';
import 'package:get/get.dart';
import 'package:huellitas/servicios/report_animal_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:huellitas/modelos/report_animal_model.dart';

class ReportAnimalController extends GetxController {
  final direccion = ''.obs;
  final descripcion = ''.obs;
  final condicion = ''.obs;
  final lat = RxnDouble();
  final lng = RxnDouble();

  final imageFile = Rxn<File>();

  final _service = ReportAnimalService();

  final picker = ImagePicker();

  // Para seleccionar imagen desde galería
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> submitReport() async {
    if (direccion.value.isEmpty ||
        descripcion.value.isEmpty ||
        condicion.value.isEmpty ||
        imageFile.value == null) {
      throw 'Complete todos los campos y seleccione una imagen';
    }

    // Subir imagen y obtener URL
    String imageUrl = await _service.uploadImage(imageFile.value!);

    // Crear el modelo con datos completos
    ReportAnimal report = ReportAnimal(
      direccion: direccion.value,
      descripcion: descripcion.value,
      condicion: condicion.value,
      lat: lat.value,
      lng: lng.value,
      imageUrl: imageUrl,
    );

    // Guardar en Firestore
    await _service.saveReport(report);
  }
}
