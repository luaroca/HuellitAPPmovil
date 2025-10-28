import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:huellitas/vistas/adminHome/admin_home_view.dart';
import 'package:huellitas/vistas/gestiondonacionform/gestion_donativos_view.dart';
import 'package:huellitas/vistas/gestioneventosform/evento_form_view.dart';
import 'package:huellitas/vistas/gestioneventosform/gestion_eventos_wiew.dart';
import 'package:huellitas/vistas/home/home_view.dart';
import 'package:huellitas/vistas/loginform/login.dart';
import 'package:huellitas/vistas/perfilusuariofrm/perfilusuariovista.dart';


import 'controllers/auth_controller.dart';
import 'vistas/registrofm/register.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Huellitas',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(
          name: '/userHome',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return HomeView(userName: args['userName'] ?? 'Usuario');
          },
        ),
        GetPage(
          name: '/adminHome',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return AdminHomeView(adminName: args['adminName'] ?? 'Admin');
          },
        ),
        GetPage(
          name: '/userProfile',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return PerfilUsuarioView(
              nombre: args['nombre'] ?? '',
              correo: args['correo'] ?? '',
              telefono: args['telefono'] ?? '',
              esAdmin: args['esAdmin'] == true,
            );
          },
        ),
        GetPage(
          name: '/gestionEventos',
          page: () => const GestionEventosView(),
        ),
        GetPage(
          name: '/crearEvento',
          page: () => EventoFormView(), // Formulario en blanco para crear
        ),
        GetPage(
          name: '/editarEvento',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return EventoFormView(
              id: args['id'],
              initialData: args,
            );
          },
        ),
        GetPage(
          name: '/gestionDonativos',
         page: () => GestionDonativosView(),
        ),  
      ],
    );
  }
}
