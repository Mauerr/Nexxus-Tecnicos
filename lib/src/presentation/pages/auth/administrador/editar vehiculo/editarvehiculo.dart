import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';

class EditarVehiculoScreen extends StatefulWidget {
  const EditarVehiculoScreen({super.key});

  @override
  State<EditarVehiculoScreen> createState() => _EditarVehiculoScreenState();
}

class _EditarVehiculoScreenState extends State<EditarVehiculoScreen> {
  final AuthService _authService = AuthService();
  List<CarModel> _cars = [];
  CarModel? _selectedCar;
  bool _isLoading = true;

  // Controladores
  final TextEditingController _marcaCtrl = TextEditingController();
  final TextEditingController _modeloCtrl = TextEditingController();
  final TextEditingController _anioCtrl = TextEditingController();
  final TextEditingController _colorCtrl = TextEditingController();
  final TextEditingController _matriculaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      final cars = await _authService.getAllCars();
      setState(() {
        _cars = cars;
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando vehículos: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCarSelected(CarModel? car) {
    if (car == null) return;
    setState(() {
      _selectedCar = car;
      // Asignar valores a los controladores
      _modeloCtrl.text = car.model;
      _matriculaCtrl.text = car.matricula;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
            Image.asset(
              'assets/img/background13.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // Contenido
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Botón regresar
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Center(
                    child: Text(
                      "Editar Vehículo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Selector de Unidad
                  const Text(
                    "Seleccionar Unidad:",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _cars.isEmpty
                          ? const Text("No hay vehículos disponibles", style: TextStyle(color: Colors.white))
                          : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CarModel>(
                              value: _selectedCar,
                              isExpanded: true,
                              hint: const Text("Seleccione un vehículo"),
                              items: _cars.map((car) {
                                return DropdownMenuItem(
                                  value: car,
                                  child: Text(
                                    "${car.model} - ${car.matricula}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: _onCarSelected,
                            ),
                          ),
                        ),

                  const SizedBox(height: 30),

                  // Campos
                  buildCampo("Marca:", _marcaCtrl),
                  const SizedBox(height: 20),
                  buildCampo("Modelo:", _modeloCtrl),
                  const SizedBox(height: 20),
                  buildCampo("Año:", _anioCtrl),
                  const SizedBox(height: 20),
                  buildCampo("Color:", _colorCtrl),
                  const SizedBox(height: 20),
                  buildCampo("Matrícula:", _matriculaCtrl),

                  const SizedBox(height: 40),

                  // Botón Guardar (Visual)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Funcionalidad de guardar pendiente")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: const Text(
                        "Guardar Cambios",
                        style: TextStyle(fontSize: 20, color: Colors.black),
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
}