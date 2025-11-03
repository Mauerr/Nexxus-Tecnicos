import 'package:flutter/material.dart';


class EvidenciaMecanicaScreen extends StatelessWidget {
  const EvidenciaMecanicaScreen({super.key});

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
                    "Evidencia Mecanica",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                
                  const SizedBox(height: 60),

                  // Botones con navegación
                  Center(
                    child: Column(
                      children: [
                        Container(
                          child: customButton(context, "Aceite de motor")
                          ),
                          const SizedBox(height: 20), 
                          customButton(context, "Liquidos de Frenos"), 
                          const SizedBox(height: 20), 
                          customButton(context, "Anticogelante"),
                          const SizedBox(height: 20), 
                          customButton(context, "Etc"),
                          const SizedBox(height: 20), 
                          customButton(context, "Validar"),
                          
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
                tooltip: 'Regresar',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Botón personalizado con navegación dinámica
  Widget customButton(BuildContext context, String text) { 
    return SizedBox( 
      width: double.infinity, 
      child: ElevatedButton( 
        onPressed: () {}, 
        style: ElevatedButton.styleFrom( 
          backgroundColor: const Color(0xFFD9D9D9), 
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20), ), 
          padding: const EdgeInsets.symmetric(vertical: 20), ), 
          child: Text( text, style: const TextStyle(fontSize: 20, color: Colors.black), 
        ), 
      ), 
    );
  } 
}