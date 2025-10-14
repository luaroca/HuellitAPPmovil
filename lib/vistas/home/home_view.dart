import 'package:flutter/material.dart';
import 'package:huellitas/vistas/donaciones/donacion_view.dart';
import 'package:huellitas/vistas/reporteAnimal/reportar_animal_view.dart';

class HomeView extends StatelessWidget {
  final String userName;
  const HomeView({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo general color crema
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
        onTap: (index) {},
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
                      child: const Icon(Icons.pets,
                          size: 28, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Acciones Rápidas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              const SizedBox(height: 11),

              // Fila 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickActionCard(
                      icon: Icons.report,
                      title: 'Reportar Animal',
                      subtitle: 'En situación de calle',
                      backgroundColor: const Color(0xFFFFECEC), // Rosa pálido
                      borderColor: const Color(0xFFF28C8C), // Borde rojo claro
                      iconColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportarAnimalView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _QuickActionCard(
                      icon: Icons.card_giftcard,
                      title: 'Donar',
                      subtitle: 'Alimentos e insumos',
                      backgroundColor: const Color(0xFFEAF9EC), // Verde claro
                      borderColor: const Color(0xFF9DE7A5),
                      iconColor: Colors.green,
                      onTap: () {
                                    
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DonacionView(),
                          ),
                        );
                        
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Fila 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickActionCard(
                      icon: Icons.volunteer_activism,
                      title: 'Voluntariado',
                      subtitle: 'Únete al equipo',
                      backgroundColor: const Color(0xFFE8F1FF), // Azul pastel
                      borderColor: const Color(0xFF9CC9FF),
                      iconColor: Colors.blueAccent,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _QuickActionCard(
                      icon: Icons.home_work_outlined,
                      title: 'Casas de Paso',
                      subtitle: 'Acoge temporalmente',
                      backgroundColor: const Color(0xFFF5E9FF), // Lila claro
                      borderColor: const Color(0xFFD5B9FF), // Borde violeta
                      iconColor: Colors.purple,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Próximos Eventos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Próximos Eventos',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de tarjeta de acción rápida
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.3),
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
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
