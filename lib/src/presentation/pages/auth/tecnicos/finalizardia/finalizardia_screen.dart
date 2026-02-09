import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/evidenciakilometraje.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';

class FinalizarDiaScreen extends StatefulWidget {
  const FinalizarDiaScreen({super.key});

  @override
  State<FinalizarDiaScreen> createState() => _FinalizarDiaScreenState();
}

class _FinalizarDiaScreenState extends State<FinalizarDiaScreen> {
  CarModel? assignedCar;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignedCar();
  }

  Future<void> _loadAssignedCar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? carId = prefs.getInt("assigned_car_id");

      if (carId != null) {
        // Obtenemos todos los carros y buscamos el asignado
        final cars = await AuthService().getAllCars();
        try {
          final car = cars.firstWhere((c) => c.id == carId);
          if (mounted) {
            setState(() {
              assignedCar = car;
              isLoading = false;
            });
          }
        } catch (e) {
          // Si no se encuentra el carro en la lista
          if (mounted) setState(() => isLoading = false);
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo de pantalla
            Image.asset(
              'assets/img/background13.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Botón de regreso
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Elige una opción",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Unidad Asignada",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  // Tarjeta de Unidad Asignada
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading
                        ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                        : Text(
                            assignedCar?.label ?? "Sin unidad asignada",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),

                  const SizedBox(height: 60),

                  // Botón Finalizar Día
                  _buildMenuButton(
                    context,
                    "Evidencias Kilometraje Final",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => EvidenciaKilometrajeCubit(),
                            child: const EvidenciaKilometrajeScreen(isEndDay: true),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Botón Ir a Casa
                  _buildMenuButton(
                    context,
                    "Ir a casa",
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Opción Ir a casa seleccionada")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}