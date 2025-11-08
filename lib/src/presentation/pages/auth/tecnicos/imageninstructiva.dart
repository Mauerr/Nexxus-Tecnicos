import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/camScreenHojalateria.dart';


class ImagenInstructivaFrente extends StatelessWidget {
  const ImagenInstructivaFrente({super.key});

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Imagen instructiva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Image.asset(
                  'lib/assets/imginstructiva.png', // Ruta local
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
