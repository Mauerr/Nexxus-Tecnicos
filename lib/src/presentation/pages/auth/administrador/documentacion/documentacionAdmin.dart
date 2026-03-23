import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../barrilExportPath.dart';


class ArchivosVehiculoAdmin extends StatefulWidget {
  const ArchivosVehiculoAdmin({super.key});

  @override
  State<ArchivosVehiculoAdmin> createState() => _ArchivosVehiculoAdminState();
}

class _ArchivosVehiculoAdminState extends State<ArchivosVehiculoAdmin> {
  String? pdfName;

  Future<void> cargarPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 Fondo con imagen oscurecida
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            /// 🔹 Contenido principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 🔹 Título
                  const Text(
                    "Archivos del vehículo",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 Íconos de documentos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.insert_drive_file,
                          size: 48, color: Colors.white),
                      SizedBox(width: 40),
                      Icon(Icons.insert_drive_file,
                          size: 48, color: Colors.white),
                      SizedBox(width: 40),
                      Icon(Icons.insert_drive_file,
                          size: 48, color: Colors.white),
                    ],
                  ),

                  const SizedBox(height: 50),

                  /// 🔹 Botón cargar documentación + botón datos del vehículo (customButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Botón cargar PDF
                      Expanded(
                        child: ElevatedButton(
                          onPressed: cargarPDF,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Cargar documentación",
                            style: TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      /// 🟦 MODIFICADO → customButton
                      Expanded(
                        child: customButton(
                          context,
                          "Ir a datos del vehículo",
                          const ValidacionVehiculosAdmin(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 Mostrar nombre del PDF cargado
                  if (pdfName != null) ...[
                    const Text(
                      "Archivo cargado:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pdfName!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const Spacer(),

                  /// 🔹 Botón salir
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OpcionesCarroAdmin(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Salir",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 CustomButton estandarizado
  Widget customButton(BuildContext context, String text, Widget destination) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
