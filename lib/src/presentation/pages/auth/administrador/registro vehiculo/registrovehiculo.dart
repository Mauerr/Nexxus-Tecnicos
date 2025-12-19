import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../barrilExportPath.dart';
import 'registrovehiculo_cubit.dart';
import 'registrovehiculo_state.dart';

class RegistroVehiculosAdmin extends StatefulWidget {
  const RegistroVehiculosAdmin({super.key});

  @override
  State<RegistroVehiculosAdmin> createState() =>
      _RegistroVehiculosAdminState();
}

class _RegistroVehiculosAdminState extends State<RegistroVehiculosAdmin> {
  // Controladores para los campos (puedes conectarlos al BLoC después)
  final TextEditingController unidadCtrl = TextEditingController();
  final TextEditingController fechaCtrl = TextEditingController();
  final TextEditingController matriculaCtrl = TextEditingController();
  final TextEditingController modeloCtrl = TextEditingController();
  final TextEditingController marcaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistroVehiculoCubit(AuthService()),
      child: BlocListener<RegistroVehiculoCubit, RegistroVehiculoState>(
        listener: (context, state) {
          if (state is RegistroVehiculoLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegistroVehiculoSuccess) {
            Navigator.pop(context); // Cerrar loading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unidad guardada con éxito")),
            );
            // Navegar a HomeAdmin
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeAdmin(),
              ),
            );
          } else if (state is RegistroVehiculoError) {
            Navigator.pop(context); // Cerrar loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
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
                      "Registro de vehículos",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Campos reales
                  buildCampo("Marca:", unidadCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Modelo:", fechaCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Año:", matriculaCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Color:", modeloCtrl),
                  const SizedBox(height: 20),

                  buildCampo("Matricula:", marcaCtrl),
                  const SizedBox(height: 40),

                  // Botones principales
                  // Botones principales
                  Builder(
                    builder: (context) {
                      return customButton(
                        context,
                        "Guardar",
                        () {
                          context.read<RegistroVehiculoCubit>().registrarVehiculo(
                            marca: unidadCtrl.text,      // Label: Marca
                            modelo: fechaCtrl.text,      // Label: Modelo
                            yearStr: matriculaCtrl.text, // Label: Año
                            color: modeloCtrl.text,      // Label: Color
                            matricula: marcaCtrl.text,   // Label: Matricula
                          );
                        },
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
