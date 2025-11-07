import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isSwitchingTab = false;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Adoptar
    GlobalKey<NavigatorState>(), // Perfil
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
              builder: (_) => const Scaffold(
                body: Center(child: Text('Adoptar próximamente')),
              ),
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
    setState(() {
      _isSwitchingTab = true; // ocultar stack para evitar parpadeo
      _selectedIndex = newIndex;
    });
    // Resetea el stack después de que se haya renderizado la nueva pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKeys[newIndex].currentState?.popUntil((route) => route.isFirst);
      setState(() {
        _isSwitchingTab = false; // muestra el stack ya limpio
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _isSwitchingTab
            // Cuando se está cambiando pestaña, mostrar pantalla vacía para evitar parpadeo
            ? Container(color: Colors.white)
            : IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (_selectedIndex == index) {
              // Si ya estaba en la misma pestaña, resetea su stack
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
          selectedItemColor: const Color(0xFF476AE8),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
