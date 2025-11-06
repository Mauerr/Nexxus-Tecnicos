import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/camScreen.dart';


class EvidenciaKilometrajeScreen extends StatelessWidget {
  const EvidenciaKilometrajeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo principal
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // Contenido principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Botón regresar
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Regresar',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Título centrado
                  const Text(
                    "Evidencia de Kilometraje",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Botones principales
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botones de navegación
                          _buildMainButton(context, "KM inicio del día"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "KM fin del día"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Asientos delanteros"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Asientos traseros"),
                          const SizedBox(height: 40),

                          // 🔹 Botón “Validar”
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: _buildValidateButton(context),
                            ),
                          ),
                        ],
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

  // 🔹 Botón principal que navega a la cámara
  Widget _buildMainButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PantallaCamara()),
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

  // 🔹 Botón “Validar”
  Widget _buildValidateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Validando evidencias...')),
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
        "Validar",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}
