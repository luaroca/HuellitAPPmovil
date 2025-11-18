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
                    child: _ContadorBonito(
                      icon: Icons.pets,
                      count: mascotas.length,
                      title: "Total",
                      color: const Color(0xFF4DB6AC),
                      bgColor: const Color(0xFFE8F6F4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ContadorBonito(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    selected: filterVacunado,
                    label: const Text("Vacunados"),
                    selectedColor: Colors.green[100],
                    onSelected: (s) => setState(() => filterVacunado = s),
                  ),
                  FilterChip(
                    selected: filterEsterilizado,
                    label: const Text("Esterilizados"),
                    selectedColor: Colors.blue[100],
                    onSelected: (s) => setState(() => filterEsterilizado = s),
                  ),
                  FilterChip(
                    selected: filterAdoptable,
                    label: const Text("Adoptables"),
                    selectedColor: Colors.orange[100],
                    onSelected: (s) => setState(() => filterAdoptable = s),
                  ),
                ],
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
                          borderRadius: BorderRadius.circular(12))),
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
                      itemBuilder: (_, i) {
                        return _MascotaCard(
                          mascota: visibles[i],
                          onEdit: () =>
                              Get.to(() => MascotaFormView(mascota: visibles[i])),
                          onDelete: () => _confirmDelete(visibles[i]),
                        );
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }

  void _confirmDelete(MascotaModel mascota) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: Text("¿Eliminar a ${mascota.nombre}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              controller.eliminarMascota(mascota.id!);
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _MascotaCard extends StatelessWidget {
  final MascotaModel mascota;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MascotaCard({
    super.key,
    required this.mascota,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFFFFCF5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                mascota.fotoUrl ?? "",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _defaultIcon(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mascota.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          mascota.tipo,
                          style: const TextStyle(
                              color: Color(0xFF46A58D),
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("${mascota.genero} • ${mascota.tamanio}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis),
                  // Descripción scrollable y elegante
                  if (mascota.descripcion != null &&
                      mascota.descripcion!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Expanded(
                      child: Scrollbar(
                        thickness: 4,
                        radius: const Radius.circular(5),
                        child: SingleChildScrollView(
                          child: Text(
                            mascota.descripcion!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                  ],
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _estadoChip(mascota.vacunado, "Vacunado", Colors.green),
                      _estadoChip(
                          mascota.esterilizado, "Esterilizado", Colors.blue),
                      _estadoChip(mascota.disponible, "Adoptable", Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blue[50],
                        elevation: 0,
                        onPressed: onEdit,
                        child: Row(
                          children: const [
                            Icon(Icons.edit, color: Colors.blue, size: 18),
                            SizedBox(width: 4),
                            Text("Editar",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.red[50],
                        elevation: 0,
                        onPressed: onDelete,
                        child: Row(
                          children: const [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 4),
                            Text("Eliminar",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultIcon() => Container(
        color: Colors.teal[50],
        child: const Center(child: Icon(Icons.pets, color: Colors.teal, size: 50)),
      );
  Widget _estadoChip(bool activo, String texto, Color color) {
    return Chip(
      backgroundColor:
          activo ? color.withOpacity(.15) : Colors.grey.withOpacity(.15),
      avatar: Icon(Icons.circle, size: 14, color: activo ? color : Colors.grey),
      label: Text(
        activo ? texto : "No $texto",
        style: TextStyle(
          color: activo ? color : Colors.grey[700],
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _ContadorBonito extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final Color color;
  final Color bgColor;

  const _ContadorBonito({
    required this.icon,
    required this.count,
    required this.title,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 6),
            Text("$count",
                style: TextStyle(
                    fontSize: 22, color: color, fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    color: color.withOpacity(.9),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
