import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huellitas/modelos/casa_paso_model.dart';
import 'package:huellitas/modelos/mascota_model.dart';
import 'asignar_mascota_widget.dart';

class AsignarMascotaView extends StatefulWidget {
  final CasaPasoModel casaDePaso;
  const AsignarMascotaView({Key? key, required this.casaDePaso})
      : super(key: key);

  @override
  State<AsignarMascotaView> createState() => _AsignarMascotaViewState();
}

class _AsignarMascotaViewState extends State<AsignarMascotaView> {
  String? selectedMascotaId;
  List<MascotaModel> mascotas = [];
  DateTime? fechaIngreso;
  DateTime? fechaSalida;
  TimeOfDay? horaSalida;
  bool loading = false;
  String? errorMsg;

  Future<void> _cargarMascotas() async {
    final snap = await FirebaseFirestore.instance
        .collection('mascotas')
        .where('disponible', isEqualTo: false)
        .get();

    setState(() {
      mascotas = snap.docs
          .where((e) =>
              !e.data().containsKey('casaPasoId') ||
              e.get('casaPasoId') == null ||
              (e.get('casaPasoId') is String && e.get('casaPasoId').isEmpty))
          .map((e) => MascotaModel.fromMap({...e.data(), 'id': e.id}))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarMascotas();
  }

  @override
  Widget build(BuildContext context) {
    return AsignarMascotaWidget(
      mascotas: mascotas,
      selectedMascotaId: selectedMascotaId,
      fechaIngreso: fechaIngreso,
      fechaSalida: fechaSalida,
      horaSalida: horaSalida,
      loading: loading,
      errorMsg: errorMsg,

      onMascotaChanged: (id) {
        setState(() => selectedMascotaId = id);
      },

      onSelectFechaIngreso: (fecha) {
        setState(() => fechaIngreso = fecha);
      },

      onSelectFechaSalida: (fecha, hora) {
        setState(() {
          fechaSalida = fecha;
          horaSalida = hora;
        });
      },

      onAsignar: () async {
        setState(() {
          errorMsg = null;
          loading = true;
        });

        if (selectedMascotaId == null ||
            fechaIngreso == null ||
            fechaSalida == null ||
            horaSalida == null) {
          setState(() {
            errorMsg = "Seleccione mascota, fecha de ingreso y salida.";
            loading = false;
          });
          return;
        }

        final fechaSalidaCompleta = DateTime(
          fechaSalida!.year,
          fechaSalida!.month,
          fechaSalida!.day,
          horaSalida!.hour,
          horaSalida!.minute,
        );

        await FirebaseFirestore.instance
            .collection('mascotas')
            .doc(selectedMascotaId!)
            .update({
          'casaPasoId': widget.casaDePaso.id,
          'disponible': false,
          'fechaIngresoCasa': Timestamp.fromDate(fechaIngreso!),
          'fechaSalidaCasa': Timestamp.fromDate(fechaSalidaCompleta),
        });

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mascota asignada correctamente')),
          );
        }
      },
    );
  }
}
