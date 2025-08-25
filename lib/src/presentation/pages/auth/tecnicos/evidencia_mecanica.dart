import 'package:flutter/material.dart';

class EvidenciaMecanicaScreen extends StatelessWidget {
  const EvidenciaMecanicaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        
        child: Center(
          child: Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Evidencias Mecánicas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Botones grandes
                customButton(context, "Aceite de motor"),
                const SizedBox(height: 20),
                customButton(context, "Líquido de Frenos"),
                const SizedBox(height: 20),
                customButton(context, "Anticongelante"),
                const SizedBox(height: 20),
                customButton(context, "Etc."),
                const SizedBox(height: 40),

                // Botón Validar (más pequeño)
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D9D9),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Validar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Ahora recibe el contexto
  Widget customButton(BuildContext context, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
