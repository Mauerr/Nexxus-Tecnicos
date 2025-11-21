import 'package:flutter/material.dart';
import 'barrilExportPath.dart';


class AsignacionRutasAdmin extends StatefulWidget {
  const AsignacionRutasAdmin({super.key});

  @override
  State<AsignacionRutasAdmin> createState() => _AsignacionRutasAdminState();
}

class _AsignacionRutasAdminState extends State<AsignacionRutasAdmin> {
  final AsignacionRutasCubit cubit = AsignacionRutasCubit();

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo con imagen oscurecida
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // 🔹 Contenido
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Asignación de rutas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Campo RUTA
                  inputLabel("Ruta"),
                  textInput(onChanged: cubit.changeRuta),

                  const SizedBox(height: 40),

                  // Campo OBSERVACIONES
                  inputLabel("Observaciones"),
                  textInput(
                    onChanged: cubit.changeObservaciones,
                    maxLines: 3,
                  ),

                  const Spacer(),

                  // Botón Salir
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeAdmin()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Salir",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // Widgets reutilizables
  // -----------------------------

  Widget inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),
    );
  }

  Widget textInput({
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD9D9D9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}

