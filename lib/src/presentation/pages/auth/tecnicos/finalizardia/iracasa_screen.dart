import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/evidenciakilometraje.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

class IraCasaScreen extends StatefulWidget {
  const IraCasaScreen({super.key});

  @override
  State<IraCasaScreen> createState() => _IraCasaScreenState();
}

class _IraCasaScreenState extends State<IraCasaScreen> {
  bool kilometrajeEndOk = false;
  bool kilometrajeOk = false; // Para Kilometraje Inicial
  List<CarModel> cars = [];
  CarModel? assignedCar;
  CarModel? originalCar;
  bool isLoading = true;
  bool? continuarMismaUnidad;
  bool isAssignmentActive = false;

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  Future<void> _inicializarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cargar estatus de evidencias
    final bool kmEnd = prefs.getBool("kilometraje_end_ok") ?? false;
    final bool kmStart = prefs.getBool("kilometraje_ok") ?? false;

    // Cargar lista de carros para el selector
    List<CarModel> loadedCars = [];
    CarModel? currentCar;
    try {
      final authService = AuthService();
      loadedCars = await authService.getAllCars();
      
      // 🔹 CONSULTAR ENDPOINT PARA MANTENER LA UNIDAD (Activa o Última)
      final user = await authService.getLoggedUser();
      if (user != null && user.id != null) {
        final assignmentData = await authService.getUserAssignment(user.id!);
        
        if (assignmentData != null && assignmentData['assignment'] != null) {
          final assignment = assignmentData['assignment'];
          isAssignmentActive = assignment['is_active'] ?? false;
          // Verificamos si existe el objeto 'car' (aplica para activo:true e inactivo:false con historial)
          if (assignment['car'] != null && assignment['car']['id'] != null) {
            final int apiCarId = assignment['car']['id'];
            try {
              currentCar = loadedCars.firstWhere((c) => c.id == apiCarId);
              // Sincronizamos la preferencia local para consistencia
              await prefs.setInt("assigned_car_id", apiCarId);
            } catch (_) {}
          }
        }
      }

      // Fallback: Si la API no devolvió carro, intentar con SharedPreferences
      if (currentCar == null) {
        final int? savedCarId = prefs.getInt("assigned_car_id");
        if (savedCarId != null && loadedCars.isNotEmpty) {
          currentCar = loadedCars.firstWhere((c) => c.id == savedCarId, orElse: () => loadedCars.first);
        }
      }
    } catch (e) {
      print("Error cargando vehículos: $e");
    }

    setState(() {
      kilometrajeEndOk = kmEnd;
      kilometrajeOk = kmStart;
      cars = loadedCars;
      assignedCar = currentCar;
      originalCar = currentCar;
      isLoading = false;
      continuarMismaUnidad = null;
    });
  }

  Future<void> _asignarNuevaUnidad(CarModel newCar) async {
    setState(() => isLoading = true);
    final authService = AuthService();
    final user = await authService.getLoggedUser();

    if (user != null && user.id != null && newCar.id != null) {
      final success = await authService.createAssignment(userId: user.id!, carId: newCar.id!);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("vehiculo_asignado", true);
        await prefs.setInt("assigned_car_id", newCar.id!);
        await prefs.setInt("assigned_user_id", user.id!);
        await prefs.remove("kilometraje_ok"); 
        await prefs.setBool("ready_to_start_work", true); // 🔹 Guardar estado para próximo login

        setState(() {
          assignedCar = newCar;
          originalCar = newCar;
          kilometrajeOk = false;
          continuarMismaUnidad = true; 
          isLoading = false;
        });
        
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unidad asignada correctamente")));
        }
      } else {
        setState(() => isLoading = false);
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al asignar la unidad")));
        }
      }
    } else {
        setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo de pantalla (Mismo que las otras ventanas)
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
                children: [
                  const SizedBox(height: 20),
                  
                  // Botón Regresar (Se oculta si ya se validó el KM)
                  if (!kilometrajeEndOk)
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  else
                    const SizedBox(height: 48),

                  const Text(
                    "Ir a casa",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  // 🔹 LÓGICA DE VISIBILIDAD
                  if (!kilometrajeEndOk) ...[
                    // 1. Si NO ha terminado el día, muestra Kilometraje Final
                    _botonMenu(
                      context,
                      "Evidencias Kilometraje Final",
                      BlocProvider(
                        create: (_) => EvidenciaKilometrajeCubit(),
                        child: const EvidenciaKilometrajeScreen(isEndDay: true),
                      ),
                      kilometrajeEndOk,
                    ),
                  ] else ...[
                    const Text(
                      "seguiras con la misma unidad",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final targetCar = assignedCar ?? originalCar;
                              if (targetCar != null) {
                                if (!isAssignmentActive) {
                                  await _asignarNuevaUnidad(targetCar);
                                } else {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setBool("ready_to_start_work", true); // 🔹 Guardar estado para próximo login
                                  
                                  setState(() {
                                    continuarMismaUnidad = true;
                                    assignedCar = targetCar;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (continuarMismaUnidad == true) ? Colors.green[800] : Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("si", style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove("ready_to_start_work"); // 🔹 Limpiar si cambia de opinión
                              setState(() {
                                continuarMismaUnidad = false;
                                assignedCar = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (continuarMismaUnidad == false) ? Colors.red[900] : Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("no", style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),

                    if (continuarMismaUnidad != null) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Unidad Asignada:",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // SELECTOR DE UNIDADES
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isLoading 
                        ? const SizedBox(height: 50, child: Center(child: CircularProgressIndicator()))
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<CarModel>(
                              value: assignedCar,
                              isExpanded: true,
                              hint: const Text("Seleccione unidad"),
                              items: cars.map((car) {
                                return DropdownMenuItem(
                                  value: car,
                                  child: Text(car.label, style: const TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                              onChanged: (continuarMismaUnidad == true) 
                                ? null 
                                : (val) { 
                                    if (val != null) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Confirmar cambio"),
                                          content: Text("¿Deseas asignar la unidad ${val.label}?"),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
                                            TextButton(onPressed: () { Navigator.pop(ctx); _asignarNuevaUnidad(val); }, child: const Text("Aceptar")),
                                          ],
                                        )
                                      );
                                    }
                                  },
                            ),
                          ),
                    ),
                    
                    const SizedBox(height: 30),

                    // BOTÓN KILOMETRAJE INICIAL
                    _botonMenu(
                      context,
                      "Evidencias Kilometraje Inicial",
                      BlocProvider(
                        create: (_) => EvidenciaKilometrajeCubit(),
                        child: const EvidenciaKilometrajeScreen(isEndDay: false), // isEndDay false para Inicial
                      ),
                      false, // 🔹 Siempre habilitado para permitir cargar nuevamente la evidencia
                    ),

                    const SizedBox(height: 40),
                    
                    // BOTÓN CERRAR SESIÓN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                           // 🔹 Lógica "Ir a casa": Cerrar sesión pero MANTENER asignación
                           await AuthService().clearSession();

                           if (!mounted) return;
                           Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (_) => const Loginpage()),
                             (route) => false,
                           );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Cerrar Sesión",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    ]
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _botonMenu(BuildContext context, String text, Widget destino, bool completado) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.black38,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: completado
            ? null
            : () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destino),
                );
                // Recargar solo los estatus booleanos al volver
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  kilometrajeEndOk = prefs.getBool("kilometraje_end_ok") ?? false;
                  kilometrajeOk = prefs.getBool("kilometraje_ok") ?? false;
                });
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: completado ? Colors.black45 : Colors.black,
              ),
            ),
            if (completado) ...[
              const SizedBox(width: 10),
              const Icon(Icons.check_circle, color: Colors.green),
            ],
          ],
        ),
      ),
    );
  }
}
