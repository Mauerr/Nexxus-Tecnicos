import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../barrilExportPath.dart';
import 'mantenimiento_car_cubit.dart';
import 'mantenimiento_car_state.dart';

class MantenimientoAdminScreen extends StatefulWidget {
  const MantenimientoAdminScreen({super.key});

  @override
  State<MantenimientoAdminScreen> createState() =>
      _MantenimientoAdminScreenState();
}

class _MantenimientoAdminScreenState extends State<MantenimientoAdminScreen> {
  final MaintenanceCubit _cubit = MaintenanceCubit();
  File? _selectedImage;
  bool _vehiculoBloqueado = false;
  bool _isSending = false;
  
  // Variables para Edición y Historial
  List<dynamic> _maintenanceHistory = [];
  int? _editingId; // Si es null, estamos creando. Si tiene valor, editando.
  String? _existingImageUrl; // Para mostrar la foto que viene del backend

  // Controladores para capturar el texto
  final TextEditingController _kmCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  // Variables para los selectores
  String? _selectedTipo;
  String? _selectedMecanico;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _cubit.dispose();
    _kmCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // 🔹 Cargar historial del carro seleccionado
  Future<void> _loadHistory(int carId) async {
    setState(() => _isSending = true);
    final history = await AuthService().getMaintenancesByCar(carId);
    setState(() {
      _maintenanceHistory = history;
      _isSending = false;
    });
  }

  // 🔹 Poner formulario en modo edición
  void _startEditing(Map<String, dynamic> item) {
    setState(() {
      _editingId = item['id'];
      _kmCtrl.text = item['kilometros'].toString();
      _notesCtrl.text = item['notes'] ?? '';
      _selectedTipo = item['type_maintenance'];
      // Asegurarse que el valor coincida con los del Dropdown, si no, dejar null o manejar error
      final mecanico = item['mecanico']; // Ajuste: JSON trae 'mecanico'
      if (mecanico == "Japonesito" || mecanico == "Electrico") {
         _selectedMecanico = mecanico;
      } else {
         _selectedMecanico = null; 
      }
      
      _existingImageUrl = item['img_maintenance']; // URL del backend
      _selectedImage = null; // Limpiamos selección local nueva
    });
    
    // Scroll hacia arriba para ver el formulario (opcional)
  }

  // 🔹 Cancelar edición
  void _cancelEditing() {
    setState(() {
      _editingId = null;
      _existingImageUrl = null;
      _selectedImage = null;
      _kmCtrl.clear();
      _notesCtrl.clear();
      _selectedTipo = null;
      _selectedMecanico = null;
    });
  }

  // 🔹 Lógica de Actualización (Orquestador)
  Future<bool> _updateProcess(int carId) async {
    final auth = AuthService();
    bool dataSuccess = false;
    bool imgSuccess = true; // Asumimos true si no hay imagen que subir

    // 1. Actualizar Datos (Endpoint 1)
    dataSuccess = await auth.updateMaintenanceData(
      id: _editingId!,
      idCars: carId,
      typeMaintenance: _selectedTipo!,
      kilometros: int.tryParse(_kmCtrl.text) ?? 0,
      mecanica: _selectedMecanico!,
      notes: _notesCtrl.text,
      isMaintenance: true,
    );

    // 2. Actualizar Imagen (Endpoint 2) SOLO si el usuario seleccionó una nueva
    if (dataSuccess && _selectedImage != null) {
      imgSuccess = await auth.updateMaintenanceImage(id: _editingId!, notes: _notesCtrl.text, imagePath: _selectedImage!.path);
    }

    return dataSuccess && imgSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MantenimientoCarCubit(authService: AuthService()),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // 🔹 Fondo
              Image.asset(
                'assets/img/background13.jpg',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                color: const Color.fromRGBO(0, 0, 0, 0.7),
                colorBlendMode: BlendMode.darken,
              ),

              // 🔹 Contenido
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          const SizedBox(height: 30),

                          const Text(
                            "MANTENIMIENTO",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ===========================
                          //   SELECTOR DE VEHÍCULO
                          // ===========================
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Seleccionar Unidad",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          BlocBuilder<
                            MantenimientoCarCubit,
                            MantenimientoCarState
                          >(
                            builder: (context, state) {
                              if (state is MantenimientoCarLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }

                              if (state is MantenimientoCarLoaded) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _vehiculoBloqueado
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<CarModel>(
                                      value: state.selectedCar,
                                      isExpanded: true,
                                      hint: const Text("Seleccione una unidad"),
                                      items: state.cars.map((car) {
                                        return DropdownMenuItem(
                                          value: car,
                                          child: Text(
                                            car.label,
                                            style: TextStyle(
                                              color: _vehiculoBloqueado
                                                  ? Colors.grey
                                                  : Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: _vehiculoBloqueado
                                          ? null
                                          : (value) {
                                              if (value != null) {
                                                _mostrarAlertaSeleccion(
                                                  context,
                                                  value,
                                                );
                                              }
                                            },
                                    ),
                                  ),
                                );
                              }

                              if (state is MantenimientoCarError) {
                                return Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),

                          const SizedBox(height: 30),

                          // ===========================
                          //   HISTORIAL (UX: Contexto)
                          // ===========================
                          if (_maintenanceHistory.isNotEmpty) ...[
                            const Align(alignment: Alignment.centerLeft, child: Text("Historial (Toque para editar)", style: TextStyle(color: Colors.white70, fontSize: 14))),
                            const SizedBox(height: 5),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: ListView.builder(
                                itemCount: _maintenanceHistory.length,
                                itemBuilder: (ctx, i) {
                                  final item = _maintenanceHistory[i];
                                  final isSelected = item['id'] == _editingId;
                                  return ListTile(
                                    title: Text("${item['type_maintenance']} - ${item['kilometros']}km", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    subtitle: Text(item['created_at'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                    trailing: isSelected ? const Icon(Icons.edit, color: Colors.greenAccent) : const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                                    tileColor: isSelected ? Colors.white.withOpacity(0.2) : null,
                                    onTap: () => _startEditing(item),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ===========================
                          //   HEADER MODO EDICIÓN
                          // ===========================
                          if (_editingId != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("EDITANDO REGISTRO", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                                TextButton(onPressed: _cancelEditing, child: const Text("Cancelar", style: TextStyle(color: Colors.redAccent)))
                              ],
                            ),


                          // ===========================
                          //   INPUT: Tipo de mantenimiento
                          // ===========================
                          _buildLabel("Tipo de mantenimiento"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedTipo,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: const Text("Seleccione tipo"),
                              items: const [
                                DropdownMenuItem(value: "afinacion-mayor", child: Text("Afinación Mayor")),
                                DropdownMenuItem(value: "afinacion-menor", child: Text("Afinación Menor")),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedTipo = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===========================
                          //   INPUT: Kilómetro Inicial
                          // ===========================
                          _buildLabel("Kilómetro Ini."),
                          _buildInput(
                            controller: _kmCtrl,
                            hint: "Ej. 15000",
                            isNumber: true,
                            onChange: _cubit.changeKm,
                          ),

                          const SizedBox(height: 20),

                          // ===========================
                          //   INPUT: Mecánico
                          // ===========================
                          _buildLabel("Mecánico"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedMecanico,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: const Text("Seleccione mecánico"),
                              items: const [
                                DropdownMenuItem(value: "Japonesito", child: Text("Japonesito")),
                                DropdownMenuItem(value: "Electrico", child: Text("Eléctrico")),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedMecanico = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ===========================
                          //   INPUT: Notas
                          // ===========================
                          _buildLabel("Notas"),
                          _buildInput(
                            controller: _notesCtrl,
                            hint: "Detalles del mantenimiento...",
                          ),

                          const SizedBox(height: 50),

                          // ===========================
                          //   BOTÓN para cargar documento
                          // ===========================
                          const Text(
                            "Evidencia Fotográfica",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt, color: Colors.black),
                                label: const Text("Cámara", style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library, color: Colors.black),
                                label: const Text("Galería", style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ],
                          ),

                          if (_selectedImage != null || _existingImageUrl != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: _selectedImage != null 
                                      ? FileImage(_selectedImage!) as ImageProvider
                                      : NetworkImage(_existingImageUrl!.startsWith('http') 
                                          ? _existingImageUrl! 
                                          : "http://10.15.14.20:3000$_existingImageUrl"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () {
                                        setState(() {
                                          _selectedImage = null;
                                          _existingImageUrl = null; // Eliminar visualmente
                                        });
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 50),

                          // ===========================
                          //   BOTÓN GUARDAR / SALIR
                          // ===========================
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ElevatedButton(
                              onPressed: _isSending
                                  ? null
                                  : () async {
                                      // 1. Obtener estado del carro seleccionado
                                      final carState = context
                                          .read<MantenimientoCarCubit>()
                                          .state;
                                      CarModel? selectedCar;
                                      if (carState is MantenimientoCarLoaded) {
                                        selectedCar = carState.selectedCar;
                                      }

                                      // 2. Validaciones básicas
                                      if (selectedCar == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Seleccione una unidad",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_selectedTipo == null ||
                                          _kmCtrl.text.isEmpty ||
                                          _selectedMecanico == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Complete los campos obligatorios",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 3. Enviar datos
                                      setState(() => _isSending = true);

                                      print("🔍 DEBUG: Enviando mantenimiento desde UI...");

                                      bool success;
                                      
                                      if (_editingId == null) {
                                        // --- MODO CREAR ---
                                        success = await AuthService()
                                            .createMaintenance(
                                              idCars: selectedCar.id ?? 0,
                                              typeMaintenance: _selectedTipo!,
                                              kilometros: int.tryParse(_kmCtrl.text) ?? 0,
                                              mecanico: _selectedMecanico!,
                                              notes: _notesCtrl.text,
                                              imagePath: _selectedImage?.path,
                                              isMaintenance: true,
                                            );
                                      } else {
                                        // --- MODO ACTUALIZAR (Orquestado) ---
                                        success = await _updateProcess(selectedCar.id ?? 0);
                                      }

                                      print("📡 DEBUG: Resultado Operación: $success");

                                      setState(() => _isSending = false);

                                      if (!context.mounted) return;

                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              _editingId == null ? "Mantenimiento creado con éxito" : "Mantenimiento actualizado con éxito",
                                            ),
                                          ),
                                        );
                                        // Recargar historial y limpiar
                                        _loadHistory(selectedCar.id ?? 0);
                                        _cancelEditing();
                                        /* 
                                        // Opcional: Salir de la pantalla
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomeAdmin(),
                                          ),
                                        );
                                        */
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Error en la operación",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              child: _isSending
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : Text(
                                      _editingId == null ? "Guardar" : "Actualizar",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // 🔹 Icono Home (Superior Derecho)
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeAdmin()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  //   Helpers UI
  // ===========================
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    Function(String)? onChange,
    String? hint,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white70,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ===========================
  //   Alerta de Selección
  // ===========================
  void _mostrarAlertaSeleccion(BuildContext context, CarModel car) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar Selección"),
        content: Text(
          "¿Está seguro de seleccionar la unidad ${car.label}? \n\nUna vez aceptado, no podrá cambiarla.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _vehiculoBloqueado = true;
              });
              context.read<MantenimientoCarCubit>().changeCar(car);
              
              // 🚀 Cargar historial al confirmar vehículo
              if (car.id != null) _loadHistory(car.id!);
            },
            child: const Text("Aceptar", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
