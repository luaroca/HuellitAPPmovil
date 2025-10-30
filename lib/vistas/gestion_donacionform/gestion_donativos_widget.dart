import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/donacion_controller.dart';
import 'package:huellitas/modelos/donacion_model.dart';

class GestionDonativosWidget extends StatelessWidget {
  final DonacionController controller;

  const GestionDonativosWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                _DashboardCardPretty(
                  controller: controller,
                  estado: EstadoDonacion.pendiente,
                  color: const Color(0xFF226776),
                  borderColor: const Color(0xFFB2DFDB),
                  bgOpacity: 0.12,
                  icon: Icons.hourglass_bottom,
                  title: 'Pendientes',
                ),
                const SizedBox(width: 10),
                _DashboardCardPretty(
                  controller: controller,
                  estado: EstadoDonacion.recogido,
                  color: const Color(0xFF1F4E60),
                  borderColor: const Color(0xFFD0E6E3),
                  bgOpacity: 0.13,
                  icon: Icons.inbox_outlined,
                  title: 'Recogidos',
                ),
              ],
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
            child: Center(
              child: Wrap(
                spacing: 8,
                children: [
                  _FiltroChip('todos', 'Todos', controller),
                  _FiltroChip('pendiente', 'Pendientes', controller),
                  _FiltroChip('recogido', 'Recogidos', controller),
                ],
              ),
            ),
          ),

          
          Obx(() {
            final filtroActual = controller.filtro.value;
            final listaBase = controller.donaciones
                .where((d) =>
                    d.estado == EstadoDonacion.pendiente ||
                    d.estado == EstadoDonacion.recogido)
                .toList();

            List<DonacionModel> lista = listaBase;
            if (filtroActual == 'pendiente') {
              lista = listaBase
                  .where((d) => d.estado == EstadoDonacion.pendiente)
                  .toList();
            } else if (filtroActual == 'recogido') {
              lista = listaBase
                  .where((d) => d.estado == EstadoDonacion.recogido)
                  .toList();
            }

            if (lista.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'No hay donaciones registradas.',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }

            return ListView.builder(
              key: ValueKey(filtroActual), 
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: lista.length,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 40),
              itemBuilder: (_, i) => _DonacionCard(
                key: ValueKey(lista[i].id), 
                model: lista[i],
                controller: controller,
              ),
            );
          }),
        ],
      ),
    );
  }
}


class _DashboardCardPretty extends StatelessWidget {
  final DonacionController controller;
  final EstadoDonacion estado;
  final Color color;
  final Color borderColor;
  final double bgOpacity;
  final IconData icon;
  final String title;

  const _DashboardCardPretty({
    required this.controller,
    required this.estado,
    required this.color,
    required this.borderColor,
    required this.bgOpacity,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(bgOpacity),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(1, 1),
            )
          ],
        ),
        child: Obx(() {
          final count = controller.contarPorEstado(estado);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color.withOpacity(0.9), size: 30),
              const SizedBox(height: 5),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color.withOpacity(0.95),
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: color.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}


class _FiltroChip extends StatelessWidget {
  final String id;
  final String label;
  final DonacionController controller;

  const _FiltroChip(this.id, this.label, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = id == controller.filtro.value;
      return ChoiceChip(
        selected: selected,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: selected ? Colors.black : Colors.grey[700],
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        selectedColor: const Color(0xFFB2EBF2),
        backgroundColor: Colors.white,
        onSelected: (_) => controller.cambiarFiltro(id),
      );
    });
  }
}


class _DonacionCard extends StatelessWidget {
  final DonacionModel model;
  final DonacionController controller;

  const _DonacionCard({
    super.key,
    required this.model,
    required this.controller,
  });

  Color get estadoColor {
    switch (model.estado) {
      case EstadoDonacion.recogido:
        return const Color(0xFF1F4E60);
      default:
        return const Color(0xFF226776);
    }
  }

  String get estadoTexto {
    switch (model.estado) {
      case EstadoDonacion.recogido:
        return 'Recogido';
      default:
        return 'Pendiente';
    }
  }

  IconData get estadoIcon {
    switch (model.estado) {
      case EstadoDonacion.recogido:
        return Icons.inbox_outlined;
      default:
        return Icons.hourglass_bottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 14),
      elevation: 3,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87),
                  ),
                ]),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: estadoColor.withOpacity(0.15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      Icon(estadoIcon, color: estadoColor, size: 17),
                      const SizedBox(width: 5),
                      Text(
                        estadoTexto,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: estadoColor,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),

          
            Row(
              children: [
                const Icon(Icons.restaurant_rounded,
                    color: Color(0xFF226776), size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    model.items,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (model.notas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 27),
                child: Text(
                  model.notas,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 10),

            
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.direccion.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.place,
                            size: 18, color: Color(0xFF226776)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            model.direccion,
                            style: const TextStyle(fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          size: 18, color: Color(0xFF226776)),
                      const SizedBox(width: 5),
                      Text(
                        model.telefono,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.event,
                          size: 18, color: Color(0xFF226776)),
                      const SizedBox(width: 5),
                      Text(
                        '${model.fecha.day.toString().padLeft(2, '0')}/${model.fecha.month.toString().padLeft(2, '0')}/${model.fecha.year}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

           
            DropdownButtonFormField<EstadoDonacion>(
              value: model.estado,
              items: const [
                DropdownMenuItem(
                    value: EstadoDonacion.pendiente, child: Text('Pendiente')),
                DropdownMenuItem(
                    value: EstadoDonacion.recogido, child: Text('Recogido')),
              ],
              onChanged: (value) async {
                if (value != null && value != model.estado) {
                  await controller.actualizarEstado(model, value);

                  
                  final index = controller.donaciones
                      .indexWhere((d) => d.id == model.id);
                  if (index != -1) {
                    controller.donaciones[index].estado = value;
                    controller.donaciones.refresh();
                  }
                }
              },
              decoration: InputDecoration(
                labelText: 'Actualizar estado',
                labelStyle: const TextStyle(fontSize: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
