import 'package:get/get.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:huellitas/servicios/voluntario_service.dart';


class VoluntarioController extends GetxController {
  var cargando = false.obs;

  Future<void> registrarVoluntario(VoluntarioModel modelo) async {
    cargando.value = true;
    await VoluntarioService.registrar(modelo);
    cargando.value = false;
  }
}
