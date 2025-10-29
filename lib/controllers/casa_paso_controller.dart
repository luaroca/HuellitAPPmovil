import 'package:get/get.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/servicios/casa_paso_service.dart';


class CasaPasoController extends GetxController {
  var cargando = false.obs;

  Future<void> registrarCasa(CasaPasoModel model) async {
    cargando.value = true;
    await CasaPasoService.registrar(model);
    cargando.value = false;
  }
}
