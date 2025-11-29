import 'package:flutter/material.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotaCardWidget extends StatelessWidget {
  final MascotaModel mascota;
  final VoidCallback onEdit;

  const MascotaCardWidget({
    super.key,
    required this.mascota,
    required this.onEdit,
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
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.teal[50],
                  child: const Center(
                    child: Icon(Icons.pets, color: Colors.teal, size: 50),
                  ),
                ),
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

                  Text(
                    "${mascota.genero} • ${mascota.tamanio}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  if (mascota.descripcion != null &&
                      mascota.descripcion!.trim().isNotEmpty)
                    Expanded(
                      child: Scrollbar(
                        thickness: 3,
                        radius: const Radius.circular(5),
                        child: SingleChildScrollView(
                          child: Text(
                            mascota.descripcion!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _estadoChip(mascota.vacunado, "Vacunado", Colors.green),
                      _estadoChip(
                          mascota.esterilizado, "Esterilizado", Colors.blue),
                      _estadoChip(
                          mascota.disponible, "Adoptable", Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.blue[50],
                      onPressed: onEdit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            "Editar",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoChip(bool activo, String texto, Color color) {
    return Chip(
      backgroundColor:
          activo ? color.withOpacity(.15) : Colors.grey.withOpacity(.15),
      avatar:
          Icon(Icons.circle, size: 14, color: activo ? color : Colors.grey),
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
