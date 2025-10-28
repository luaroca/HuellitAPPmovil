import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/donacion_controller.dart';
import 'package:huellitas/modelos/donacion_model.dart';

class GestionDonativosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.put(DonacionController());
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text(
          'Gestión de Donativos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: () => c.onInit()),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Administra las donaciones recibidas',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Dashboard cards estilo "Acciones rápidas"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                child: Row(
                  children: [
                    _DashboardCardPretty(
                      color: const Color(0xFFFF9800),
                      borderColor: const Color(0xFFFFD4A3),
                      bgOpacity: 0.11,
                      icon: Icons.hourglass_bottom,
                      title: 'Pendientes',
                      value: c.contarPorEstado(EstadoDonacion.pendiente).toString(),
                    ),
                    const SizedBox(width: 10),
                    _DashboardCardPretty(
                      color: const Color(0xFF8D65DB),
                      borderColor: const Color(0xFFE7D6FF),
                      bgOpacity: 0.13,
                      icon: Icons.all_inbox,
                      title: 'Recogidos',
                      value: c.contarPorEstado(EstadoDonacion.recogido).toString(),
                    ),
                  ],
                ),
              ),
              // Filtros centrados
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _FiltroChip('todos', 'Todos', c),
                      SizedBox(width: 6),
                      _FiltroChip('pendiente', 'Pendientes', c),
                      SizedBox(width: 6),
                      _FiltroChip('recogido', 'Recogidos', c),
                    ],
                  ),
                ),
              ),
              // Listado
              Obx(() {
                var lista = c.donacionesFiltradas
                    .where((d) => d.estado == EstadoDonacion.pendiente || d.estado == EstadoDonacion.recogido)
                    .toList();
                if (c.filtro.value == 'pendiente') {
                  lista = lista.where((d) => d.estado == EstadoDonacion.pendiente).toList();
                } else if (c.filtro.value == 'recogido') {
                  lista = lista.where((d) => d.estado == EstadoDonacion.recogido).toList();
                }
                if (lista.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text('No hay donaciones.')),
                  );
                }
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lista.length,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 30),
                  itemBuilder: (_, i) =>
                      _DonacionCard(model: lista[i], controller: c),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

// CARD DASHBOARD estilo bonito
class _DashboardCardPretty extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final double bgOpacity;
  final IconData icon;
  final String title;
  final String value;
  const _DashboardCardPretty(
      {required this.color,
      required this.borderColor,
      required this.bgOpacity,
      required this.icon,
      required this.title,
      required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 91,
        decoration: BoxDecoration(
          color: color.withOpacity(bgOpacity),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color.withOpacity(0.83), size: 27),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                  color: color.withOpacity(0.92),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              title,
              style: TextStyle(
                  color: color.withOpacity(0.83),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}

// CHIP DE FILTRO
class _FiltroChip extends StatelessWidget {
  final String id;
  final String label;
  final DonacionController c;
  const _FiltroChip(this.id, this.label, this.c, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = id == c.filtro.value;
      return ChoiceChip(
        selected: selected,
        label: Text(label),
        selectedColor: Colors.orange[200],
        onSelected: (_) => c.cambiarFiltro(id),
        labelStyle: TextStyle(
            color: selected ? Colors.black87 : Colors.grey[800],
            fontWeight: selected ? FontWeight.bold : FontWeight.normal),
        backgroundColor: Colors.grey[100],
      );
    });
  }
}

// CARD DE DONACION
class _DonacionCard extends StatelessWidget {
  final DonacionModel model;
  final DonacionController controller;

  const _DonacionCard({required this.model, required this.controller});

  Color get estadoColor {
    switch (model.estado) {
      case EstadoDonacion.recogido:
        return Colors.purple;
      default:
        return Colors.orange;
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
      margin: const EdgeInsets.only(top: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header detalles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const CircleAvatar(
                      radius: 13, backgroundImage: AssetImage('assets/user.png')),
                  const SizedBox(width: 8),
                  Text(model.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ]),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: estadoColor.withOpacity(0.14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      Icon(estadoIcon, color: estadoColor, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        estadoTexto,
                        style: TextStyle(fontWeight: FontWeight.w600, color: estadoColor, fontSize: 13),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 13),
            // Items donados
            Row(
              children: [
                Icon(Icons.restaurant_rounded, color: Colors.orange[400], size: 19),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(model.items, style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            if(model.notas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 27),
                child: Text(
                  model.notas,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 7),
            // Dirección, teléfono y fecha
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(model.direccion.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.place, size: 17, color: Colors.orange[300]),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            model.direccion,
                            style: TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 17, color: Colors.orange[300]),
                      const SizedBox(width: 5),
                      Text(model.telefono, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.event, size: 17, color: Colors.orange[300]),
                      const SizedBox(width: 5),
                      Text('${model.fecha.day.toString().padLeft(2,'0')}/${model.fecha.month.toString().padLeft(2,'0')}/${model.fecha.year}', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Estado editable SOLO pendiente y recogido
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: DropdownButtonFormField<EstadoDonacion>(
                value: model.estado,
                items: const [
                  DropdownMenuItem(value: EstadoDonacion.pendiente, child: Text('Pendiente')),
                  DropdownMenuItem(value: EstadoDonacion.recogido, child: Text('Recogido')),
                ],
                onChanged: (value) {
                  if (value != null && value != model.estado) {
                    controller.actualizarEstado(model, value);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Actualizar estado',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
