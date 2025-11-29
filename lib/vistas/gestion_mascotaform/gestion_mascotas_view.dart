
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'package:huellitas/vistas/gestion_mascotaform/contador_gestion_mascotas_widget.dart';
import 'package:huellitas/vistas/gestion_mascotaform/mascota_card_widget.dart';
import 'package:huellitas/vistas/gestion_mascotaform/mascota_filters_widget.dart';
import 'mascota_form_view.dart';

class GestionMascotasView extends StatefulWidget {
  const GestionMascotasView({super.key});

  @override
  State<GestionMascotasView> createState() => _GestionMascotasViewState();
}

class _GestionMascotasViewState extends State<GestionMascotasView> {
  final MascotaController controller = Get.put(MascotaController());

  String filterVacunado = "Todos";
  String filterEsterilizado = "Todos";
  String filterAdoptable = "Todos";

  List<MascotaModel> _applyFilters(List<MascotaModel> mascotas) {
    return mascotas.where((m) {
      if (filterVacunado != "Todos") {
        if (filterVacunado == "Vacunado" && !m.vacunado) return false;
        if (filterVacunado == "No vacunado" && m.vacunado) return false;
      }
      if (filterEsterilizado != "Todos") {
        if (filterEsterilizado == "Esterilizado" && !m.esterilizado) return false;
        if (filterEsterilizado == "No esterilizado" && m.esterilizado) return false;
      }
      if (filterAdoptable != "Todos") {
        if (filterAdoptable == "Adoptable" && !m.disponible) return false;
        if (filterAdoptable == "No adoptable" && m.disponible) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 3 : (width > 600 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Mascotas",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4DB6AC),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFA8E6CF),

      body: Obx(() {
        final mascotas = controller.mascotas;
        final visibles = _applyFilters(mascotas);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ContadorBonitoWidget(
                      icon: Icons.pets,
                      count: mascotas.length,
                      title: "Total",
                      color: const Color(0xFF4DB6AC),
                      bgColor: const Color(0xFFE8F6F4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ContadorBonitoWidget(
                      icon: Icons.check_circle,
                      count: mascotas.where((e) => e.disponible).length,
                      title: "Disponibles",
                      color: const Color(0xFFFFB74D),
                      bgColor: const Color(0xFFFFF4E3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              MascotaFiltersWidget(
                filterVacunado: filterVacunado,
                filterEsterilizado: filterEsterilizado,
                filterAdoptable: filterAdoptable,
                onVacunadoChanged: (v) => setState(() => filterVacunado = v!),
                onEsterilizadoChanged: (v) => setState(() => filterEsterilizado = v!),
                onAdoptableChanged: (v) => setState(() => filterAdoptable = v!),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text("Agregar Nueva Mascota",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Get.to(() => MascotaFormView()),
                ),
              ),

              const SizedBox(height: 16),

              visibles.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        "No hay mascotas que coincidan con el filtro.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: visibles.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (_, i) => MascotaCardWidget(
                        mascota: visibles[i],
                        onEdit: () =>
                            Get.to(() => MascotaFormView(mascota: visibles[i])),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
