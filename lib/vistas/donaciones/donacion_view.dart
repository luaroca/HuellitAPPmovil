import 'package:flutter/material.dart';

class DonacionView extends StatelessWidget {
  const DonacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController direccionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'Donar Alimentos o Insumos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(22),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tu donación ayuda a cuidar a los peluditos rescatados',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 15, 14, 16),
        child: Column(
          children: [
            // Datos principales del donante
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nombre Completo *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Teléfono de Contacto *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "+57 300 123 4567",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Detalles de la donación
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "¿Qué deseas donar? *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Ej: Alimento para perros, Mantas, Medicamentos...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dirección y notas, con botón GPS o manual
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dirección para Recogida *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: direccionController,
                      decoration: InputDecoration(
                        hintText: "Dirección completa",
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[300]!),
                        ),
                        icon: Icon(Icons.gps_fixed),
                        label: Text('Usar mi ubicación GPS'),
                        onPressed: () {
                          // TODO: lógica para capturar ubicación GPS y llenar el campo
                          // Ejemplo: direccionController.text = "Ubicación detectada...";
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Notas Adicionales",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            "Horarios disponibles, instrucciones especiales...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Botones finales
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.grey[100],
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text('Cancelar'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: lógica para enviar donación
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Enviar Donación',
                      style: TextStyle(
                        color: const Color.fromARGB(233, 39, 15, 15),
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
