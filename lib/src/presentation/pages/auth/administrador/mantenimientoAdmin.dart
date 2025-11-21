import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'barrilExportPath.dart';

class MantenimientoAdminScreen extends StatefulWidget {
  const MantenimientoAdminScreen({super.key});

  @override
  State<MantenimientoAdminScreen> createState() =>
      _MantenimientoAdminScreenState();
}

class _MantenimientoAdminScreenState extends State<MantenimientoAdminScreen> {
  final MaintenanceCubit _cubit = MaintenanceCubit();
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Archivo cargado: $pdfName")),
      );
    }
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // 🔹 Contenido
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    const Text(
                      "MANTENIMIENTO",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ===========================
                    //   INPUT: Tipo de mantenimiento
                    // ===========================
                    _buildLabel("Tipo de mantenimiento"),
                    StreamBuilder(
                      stream: _cubit.tipoStream,
                      builder: (context, snapshot) {
                        return _buildInput(
                          onChange: _cubit.changeTipo,
                          error: snapshot.error,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ===========================
                    //   INPUT: Kilómetro Inicial
                    // ===========================
                    _buildLabel("Kilómetro Ini."),
                    StreamBuilder(
                      stream: _cubit.kmStream,
                      builder: (context, snapshot) {
                        return _buildInput(
                          onChange: _cubit.changeKm,
                          error: snapshot.error,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ===========================
                    //   INPUT: Mecánico
                    // ===========================
                    _buildLabel("Mecánico"),
                    StreamBuilder(
                      stream: _cubit.mecanicoStream,
                      builder: (context, snapshot) {
                        return _buildInput(
                          onChange: _cubit.changeMecanico,
                          error: snapshot.error,
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // ===========================
                    //   BOTÓN para cargar documento
                    // ===========================
                    const Text(
                      "Documento de mantenimiento",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cargarPDF,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Cargar PDF",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),

                    if (pdfName != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Archivo cargado: $pdfName",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],

                    const SizedBox(height: 50),

                    // ===========================
                    //   BOTÓN SALIR
                    // ===========================
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeAdmin()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          "Salir",
                          style: TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================
  //   Helpers UI
  // ===========================
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildInput({
    required Function(String) onChange,
    dynamic error,
  }) {
    return TextField(
      onChanged: onChange,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white70,
        errorText: error?.toString(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
