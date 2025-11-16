import 'package:get/get.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:huellitas/servicios/mascota_service.dart';


class MascotaController extends GetxController {
  RxList<MascotaModel> mascotas = <MascotaModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    MascotaService.obtenerMascotas().listen((pets) {
      mascotas.assignAll(pets);
    });
  }

  Future<void> agregarMascota(MascotaModel mascota) async {
    await MascotaService.crearMascota(mascota);
  }

  Future<void> actualizarMascota(MascotaModel mascota) async {
    await MascotaService.actualizarMascota(mascota);
  }

  Future<void> eliminarMascota(String id) async {
    await MascotaService.eliminarMascota(id);
  }
}
