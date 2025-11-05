import 'package:flutter/material.dart';

class PantallaCamara extends StatelessWidget {
  const PantallaCamara({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Regresa a la pantalla anterior
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset(
            'lib/assets/cam.png', // Asegúrate de colocar aquí la ruta correcta
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
