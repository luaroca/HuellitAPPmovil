import 'package:flutter/material.dart';
import 'widget_header_home.dart';
import 'widget_quick_action_card.dart';
import 'widget_event_list.dart';
import 'package:huellitas/vistas/donaciones/donacion_view.dart';
import 'package:huellitas/vistas/reporteAnimal/reportar_animal_view.dart';
import 'package:get/get.dart';

class HomeBody extends StatelessWidget {
  final String userName;
  const HomeBody({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderHome(userName: userName),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Fila 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.report,
                    title: 'Reportar Animal',
                    subtitle: 'En situación de calle',
                    backgroundColor: const Color(0xFFFFF0E0),
                    borderColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ReportarAnimalView()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.card_giftcard,
                    title: 'Donar',
                    subtitle: 'Alimentos e insumos',
                    backgroundColor: const Color(0xFFDFFFE2),
                    borderColor: Colors.green,
                    iconColor: Colors.green.shade700,
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const DonacionView()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fila 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.volunteer_activism,
                    title: 'Voluntariado',
                    subtitle: 'Únete al equipo',
                    backgroundColor: const Color(0xFFE8F1FF),
                    borderColor: Colors.blueAccent,
                    iconColor: Colors.blueAccent,
                    onTap: () {
                      Get.toNamed('/voluntariadoHome');
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.home_work_outlined,
                    title: 'Casas de Paso',
                    subtitle: 'Acoge temporalmente',
                    backgroundColor: const Color(0xFFF2E6FF),
                    borderColor: Colors.deepPurple,
                    iconColor: Colors.deepPurple,
                    onTap: () {
                      Get.toNamed('/casasPasoHome');
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          EventList(),
        ],
      ),
    );
  }
}
