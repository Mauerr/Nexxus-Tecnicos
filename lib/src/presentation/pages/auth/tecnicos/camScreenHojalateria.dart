import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciahojalateria.dart';

class PantallaCamaraHojalateria extends StatelessWidget {
  const PantallaCamaraHojalateria({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EvidenciaHojalateriaScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset(
            'lib/assets/cam.png', // Asegúrate de tener la imagen en esta ruta
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
