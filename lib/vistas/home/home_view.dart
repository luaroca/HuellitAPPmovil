import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/donaciones/donacion_view.dart';
import 'package:huellitas/vistas/reporteAnimal/reportar_animal_view.dart';

class HomeView extends StatelessWidget {
  final String userName;
  const HomeView({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9ED),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Adoptar',
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
              final doc = await authController.firestore.collection('users').doc(user.uid).get();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hola,',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gracias por ser parte de la familia Huellitas 🐾',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.pets, size: 28, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Sección Acciones Rápidas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              const SizedBox(height: 11),

              // Primera fila
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _QuickActionCard(
                      icon: Icons.report,
                      title: 'Reportar Animal',
                      subtitle: 'En situación de calle',
                      backgroundColor: const Color(0xFFFFECEC),
                      borderColor: const Color(0xFFF28C8C),
                      iconColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReportarAnimalView()),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _QuickActionCard(
                      icon: Icons.card_giftcard,
                      title: 'Donar',
                      subtitle: 'Alimentos e insumos',
                      backgroundColor: const Color(0xFFEAF9EC),
                      borderColor: const Color(0xFF9DE7A5),
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DonacionView()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Segunda fila
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _QuickActionCard(
                      icon: Icons.volunteer_activism,
                      title: 'Voluntariado',
                      subtitle: 'Únete al equipo y ayuda',
                      backgroundColor: const Color(0xFFE8F1FF),
                      borderColor: const Color(0xFF9CC9FF),
                      iconColor: Colors.blueAccent,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _QuickActionCard(
                      icon: Icons.home_work_outlined,
                      title: 'Casas de Paso',
                      subtitle: 'Acoge temporalmente',
                      backgroundColor: const Color(0xFFF5E9FF),
                      borderColor: const Color(0xFFD5B9FF),
                      iconColor: Colors.purple,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Eventos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Próximos Eventos',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Ver todos',
                        style: TextStyle(color: Colors.orange[400]),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Lista de eventos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: SizedBox(
                  height: 165,
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
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, i) {
                          final ev = docs[i].data() as Map<String, dynamic>;
                          final esAdopcion = ev['tipo'] == 'Adopción';
                          final esEst = ev['tipo'] == 'Esterilización';
                          final colorEtiqueta = esAdopcion
                              ? const Color(0xFFFF9800)
                              : (esEst ? const Color(0xFF8356EC) : Colors.blueGrey);
                          final colorFondoEtiqueta = esAdopcion
                              ? const Color(0xFFFFF0E0)
                              : (esEst ? const Color(0xFFF0EFFF) : Colors.blueGrey.shade50);

                          return Container(
                            width: 265,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.orange.shade100, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.03),
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: colorFondoEtiqueta,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.folder, color: colorEtiqueta, size: 17),
                                      const SizedBox(width: 7),
                                      Text(
                                        ev['tipo'] ?? '',
                                        style: TextStyle(
                                          color: colorEtiqueta,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ev['titulo'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  ev['descripcion'] ?? '',
                                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.event, size: 14, color: Colors.orange[400]),
                                    const SizedBox(width: 3),
                                    Text(ev['fecha'] ?? '',
                                        style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 9),
                                    Icon(Icons.access_time,
                                        size: 14, color: Colors.blue[300]),
                                    const SizedBox(width: 3),
                                    Flexible(
                                      child: Text(
                                        ev['horario'] ?? '',
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_pin,
                                        size: 14, color: Colors.green[300]),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        ev['ubicacion'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black87),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minHeight: 130), // 🔹 Fuerza altura uniforme
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 36),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
