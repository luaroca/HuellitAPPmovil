import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'mascota_form_view.dart';

class GestionMascotasView extends StatefulWidget {
  const GestionMascotasView({super.key});

  @override
  State<GestionMascotasView> createState() => _GestionMascotasViewState();
}

class _GestionMascotasViewState extends State<GestionMascotasView> {
  final MascotaController controller = Get.put(MascotaController());
  bool filterVacunado = false;
  bool filterEsterilizado = false;
  bool filterAdoptable = false;

  List<MascotaModel> _applyFilters(List<MascotaModel> mascotas) {
    return mascotas.where((m) {
      if (filterVacunado && !m.vacunado) return false;
      if (filterEsterilizado && !m.esterilizado) return false;
      if (filterAdoptable && !m.disponible) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Mascotas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4DB6AC),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFA8E6CF),
      body: Obx(() {
        final masc = controller.mascotas;
        final visibles = _applyFilters(masc);
        int total = masc.length;
        int disponibles = masc.where((e) => e.disponible).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: _ContadorBonito(
                          icon: Icons.pets,
                          count: total,
                          color: const Color(0xFF4DB6AC),
                          bgColor: const Color(0xFFE8F6F4),
                          title: 'Total mascotas')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _ContadorBonito(
                          icon: Icons.check_circle,
                          count: disponibles,
                          color: const Color(0xFFFFB74D),
                          bgColor: const Color(0xFFFFF4E3),
                          title: 'Disponibles')),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    selected: filterVacunado,
                    label: const Text("Vacunados"),
                    selectedColor: Colors.green[100],
                    backgroundColor: Colors.white,
                    onSelected: (s) =>
                        setState(() => filterVacunado = s),
                  ),
                  FilterChip(
                    selected: filterEsterilizado,
                    label: const Text("Esterilizados"),
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.white,
                    onSelected: (s) =>
                        setState(() => filterEsterilizado = s),
                  ),
                  FilterChip(
                    selected: filterAdoptable,
                    label: const Text("Adoptables"),
                    selectedColor: Colors.orange[100],
                    backgroundColor: Colors.white,
                    onSelected: (s) =>
                        setState(() => filterAdoptable = s),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => MascotaFormView()),
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.white, size: 26),
                  label: const Text('Agregar Nueva Mascota',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (visibles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                      child: Text(
                          "No hay mascotas coincidentes con el filtro seleccionado.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ))),
                ),
              ListView.builder(
                itemCount: visibles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  final mascota = visibles[i];
                  return Card(
                    color: const Color(0xFFFFFCF5),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen o icono
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: mascota.fotoUrl != null &&
                                    mascota.fotoUrl!.isNotEmpty
                                ? Image.network(mascota.fotoUrl!,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _defaultIcon())
                                : _defaultIcon(),
                          ),
                          const SizedBox(width: 15),
                          // Datos principales y chips
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${mascota.nombre} (${mascota.tipo})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                                Text('${mascota.genero} - ${mascota.tamanio}',
                                    style:
                                        const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Chip(
                                      avatar: Icon(Icons.check_circle,
                                          color: mascota.vacunado
                                              ? Colors.green
                                              : Colors.grey[400],
                                          size: 18),
                                      backgroundColor: Colors.green[50],
                                      label: Text(
                                          mascota.vacunado
                                              ? 'Vacunado'
                                              : 'No vacunado',
                                          style: TextStyle(
                                              color: mascota.vacunado
                                                  ? Colors.green[700]
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Chip(
                                      avatar: Icon(Icons.medical_services,
                                          color: mascota.esterilizado
                                              ? Colors.blue
                                              : Colors.grey[400],
                                          size: 18),
                                      backgroundColor: Colors.blue[50],
                                      label: Text(
                                          mascota.esterilizado
                                              ? 'Esterilizado'
                                              : 'No esterilizado',
                                          style: TextStyle(
                                              color: mascota.esterilizado
                                                  ? Colors.blue[700]
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Chip(
                                      avatar: Icon(Icons.pets,
                                          color: mascota.disponible
                                              ? Colors.deepOrange
                                              : Colors.grey[400],
                                          size: 18),
                                      backgroundColor: Colors.orange[50],
                                      label: Text(
                                          mascota.disponible
                                              ? 'Adoptable'
                                              : 'No adoptable',
                                          style: TextStyle(
                                              color: mascota.disponible
                                                  ? Colors.deepOrange
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Botón más (editar/eliminar)
                          PopupMenuButton<String>(
                            onSelected: (val) async {
                              if (val == 'editar') {
                                Get.to(() => MascotaFormView(mascota: mascota));
                              }
                              if (val == 'eliminar') {
                                final sure = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text('¿Eliminar mascota?'),
                                    content: Text(
                                        '¿Seguro que deseas eliminar a ${mascota.nombre}?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: const Text('Cancelar')),
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: const Text('Eliminar')),
                                    ],
                                  ),
                                );
                                if (sure == true) {
                                  await controller.eliminarMascota(mascota.id);
                                }
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 'editar', child: Text('Editar')),
                              const PopupMenuItem(
                                  value: 'eliminar', child: Text('Eliminar')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _defaultIcon() => Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.pets, color: Colors.teal, size: 33),
      );
}

class _ContadorBonito extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final Color color;
  final Color bgColor;

  const _ContadorBonito(
      {required this.icon,
      required this.count,
      required this.title,
      required this.color,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 6),
            Text('$count',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            const SizedBox(height: 4),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
