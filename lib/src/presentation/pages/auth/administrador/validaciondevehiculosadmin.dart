import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeadmin.dart';

class ValidacionVehiculosAdmin extends StatefulWidget {
  const ValidacionVehiculosAdmin({super.key});

  @override
  State<ValidacionVehiculosAdmin> createState() =>
      _ValidacionVehiculosAdminState();
}

class _ValidacionVehiculosAdminState extends State<ValidacionVehiculosAdmin> {
  // Controladores para los campos (puedes conectarlos al BLoC después)
  final TextEditingController unidadCtrl = TextEditingController();
  final TextEditingController fechaCtrl = TextEditingController();
  final TextEditingController matriculaCtrl = TextEditingController();
  final TextEditingController modeloCtrl = TextEditingController();
  final TextEditingController marcaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo
            Image.asset(
              'assets/img/background13.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // 🔹 Contenido
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Botón salir
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Salir',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeAdmin(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Título
                  const Center(
                    child: Text(
                      "Validación de vehículos",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Campos reales
                  buildCampo("Unidad:", unidadCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Fecha Adq:", fechaCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Matrícula:", matriculaCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Modelo:", modeloCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Marca:", marcaCtrl),
                  const SizedBox(height: 40),

                  // Botones principales
                  customButton(
                    context,
                    "Evidencia Fotográfica",
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Abriendo evidencia fotográfica...")),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  customButton(
                    context,
                    "Documentación",
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Abriendo documentación...")),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Botón salir
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeAdmin()),
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
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 TextField con estilo Nexxus
  Widget buildCampo(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Botón estilizado Nexxus
  Widget customButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
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
}
