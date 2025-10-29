import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/auth_controller.dart';
import 'widget_home_body.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Adoptar'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
        currentIndex: 0,
        onTap: (index) async {
          if (index == 2) {
            final user = authController.auth.currentUser;
            if (user != null) {
              final doc = await authController.firestore.collection('users').doc(user.uid).get();
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
        child: HomeBody(userName: userName),
      ),
    );
  }
}
