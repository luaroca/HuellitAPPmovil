import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huellitas/controllers/mascota_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:huellitas/modelos/mascota_model.dart';

class MascotaFormView extends StatefulWidget {
  final MascotaModel? mascota;
  const MascotaFormView({Key? key, this.mascota}) : super(key: key);

  @override
  State<MascotaFormView> createState() => _MascotaFormViewState();
}

class _MascotaFormViewState extends State<MascotaFormView> {
  final _formKey = GlobalKey<FormState>();
  final MascotaController controller = Get.find();
  final nombreCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  String tipo = 'Perro';
  String genero = 'Macho';
  String tamanio = 'Mediano';
  bool vacunado = false;
  bool esterilizado = false;
  bool disponible = true;

  @override
  void initState() {
    super.initState();
    if (widget.mascota != null) {
      final m = widget.mascota!;
      nombreCtrl.text = m.nombre;
      tipo = m.tipo;
      genero = m.genero;
      tamanio = m.tamanio;
      descripcionCtrl.text = m.descripcion ?? '';
      vacunado = m.vacunado;
      esterilizado = m.esterilizado;
      disponible = m.disponible;
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.mascota != null;
      final mascota = MascotaModel(
        id: isEdit ? widget.mascota!.id : Uuid().v4(),
        nombre: nombreCtrl.text.trim(),
        tipo: tipo,
        genero: genero,
        tamanio: tamanio,
        descripcion: descripcionCtrl.text.trim(),
        vacunado: vacunado,
        esterilizado: esterilizado,
        fotoUrl: isEdit ? widget.mascota?.fotoUrl : null,
        disponible: disponible,
        casaPasoId: isEdit ? widget.mascota?.casaPasoId : null, // <-- CLAVE: nunca "" al crear
      );
      if (!isEdit) {
        await controller.agregarMascota(mascota);
        Get.back();
        Get.snackbar('Mascota registrada', 'La mascota fue registrada correctamente');
      } else {
        await controller.actualizarMascota(mascota);
        Get.back();
        Get.snackbar('Mascota actualizada', 'La mascota fue actualizada');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: Text(widget.mascota == null ? 'Agregar Nueva Mascota' : 'Editar Mascota'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sube foto opcional (futuro)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFE5C07B), width: 1.2),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.add_a_photo, color: Color(0xFFFF9800), size: 44),
                    SizedBox(height: 8),
                    Text('Haz clic para subir una foto\nJPG, PNG o GIF (máx. 5MB)', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF787878))),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre *', hintText: 'Ej: Luna', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Obligatorio' : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tipo,
                      items: const [
                        DropdownMenuItem(value: 'Perro', child: Text('🐶 Perro')),
                        DropdownMenuItem(value: 'Gato', child: Text('🐱 Gato')),
                        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                      ],
                      onChanged: (v) => setState(() => tipo = v!),
                      decoration: const InputDecoration(labelText: 'Tipo *', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: genero,
                      items: const [
                        DropdownMenuItem(value: 'Macho', child: Text('♂ Macho')),
                        DropdownMenuItem(value: 'Hembra', child: Text('♀ Hembra')),
                      ],
                      onChanged: (v) => setState(() => genero = v!),
                      decoration: const InputDecoration(labelText: 'Género *', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tamanio,
                      items: const [
                        DropdownMenuItem(value: 'Pequeño', child: Text('Pequeño')),
                        DropdownMenuItem(value: 'Mediano', child: Text('Mediano')),
                        DropdownMenuItem(value: 'Grande', child: Text('Grande')),
                      ],
                      onChanged: (v) => setState(() => tamanio = v!),
                      decoration: const InputDecoration(labelText: 'Tamaño *', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Describir temperamento y características...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 16),
              const Text('Estado de salud', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Checkbox(
                    value: vacunado,
                    onChanged: (b) => setState(() => vacunado = b ?? false),
                  ),
                  const Text('Vacunado'),
                  Checkbox(
                    value: esterilizado,
                    onChanged: (b) => setState(() => esterilizado = b ?? false),
                  ),
                  const Text('Esterilizado'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: disponible,
                    onChanged: (b) => setState(() => disponible = b ?? false),
                  ),
                  const Text('¿Disponible para adopción?'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Guardar mascota', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
