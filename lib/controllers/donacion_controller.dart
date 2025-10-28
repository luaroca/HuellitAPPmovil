import 'package:get/get.dart';
import 'package:huellitas/modelos/donacion_model.dart';
import 'package:huellitas/servicios/donacion_service.dart';

class DonacionController extends GetxController {
  var donaciones = <DonacionModel>[].obs;
  var filtro = 'todos'.obs;

  @override
  void onInit() {
    super.onInit();
    DonacionService.streamDonaciones().listen((lista) {
      donaciones.value = lista;
    });
  }

  void cambiarFiltro(String valor) {
    filtro.value = valor;
  }

  Future<void> actualizarEstado(DonacionModel model, EstadoDonacion nuevo) async {
    await DonacionService.actualizarEstado(model.id, nuevo);
  }

  List<DonacionModel> get donacionesFiltradas {
    if (filtro.value == 'todos') return donaciones;
    return donaciones.where((d) => d.estado.name == filtro.value).toList();
  }

  int contarPorEstado(EstadoDonacion estado) {
    return donaciones.where((d) => d.estado == estado).length;
  }
}
