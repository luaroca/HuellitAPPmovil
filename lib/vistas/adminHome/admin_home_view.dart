import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/controllers/auth_controller.dart';

class AdminHomeView extends StatelessWidget {
  final String adminName;
  const AdminHomeView({Key? key, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final scale = MediaQuery.of(context).textScaleFactor;

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
                  _ModuleCard(
                    icon: Icons.pets,
                    label: 'Gestión de Animales',
                    subtitle: 'Control de fichas',
                    color: const Color(0xFFFFE0B2),
                    borderColor: const Color(0xFFFFB74D),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.assignment_turned_in_rounded,
                    label: 'Adopciones',
                    subtitle: 'Seguimiento y control',
                    color: const Color(0xFFF8BBD0),
                    borderColor: const Color(0xFFF48FB1),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.volunteer_activism,
                    label: 'Voluntariado',
                    subtitle: 'Gestión del equipo',
                    color: const Color(0xFFBBDEFB),
                    borderColor: const Color(0xFF64B5F6),
                    onTap: () {
                      Get.toNamed('/gestionVoluntariados');

                    },
                  ),
                  _ModuleCard(
                    icon: Icons.report_gmailerrorred_rounded,
                    label: 'Reportes de Calle',
                    subtitle: 'Casos reportados',
                    color: const Color(0xFFFFCDD2),
                    borderColor: const Color(0xFFEF9A9A),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.home_work_outlined,
                    label: 'Casas de Paso',
                    subtitle: 'Hogares aliados',
                    color: const Color(0xFFD1C4E9),
                    borderColor: const Color(0xFFB39DDB),
                    onTap: () {
                      Get.toNamed('/gestionCasasPaso');

                    },
                  ),
                  _ModuleCard(
                    icon: Icons.event_rounded,
                    label: 'Avisos y Jornadas',
                    subtitle: 'Organiza eventos',
                    color: const Color(0xFFFFF3E0),
                    borderColor: const Color(0xFFFFB74D),
                    onTap: () => Get.toNamed('/gestionEventos'),
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
                    'Ver todos',
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
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, i) {
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
                                    (ev['tipo'] ?? '').toString(),
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
                                (ev['titulo'] ?? ''),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                (ev['descripcion'] ?? ''),
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

      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.orange[800],
        unselectedItemColor: Colors.grey,
        selectedFontSize: 15,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Donativos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            Get.toNamed('/gestionDonativos');
          } else if (index == 2) {
            final user = authController.auth.currentUser;
            if (user != null) {
              final doc = await authController.firestore
                  .collection('users')
                  .doc(user.uid)
                  .get();
              final data = doc.data();
              if (data != null) {
                Get.toNamed('/userProfile', arguments: {
                  'nombre': data['nombres'] ?? '',
                  'correo': data['email'] ?? '',
                  'telefono': data['telefono'] ?? '',
                  'esAdmin': (data['role'] ?? '') == 'admin',
                });
              }
            }
          }
        },
      ),
    );
  }
}


class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _ModuleCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      splashColor: borderColor.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: borderColor, size: 38 * scale),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF222222),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15.5,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
