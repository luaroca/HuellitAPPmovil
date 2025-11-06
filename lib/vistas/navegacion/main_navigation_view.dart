import 'package:flutter/material.dart';
import 'package:huellitas/vistas/home/home_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/vistas/perfil_usuario_frm/perfilusuariovista.dart';

class MainNavigationView extends StatefulWidget {
  final String userName;
  const MainNavigationView({Key? key, required this.userName}) : super(key: key);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeView(userName: widget.userName),
      const Placeholder(), // Aquí estará la vista de Adoptar cuando la tengas
      _buildPerfilView(),
    ];
  }

  Widget _buildPerfilView() {
    return FutureBuilder<DocumentSnapshot>(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF476AE8),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Adoptar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
