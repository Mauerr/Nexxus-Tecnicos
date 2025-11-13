import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/camScreenHojalateria.dart';

class ImagenInstructivaReverso extends StatelessWidget {
  const ImagenInstructivaReverso({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PantallaCamaraHojalateria()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), // 👈 Mantiene margen lateral
            child: Column(
              children: [
                const SizedBox(height: 10),

                const Text(
                  'Imagen instructiva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // 🔹 Imagen ocupando máximo espacio y centrada
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 1.0, // 👈 Se expande a todo el ancho disponible
                      child: Image.asset(
                        'lib/assets/reverso.png',
                        fit: BoxFit.contain, // Mantiene proporción sin recorte
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
