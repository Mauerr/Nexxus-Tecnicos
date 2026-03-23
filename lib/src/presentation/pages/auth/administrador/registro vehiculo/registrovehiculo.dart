import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
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
  // Controladores renombrados para coincidir con su función real
  final TextEditingController _marcaCtrl = TextEditingController();
  final TextEditingController _modeloCtrl = TextEditingController();
  final TextEditingController _yearCtrl = TextEditingController();
  final TextEditingController _fechaAdqCtrl = TextEditingController();
  final TextEditingController _colorCtrl = TextEditingController();
  final TextEditingController _matriculaCtrl = TextEditingController();

  void _clearForm() {
    setState(() {
      _marcaCtrl.clear();
      _modeloCtrl.clear();
      _yearCtrl.clear();
      _fechaAdqCtrl.clear();
      _colorCtrl.clear();
      _matriculaCtrl.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistroVehiculoCubit(AuthService())..loadCars(),
      child: BlocListener<RegistroVehiculoCubit, RegistroVehiculoState>(
        listener: (context, state) {
          if (state is RegistroVehiculoLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          } else if (state is RegistroVehiculoActionSuccess) {
            Navigator.pop(context); // Cerrar loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            _clearForm();
          } else if (state is RegistroVehiculoLoaded) {
            // Ya no hacemos pop aquí. La lista se actualiza automáticamente gracias al BlocBuilder.
            // Esto evita que se cierre la pantalla al entrar.
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

                      // Header con botón salir
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeAdmin()),
                            ),
                          ),
                          const Text(
                            "Gestión de Vehículos",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 40), // Balancear espacio
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Título de Sección: Formulario
                      const Text(
                        "Nueva Unidad",
                        style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // 🔹 Campos del Formulario
                      buildCampo("Marca:", _marcaCtrl),
                      const SizedBox(height: 15),
                      buildCampo("Modelo:", _modeloCtrl),
                      const SizedBox(height: 15),
                      buildCampo("Año:", _yearCtrl, isNumber: true),
                      const SizedBox(height: 15),
                      buildCampo("Fecha de adquisición (Opcional):", _fechaAdqCtrl, hint: "YYYY-MM-DD"),
                      const SizedBox(height: 15),
                      buildCampo("Color:", _colorCtrl),
                      const SizedBox(height: 15),
                      buildCampo("Matrícula:", _matriculaCtrl),
                      
                      const SizedBox(height: 30),

                      // 🔹 Botones de Acción
                      Builder(
                        builder: (context) {
                          final cubit = context.read<RegistroVehiculoCubit>();
                          return customButton(
                            context,
                            "Guardar Unidad",
                            Colors.white,
                            Colors.black,
                            () {
                              cubit.registrarVehiculo(
                                marca: _marcaCtrl.text,
                                modelo: _modeloCtrl.text,
                                yearStr: _yearCtrl.text,
                                fechaAdq: _fechaAdqCtrl.text,
                                color: _colorCtrl.text,
                                matricula: _matriculaCtrl.text,
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),

                      // 🔹 Lista de Unidades Existentes
                      const Text(
                        "Unidades Registradas",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      BlocBuilder<RegistroVehiculoCubit, RegistroVehiculoState>(
                        buildWhen: (previous, current) => current is RegistroVehiculoLoaded,
                        builder: (context, state) {
                          if (state is RegistroVehiculoLoaded) {
                            if (state.cars.isEmpty) {
                              return const Center(child: Text("No hay unidades registradas", style: TextStyle(color: Colors.white54)));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.cars.length,
                              itemBuilder: (context, index) {
                                final car = state.cars[index];                                
                                
                                return Card(
                                  color: Colors.white.withOpacity(0.1),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "${car.marca} ${car.model} (${car.year})",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Matrícula: ${car.matricula} - Color: ${car.color}",
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        },
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
  Widget buildCampo(String label, TextEditingController controller, {bool isNumber = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Botón estilizado Nexxus
  Widget customButton(BuildContext context, String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
