import 'package:get/get.dart';
import 'package:huellitas/modelos/reporte_animal_model.dart';
import 'package:huellitas/servicios/reporte_animal_service.dart';

class ReporteAnimalController extends GetxController {
  final reportes = <ReporteAnimalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    ReporteAnimalService.obtenerReportes().listen((lista) {
      reportes.value = lista;
    });
  }

  Future<void> crearReporte(ReporteAnimalModel reporte) async {
    await ReporteAnimalService.crearReporte(reporte);
  }

  Future<void> actualizarReporte(ReporteAnimalModel reporte) async {
    await ReporteAnimalService.actualizarReporte(reporte);
  }

  Future<void> eliminarReporte(String id) async {
    await ReporteAnimalService.eliminarReporte(id);
  }
}
