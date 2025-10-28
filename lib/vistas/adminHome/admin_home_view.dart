import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/gestioneventosform/gestion_eventos_wiew.dart';

class AdminHomeView extends StatelessWidget {
  final String adminName;
  const AdminHomeView({Key? key, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9ED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.shield_rounded, color: Colors.white, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Panel de Administración',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hola, $adminName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gestiona toda la plataforma de Huellitas 🐾',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Módulos Administrativos',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xff616161),
                ),
              ),
              const SizedBox(height: 15),
              GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 15,
                mainAxisSpacing: 17,
                childAspectRatio: 1.15,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _ModuleCard(
                    icon: Icons.pets,
                    label: 'Gestión de Animales',
                    subtitle: 'Ver, agregar, editar',
                    bgColor: const Color(0xFFFFF3C5),
                    borderColor: const Color(0xFFFDE0B0),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.assignment_turned_in_rounded,
                    label: 'Adopciones',
                    subtitle: 'Solicitudes',
                    bgColor: const Color(0xFFFFE0F2),
                    borderColor: const Color(0xFFFDCFEA),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.volunteer_activism,
                    label: 'Voluntariado',
                    subtitle: 'Asignar tareas',
                    bgColor: const Color(0xFFE2F1FF),
                    borderColor: const Color(0xFFB6E3FF),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.report_gmailerrorred_rounded,
                    label: 'Reportes de Calle',
                    subtitle: 'Gestión',
                    bgColor: const Color(0xFFFFEBEB),
                    borderColor: const Color(0xFFFFD2CF),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.home_work_outlined,
                    label: 'Casas de Paso',
                    subtitle: 'Asignar animales',
                    bgColor: const Color(0xFFF3E9FF),
                    borderColor: const Color(0xFFDFD2FF),
                    onTap: () {},
                  ),
                  _ModuleCard(
                    icon: Icons.event_rounded,
                    label: 'Avisos y Jornadas',
                    subtitle: 'Crear eventos',
                    bgColor: const Color(0xFFFFF3E3),
                    borderColor: const Color(0xFFFFDDC9),
                    onTap: () {
                      Get.toNamed('/gestionEventos');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Próximos Eventos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                width: double.infinity,
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
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 13),
                      itemBuilder: (context, i) {
                        final ev = docs[i].data() as Map<String, dynamic>;
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: Colors.orange.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.05),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.label,
                                      color: Colors.orange[300], size: 17),
                                  const SizedBox(width: 6),
                                  Text(
                                    (ev['tipo'] ?? '').toString(),
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Text(
                                (ev['titulo'] ?? ''),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                (ev['descripcion'] ?? ''),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black54),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 9),
                              Row(
                                children: [
                                  Icon(Icons.event,
                                      size: 16, color: Colors.orange[300]),
                                  const SizedBox(width: 2),
                                  Text(ev['fecha'] ?? '',
                                      style: const TextStyle(fontSize: 13)),
                                  const SizedBox(width: 11),
                                  Icon(Icons.access_time,
                                      size: 16, color: Colors.blue[300]),
                                  const SizedBox(width: 2),
                                  Text(ev['horario'] ?? '',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_pin,
                                      size: 16, color: Colors.green[300]),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      ev['ubicacion'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
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
        currentIndex: 0,
        onTap: (index) async {
          if (index == 2) {
            final user = authController.auth.currentUser;
            if (user != null) {
              final doc =
                  await authController.firestore.collection('users').doc(user.uid).get();
              final data = doc.data();
              if (data != null) {
                Get.toNamed(
                  '/userProfile',
                  arguments: {
                    'nombre': data['nombres'] ?? '',
                    'correo': data['email'] ?? '',
                    'telefono': data['telefono'] ?? '',
                    'esAdmin': (data['role'] ?? '') == 'admin',
                  },
                );
              }
            }
          }
        },
        selectedItemColor: Colors.orange[800],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ModuleCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.orange[900], size: 27),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
