import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/camScreen.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/imageninstructiva.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/imageninstructivader.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/imageninstructivaizq.dart';


class EvidenciaHojalateriaScreen extends StatelessWidget {
  const EvidenciaHojalateriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // Contenido
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Regresar',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Text(
                    "Evidencia de Hojalateria",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildMainButton(context, "Frente"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Lateral Izquierdo"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Lateral Derecho"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Reverso"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Frente Angulo Izquierdo"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Frente Angulo Derecho"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Reverso Angulo Izquierdo"),
                          const SizedBox(height: 20),
                          _buildMainButton(context, "Reverso Angulo Derecho"),
                          const SizedBox(height: 40),

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

  // 🔹 Botón principal con navegación condicional
  Widget _buildMainButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Widget screen;

          switch (text) {
            case "Frente":
              screen = const ImagenInstructivaFrente();
              break;
            case "Lateral Izquierdo":
              screen = const ImagenInstructivaIzquierdo();
              break;
            case "Lateral Derecho":
              screen = const ImagenInstructivaDerecho();
              break;
            case "Reverso":
              screen = const ImagenInstructivaFrente();
              break;
            default:
              screen = const PantallaCamara();
          }

          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
