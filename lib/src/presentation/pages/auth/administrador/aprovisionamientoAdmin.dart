import 'package:flutter/material.dart';
import 'barrilExportPath.dart';


class AprovisionamientoAdmin extends StatefulWidget {
  const AprovisionamientoAdmin({super.key});

  @override
  State<AprovisionamientoAdmin> createState() => _AprovisionamientoAdminState();
}

class _AprovisionamientoAdminState extends State<AprovisionamientoAdmin> {
  final AprovisionamientoCubit cubit = AprovisionamientoCubit();

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
            // 🔹 Fondo con imagen oscurecida (como en pantallas anteriores)
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

           

            // 🔹 Contenido principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Aprovisionamiento\nCableado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Cableado
                  inputLabel("Cableado"),
                  textInput(onChanged: cubit.changeCableado),

                  const SizedBox(height: 40),

                  // Fibra
                  inputLabel("Equipos Fibra"),
                  textInput(onChanged: cubit.changeFibra),

                  const SizedBox(height: 40),

                  // Radio
                  inputLabel("Equipos Radio"),
                  textInput(onChanged: cubit.changeRadio),

                  const Spacer(),

                  // Botón salir
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

  Widget textInput({required Function(String) onChanged}) {
    return TextField(
      onChanged: onChanged,
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

// Triángulo rojo decorativo
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
