import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'package:huellitas/vistas/donaciones/donacion_view.dart';
import 'package:huellitas/vistas/reporteAnimal/reportar_animal_view.dart';
import 'package:huellitas/vistas/casas_de_paso_view_user/casa_paso_view.dart';
import 'package:huellitas/vistas/voluntariado_view_user/registro_voluntario_view.dart';

class HomeView extends StatelessWidget {
  final String userName;
  const HomeView({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.black54,
        iconSize: 28,
        selectedLabelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Adoptar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
        currentIndex: 0,
        onTap: (index) async {
          if (index == 2) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 Encabezado
              Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade200.withOpacity(0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                            '¡Hola!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Gracias por ser parte de la familia Huellitas 🐾',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.pets, color: Colors.white, size: 42),
                  ],
                ),
              ),

              // 🔹 Acciones rápidas
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

              // 🧩 Fila 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.report,
                        title: 'Reportar Animal',
                        subtitle: 'En situación de calle',
                        backgroundColor: const Color(0xFFFFF0E0),
                        borderColor: Colors.redAccent,
                        iconColor: Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReportarAnimalView()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.card_giftcard,
                        title: 'Donar',
                        subtitle: 'Alimentos e insumos',
                        backgroundColor: const Color(0xFFDFFFE2),
                        borderColor: Colors.green,
                        iconColor: Colors.green.shade700,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DonacionView()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 🧩 Fila 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
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
                      child: _QuickActionCard(
                        icon: Icons.home_work_outlined,
                        title: 'Casas de Paso',
                        subtitle: 'Acoge temporalmente',
                        backgroundColor: const Color(0xFFF2E6FF),
                        borderColor: Colors.deepPurple,
                        iconColor: Colors.deepPurple,
                        onTap: () {
                          Get.toNamed('/casasPasoHome');;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🧡 Eventos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Próximos Eventos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Ver todos',
                        style:
                            TextStyle(color: Colors.teal[700], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 🗓️ Lista de eventos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('eventos')
                        .where('publico', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'Aún no hay eventos publicados.',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 18),
                        itemBuilder: (context, i) {
                          final ev = docs[i].data() as Map<String, dynamic>;
                          final tipo = ev['tipo'] ?? '';
                          final esAdopcion = tipo == 'Adopción';
                          final esEst = tipo == 'Esterilización';
                          final colorEtiqueta = esAdopcion
                              ? const Color(0xFFFF9800)
                              : (esEst
                                  ? const Color(0xFF7E57C2)
                                  : Colors.blueGrey);
                          final colorFondoEtiqueta = esAdopcion
                              ? const Color(0xFFFFF3E0)
                              : (esEst
                                  ? const Color(0xFFEDE7F6)
                                  : Colors.blueGrey.shade50);

                          return Container(
                            width: 270,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.teal.shade100, width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.06),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorFondoEtiqueta,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.folder,
                                          color: colorEtiqueta, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        tipo,
                                        style: TextStyle(
                                          color: colorEtiqueta,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ev['titulo'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ev['descripcion'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.event,
                                        size: 16, color: Colors.teal[700]),
                                    const SizedBox(width: 5),
                                    Text(ev['fecha'] ?? '',
                                        style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 10),
                                    Icon(Icons.access_time,
                                        size: 16, color: Colors.teal[400]),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        ev['horario'] ?? '',
                                        style:
                                            const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_pin,
                                        size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        ev['ubicacion'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
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

/// 🌸 Tarjeta de acción rápida con tamaño uniforme
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 130, // 🔹 Altura uniforme
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
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
