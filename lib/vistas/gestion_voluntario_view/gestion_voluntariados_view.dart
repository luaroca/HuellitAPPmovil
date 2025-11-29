// gestion_voluntariados_admin_view.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget_gestion_voluntariados.dart';

class GestionVoluntariadosAdminView extends StatefulWidget {
  const GestionVoluntariadosAdminView({Key? key}) : super(key: key);

  @override
  State<GestionVoluntariadosAdminView> createState() =>
      _GestionVoluntariadosAdminViewState();
}

class _GestionVoluntariadosAdminViewState
    extends State<GestionVoluntariadosAdminView> {
  String? filtroDia;
  String? filtroInteres;

  final diasSemana = const [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábados',
    'Domingos'
  ];

  final intereses = const [
    'Rescates',
    'Jornadas de adopción',
    'Esterilización',
    'Alimentación',
    'Redes sociales',
    'Eventos y campañas'
  ];

  @override
  Widget build(BuildContext context) {
    return WidgetGestionVoluntariados(
      filtroDia: filtroDia,
      filtroInteres: filtroInteres,
      diasSemana: diasSemana,
      intereses: intereses,
      onFiltroDiaChanged: (v) {
        setState(() => filtroDia = v == "Todos" ? null : v);
      },
      onFiltroInteresChanged: (v) {
        setState(() => filtroInteres = v == "Todas" ? null : v);
      },
      streamVoluntarios: FirebaseFirestore.instance
          .collection('voluntarios')
          .orderBy('nombre')
          .snapshots(),
    );
  }
}
