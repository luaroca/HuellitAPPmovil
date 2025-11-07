import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/vistas/donaciones/donacion_view.dart';
import 'package:huellitas/vistas/home/home_view.dart';
import 'package:huellitas/vistas/perfil_usuario_frm/perfilusuariovista.dart';


// importa otras vistas que puedas tener para abrir desde el home

class MainNavigationView extends StatefulWidget {
  final String userName;
  const MainNavigationView({Key? key, required this.userName}) : super(key: key);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home y subpáginas
    GlobalKey<NavigatorState>(), // Adoptar (ejemplo: usando DonacionView)
    GlobalKey<NavigatorState>(), // Perfil y subpáginas
  ];

  List<Widget> _buildScreens() => [
    Navigator(
      key: _navigatorKeys[0],
      onGenerateRoute: (settings) {
        // Página principal Home y navegación interna aquí
        return MaterialPageRoute(
          builder: (context) => HomeView(userName: widget.userName),
        );
      },
    ),
    Navigator(
      key: _navigatorKeys[1],
      onGenerateRoute: (settings) {
        // Ejemplo: Vista Adoptar con navegación interna
        return MaterialPageRoute(
          builder: (context) => DonacionView(),
         
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
        !await _navigatorKeys[_currentIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_currentIndex != 0) {
        setState(() {
          _currentIndex = 0;
        });
        return false;
      }
      return true; // salir de la app
    }
    return false; // no salir porque se navegó atrás internamente
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (_currentIndex == index) {
              _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          selectedItemColor: const Color(0xFF476AE8),
          unselectedItemColor: Colors.grey,
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
