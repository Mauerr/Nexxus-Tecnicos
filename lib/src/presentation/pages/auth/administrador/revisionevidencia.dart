import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/evidenciahojalateriaadmin.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/evidenciakilometricaadmin.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/evidenciasmecanicasadmin.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeadmin.dart';

class RevisionEvidenciaAdmin extends StatelessWidget {
  const RevisionEvidenciaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo principal
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // 🔹 Contenedor principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // 🔹 Botón salir (icono superior)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: 'Cerrar sesión',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeAdmin()),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Título
                    const Center(
                      child: Text(
                        "Evidencias ##/##/####",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Campos de unidad y fecha
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Unidad
                        const Text(
                          "Unidad No. #",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Fecha
                        const Text(
                          "Fecha",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Usuario asignado
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            "Usuario Asignado",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "*Usuario*",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔹 Botones principales
                    Center(
                      child: Column(
                        children: [
                          customButton(
                            context,
                            "Evidencias Mecánicas",
                            const EvidenciasMecanicasAdmin(),
                          ),
                          const SizedBox(height: 20),
                          customButton(
                            context,
                            "Evidencias Hojalatería",
                            const EvidenciaHojalateriaAdmin(),
                          ),
                          const SizedBox(height: 20),
                          customButton(
                            context,
                            "Evidencias Kilometraje",
                            const EvidenciaKilometricaAdmin(),
                          ),
                          const SizedBox(height: 30),

                          // 🔹 Botón salir (inferior)
                          customButtonSalir(context),
                        ],
                      ),
                    ),
                  ],
                ),
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

  // 🔹 Botón "Salir"
  Widget customButtonSalir(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeAdmin()),
          );
        },
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
    );
  }
}
