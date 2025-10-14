import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modelos/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Rxn<User> user = Rxn<User>();
  final RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(auth.authStateChanges());
    ever(user, fetchUserRole);
  }

  Future<void> fetchUserRole(User? firebaseUser) async {
    if (firebaseUser == null) {
      isAdmin.value = false;
      return;
    }
    try {
      final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists && doc.data()?['role'] == "admin") {
        isAdmin.value = true;
      } else {
        isAdmin.value = false;
      }
    } catch (e) {
      isAdmin.value = false;
    }
  }

Future<void> login(String email, String password) async {
  try {
    final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = credential.user?.uid;
    if (uid != null) {
      final doc = await firestore.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        final nombreUsuario = data['nombres'] ?? 'Usuario';
        final role = data['role'] ?? 'user';
        if (role == 'admin') {
          Get.offAllNamed('/adminHome');
        } else {
          Get.offAllNamed('/userHome', arguments: {'userName': nombreUsuario});
        }
      } else {
        Get.snackbar('Error', 'El usuario no tiene datos.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  } on FirebaseAuthException catch (e) {
    Get.snackbar('Error de Login', e.message ?? 'Ocurrió un error',
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}


Future<void> register({
  required String email,
  required String password,
  required String nombres,
  required String apellidos,
  required String telefono,
}) async {
  try {
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      // Aquí defines el modelo UserModel según tu estructura
      final userDoc = {
        'uid': userCredential.user!.uid,
        'email': email,
        'nombres': nombres,
        'apellidos': apellidos,
        'telefono': telefono,
        'role': 'user',
      };
      await firestore.collection('users').doc(userCredential.user!.uid).set(userDoc);
      Get.snackbar('Éxito', 'Cuenta creada correctamente',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed('/login'); // Navega al login después de registrar
    }
  } on FirebaseAuthException catch (e) {
    Get.snackbar('Error de registro', e.message ?? 'Ocurrió un error',
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed('/login');
  }
}
