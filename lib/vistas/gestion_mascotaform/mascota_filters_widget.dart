import 'package:flutter/material.dart';

class MascotaFiltersWidget extends StatelessWidget {
  final String filterVacunado;
  final String filterEsterilizado;
  final String filterAdoptable;

  final ValueChanged<String?> onVacunadoChanged;
  final ValueChanged<String?> onEsterilizadoChanged;
  final ValueChanged<String?> onAdoptableChanged;

  const MascotaFiltersWidget({
    super.key,
    required this.filterVacunado,
    required this.filterEsterilizado,
    required this.filterAdoptable,
    required this.onVacunadoChanged,
    required this.onEsterilizadoChanged,
    required this.onAdoptableChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap permite que, si no hay espacio horizontal, los filtros
    // bajen a la siguiente línea y eviten el overflow. [web:7][web:21]
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: _filterWidth(context),
          child: _DropdownFilter(
            label: "Vacunado",
            value: filterVacunado,
            items: const ["Todos", "Vacunado", "No vacunado"],
            onChanged: onVacunadoChanged,
          ),
        ),
        SizedBox(
          width: _filterWidth(context),
          child: _DropdownFilter(
            label: "Esterilizado",
            value: filterEsterilizado,
            items: const ["Todos", "Esterilizado", "No esterilizado"],
            onChanged: onEsterilizadoChanged,
          ),
        ),
        SizedBox(
          width: _filterWidth(context),
          child: _DropdownFilter(
            label: "Adoptable",
            value: filterAdoptable,
            items: const ["Todos", "Adoptable", "No adoptable"],
            onChanged: onAdoptableChanged,
          ),
        ),
      ],
    );
  }

  // Opcional: cada filtro ocupa ~1/3 del ancho menos espaciado en pantallas grandes.
  double _filterWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Puedes ajustar este valor a tu gusto.
    final maxPerRow = 3;
    final horizontalPadding = 14 * 2; // padding del Scaffold
    final spacing = 10 * (maxPerRow - 1);
    final available = width - horizontalPadding - spacing;
    return available / maxPerRow;
  }
}

class _DropdownFilter extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownFilter({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded:
          true, // Hace que el dropdown use todo el ancho y evita overflow interno. [web:2][web:12]
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(fontSize: 15, color: Colors.black),
      items: items
          .map(
            (opcion) => DropdownMenuItem<String>(
              value: opcion,
              child: Text(
                opcion,
                overflow: TextOverflow
                    .ellipsis, // Si el texto es muy largo, lo corta con "...". [web:2]
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
