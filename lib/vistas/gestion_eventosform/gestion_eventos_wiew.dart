import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'widget_gestion_eventos.dart';

class GestionEventosView extends StatelessWidget {
  const GestionEventosView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventosRef = FirebaseFirestore.instance.collection('eventos');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Eventos y Avisos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFFAE35),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFA8E6CF),

      body: StreamBuilder<QuerySnapshot>(
        stream: eventosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFAE35)),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          int total = docs.length;
          int publicados = docs.where((e) => (e['publico'] ?? false)).length;

          return WidgetGestionEventos(
            docs: docs,
            total: total,
            publicados: publicados,
          );
        },
      ),
    );
  }
}
