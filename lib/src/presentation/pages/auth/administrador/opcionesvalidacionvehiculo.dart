import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/validaciondevehiculosadmin.dart';


class OpcionesCarroAdmin extends StatelessWidget {
  const OpcionesCarroAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // CONTENIDO PRINCIPAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "Elige una opción",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🔹 BOTÓN DATOS DEL CARRO (AQUÍ SE HACE LA MODIFICACIÓN)
                  customButton(
                    context,
                    "Datos del carro",
                    const ValidacionVehiculosAdmin(),   // ← AQUI SE CAMBIÓ
                  ),

                  const SizedBox(height: 20),

                  // 🔹 BOTÓN DOCUMENTACIÓN (Se queda igual)
                  customButton(
                    context,
                    "Documentación",
                    const Placeholder(), // Sustituye tu pantalla real
                  ),

                  const SizedBox(height: 40),

                  // 🔹 BOTÓN SALIR
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Salir",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Botón reutilizable
  Widget customButton(BuildContext context, String text, Widget screen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
