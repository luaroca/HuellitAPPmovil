import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/vistas/adopcion_mascotasfm/adopcion_mascotas_home_view.dart';
import 'package:huellitas/vistas/home/home_view.dart';
import 'package:huellitas/vistas/perfil_usuario_frm/perfilusuariovista.dart';

class MainNavigationView extends StatefulWidget {
  final String userName;
  const MainNavigationView({Key? key, required this.userName}) : super(key: key);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> _buildScreens() => [
        Navigator(
          key: _navigatorKeys[0],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => HomeView(userName: widget.userName),
            );
          },
        ),
        Navigator(
          key: _navigatorKeys[1],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => const MascotasAdopcionView(),  // Aquí carga la vista de adopción
            );
          },
        ),
        Navigator(
          key: _navigatorKeys[2],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data?.data() as Map<String, dynamic>?;
                  return PerfilUsuarioView(
                    nombre: data?['nombres'] ?? '',
                    apellido: data?['apellidos'] ?? '',
                    correo: data?['email'] ?? '',
                    telefono: data?['telefono'] ?? '',
                    esAdmin: data?['role'] == 'admin',
                  );
                },
              ),
            );
          },
        ),
      ];

  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_selectedIndex != 0) {
        _changeTab(0);
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  void _changeTab(int newIndex) {
    _navigatorKeys[_selectedIndex].currentState?.popUntil((route) => route.isFirst);
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFF00796B), 
          selectedItemColor: Colors.white, 
          unselectedItemColor: Colors.grey[300], 
          type: BottomNavigationBarType.fixed, 
          onTap: (index) {
            if (index == _selectedIndex) {
              _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
            } else {
              _changeTab(index);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Adoptar'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
