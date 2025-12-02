import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/gestion_adopciones_admin/gestion_adopciones_admin_view.dart';
import 'package:huellitas/vistas/gestion_casas_de_paso/gestion_casas_admin_view.dart';
import 'package:huellitas/vistas/gestion_eventosform/evento_form_view.dart';
import 'package:huellitas/vistas/gestion_eventosform/gestion_eventos_wiew.dart';
import 'package:huellitas/vistas/gestion_mascotaform/gestion_mascotas_view.dart';
import 'package:huellitas/vistas/gestion_reportes_animales_admin/gestion_reportes_animales_viewad.dart';
import 'package:huellitas/vistas/gestion_voluntario_view/gestion_voluntariados_view.dart';

class AdminHomeView extends StatelessWidget {
  final String adminName;
  const AdminHomeView({Key? key, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hola,",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            adminName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Bienvenido al panel administrativo 🐾",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ),

              
              const Text(
                "Acciones Rápidas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 18),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.85,
                children: [
                  AdminQuickActionCard(
                    icon: Icons.pets,
                    title: 'Gestión de Animales',
                    subtitle: 'Control de fichas',
                    backgroundColor: const Color(0xFFFFF0E0),
                    borderColor: const Color(0xFFFFB74D),
                    iconColor: const Color(0xFFFFA726),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionMascotasView()),
                      );
                    },
                  ),
                  AdminQuickActionCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Adopciones',
                    subtitle: 'Seguimiento y control',
                    backgroundColor: const Color(0xFFFFE4EC),
                    borderColor: const Color(0xFFF48FB1),
                    iconColor: const Color(0xFFD81B60),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionAdopcionesAdminView()),
                      );
                    },
                  ),
                  AdminQuickActionCard(
                    icon: Icons.volunteer_activism,
                    title: 'Voluntariado',
                    subtitle: 'Gestión del equipo',
                    backgroundColor: const Color(0xFFE8F1FF),
                    borderColor: const Color(0xFF64B5F6),
                    iconColor: const Color(0xFF1976D2),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionVoluntariadosAdminView()),
                      );
                    },
                  ),
                  AdminQuickActionCard(
                    icon: Icons.report_gmailerrorred_rounded,
                    title: 'Reportes de Calle',
                    subtitle: 'Casos reportados',
                    backgroundColor: const Color(0xFFFFE8E8),
                    borderColor: const Color(0xFFEF9A9A),
                    iconColor: Colors.redAccent,
                    onTap: () {
                      
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionReportesAnimalesView()),
                      );
                    },
                  ),
                  AdminQuickActionCard(
                    icon: Icons.home_work_outlined,
                    title: 'Casas de Paso',
                    subtitle: 'Hogares aliados',
                    backgroundColor: const Color(0xFFF2E6FF),
                    borderColor: const Color(0xFFB39DDB),
                    iconColor: const Color(0xFF673AB7),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionCasasPasoAdminView()),
                      );
                    },
                  ),
                  AdminQuickActionCard(
                    icon: Icons.event_rounded,
                    title: 'Avisos y Jornadas',
                    subtitle: 'Organiza eventos',
                    backgroundColor: const Color(0xFFFFF3E0),
                    borderColor: const Color(0xFFFFB74D),
                    iconColor: const Color(0xFFF57C00),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GestionEventosView()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Próximos Eventos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 210,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('eventos')
                      .where('publico', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aún no hay eventos publicados.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        final ev = docs[i].data() as Map<String, dynamic>;
                        return Container(
                          width: 280,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.orange.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.label,
                                      color: Colors.orange[400], size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    ev['tipo'] ?? '',
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ev['titulo'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ev['descripcion'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.event,
                                      size: 18, color: Colors.orange[400]),
                                  const SizedBox(width: 4),
                                  Text(ev['fecha'] ?? '',
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 10),
                                  Icon(Icons.access_time,
                                      size: 18, color: Colors.blue[400]),
                                  const SizedBox(width: 4),
                                  Text(ev['horario'] ?? '',
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.location_pin,
                                      size: 18, color: Colors.green[400]),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      ev['ubicacion'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}



class AdminQuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const AdminQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 36),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
