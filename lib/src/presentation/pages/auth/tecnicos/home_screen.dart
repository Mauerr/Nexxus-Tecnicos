import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/barrilExportPath.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidenciahojalateria.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidenciakilometraje.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidenciamecanica.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo principal y contenido
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bienvenido Julanito",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Unidad #",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "001 Wolvasgen",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Botones con navegación
                  Center(
                    child: Column(
                      children: [
                        customButton(
                          context,
                          "Evidencias Mecánicas",
                          const EvidenciaMecanicaScreen(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Evidencias Kilometraje",
                          const EvidenciaKilometrajeScreen(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Evidencias Hojalatería",
                          const EvidenciaHojalateriaScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Cerrar sesión',
                onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                    (Route<dynamic> route) => false, // Limpia el stack
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Botón personalizado con navegación dinámica
  Widget customButton(BuildContext context, String text, Widget destination) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
