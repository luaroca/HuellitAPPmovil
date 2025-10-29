import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huellitas/modelos/voluntario_model.dart';
import 'package:huellitas/servicios/voluntario_service.dart';
import 'package:huellitas/vistas/voluntariado_view_user/registro_voluntario_view.dart'; 

class VoluntariadoHomeView extends StatefulWidget {
  const VoluntariadoHomeView({Key? key}) : super(key: key);

  @override
  State<VoluntariadoHomeView> createState() => _VoluntariadoHomeViewState();
}

class _VoluntariadoHomeViewState extends State<VoluntariadoHomeView> {
  VoluntarioModel? voluntario;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      voluntario = await VoluntarioService.obtenerPorCorreo(user.email ?? '');
    }
    setState(() => loading = false);
  }

  void registrarVoluntario() async {
    await Get.to(() => const RegistroVoluntarioView());
    await cargar();
  }

  Future<void> eliminarVoluntarioConfirmado() async {
    if (voluntario != null) {
      await VoluntarioService.eliminarPorId(voluntario!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Te has retirado exitosamente del voluntariado')),
        );
        await cargar();
      }
    }
  }

  void confirmarEliminarVoluntario() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Retirarse del Voluntariado',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          '¿Seguro que deseas retirarte como voluntario?',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(fontSize: 17)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Retirarme', style: TextStyle(fontSize: 17)),
            onPressed: () async {
              Navigator.pop(context);
              await eliminarVoluntarioConfirmado();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF476AE8),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Voluntariado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF476AE8)))
          : voluntario == null
              ? _noVoluntarioWidget()
              : _voluntarioCardWidget(),
    );
  }

  /// Vista cuando el usuario no es voluntario
  Widget _noVoluntarioWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism, size: 90, color: Colors.blue[400]),
            const SizedBox(height: 25),
            const Text(
              'Aún no te has registrado como voluntario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add_alt, size: 26),
              label: const Text(
                'Registrarme como Voluntario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF476AE8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              onPressed: registrarVoluntario,
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta con los datos del voluntario registrado
  Widget _voluntarioCardWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volunteer_activism, color: Color(0xFF476AE8), size: 34),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        voluntario!.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 10),
                _infoRow(Icons.email_outlined, 'Correo', voluntario!.correo),
                _infoRow(Icons.phone, 'Teléfono', voluntario!.telefono.isEmpty ? '-' : voluntario!.telefono),
                _infoRow(Icons.calendar_today, 'Días disponibles', voluntario!.dias.join(', ')),
                _infoRow(Icons.access_time, 'Horario disponible', voluntario!.horario),
                _infoRow(Icons.category, 'Áreas de Interés', voluntario!.intereses.join(', ')),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    onPressed: confirmarEliminarVoluntario,
                    icon: const Icon(Icons.logout, size: 22),
                    label: const Text('Retirarse', style: TextStyle(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fila informativa con ícono + texto grande y legible
  Widget _infoRow(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF476AE8), size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: valor,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
