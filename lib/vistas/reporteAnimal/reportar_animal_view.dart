import 'package:flutter/material.dart';

class ReportarAnimalView extends StatelessWidget {
  const ReportarAnimalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'Reportar Animal en Calle',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(22.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ayúdanos a rescatar animales en necesidad',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14, 15, 14, 16),
        child: Column(
          children: [
            // Ubicación del Animal
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
                    Row(
                      children: [
                        Text(
                          "Ubicación del Animal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.location_on, color: Colors.redAccent),
                      ],
                    ),
                    SizedBox(height: 9),
                    Text(
                      "Dirección o punto de referencia *",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Ej: Calle 45 # 23-15, cerca del parque...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 11, horizontal: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[700],
                          side: BorderSide(color: Colors.red[300]!),
                        ),
                        icon: Icon(Icons.gps_fixed),
                        label: Text('Usar mi ubicación GPS'),
                        onPressed: () {
                          // TODO: lógica de GPS
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fotos del Animal (sin descripción de límite)
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
                    Row(
                      children: [
                        Text(
                          "Fotos del Animal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.photo_camera, color: Colors.redAccent),
                      ],
                    ),
                    SizedBox(height: 9),
                    // Widget para subir foto
                    GestureDetector(
                      onTap: () {
                        // TODO: lógica para cargar foto
                      },
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                            color: Colors.red[100]!,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Subir foto',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Información del Animal
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.only(bottom: 18),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Información del Animal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 13),
                    Text(
                      "Descripción del Animal *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 7),
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            "Describe al animal: tamaño, color, raza aproximada, características distintivas...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12,
                        ),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 13),
                    Text(
                      "Estado y Condición *",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 7),
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            "¿Está herido? ¿Asustado? ¿Hambriento? ¿Hay alguna urgencia? Describe la situación...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12,
                        ),
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
                      // TODO: lógica para enviar reporte
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Enviar Reporte',
                      style: TextStyle(color: Colors.black,
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
