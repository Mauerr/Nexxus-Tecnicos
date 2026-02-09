import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_state.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';

// Pantallas
import '../mecanica/evidenciamecanica.dart';
import '../kilometraje/evidenciakilometraje.dart';
import '../hojalateria/evidenciahojalateria.dart';
import '../tapiceria/evidencia_tapiceria_screen.dart';
import '../finalizardia/finalizardia_screen.dart';

// Cubits
import '../mecanica/evidenciaMecanica_cubit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  //String unidadSeleccionada = "001 Volkswagen";

  bool evidenciaMecanicaOk = false;
  bool evidenciaKilometrajeOk = false;
  bool evidenciaKilometrajeFinalOk = false;
  bool evidenciaHojalateriaOk = false;
  bool evidenciaTapiceriaOk = false;
  bool vehiculoAsignado = false;
  int? assignedCarId;

  /*final List<String> unidades = [
    "001 Volkswagen",
    "002 Nissan NP300",
    "003 Ford Transit",
    "004 Toyota Hiace",
  ];*/

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    cargarEstatusEvidencias();
  }

  Future<void> cargarDatosUsuario() async {
    final user = await AuthService().getLoggedUser();

  setState(() {
    userName = user?.name ?? "Técnico";
  });
  }

  Future<void> cargarEstatusEvidencias() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await AuthService().getLoggedUser();

    // 1. Validar Usuario y Limpieza de Sesión Anterior
    final int? storedUserId = prefs.getInt("assigned_user_id");
    bool vAsignado = prefs.getBool("vehiculo_asignado") ?? false;

    // Si hay vehículo asignado, debe coincidir el usuario. Si no hay usuario guardado o es diferente, limpiar.
    if (vAsignado) {
      if (user != null && (storedUserId == null || user.id != storedUserId)) {
        print("⚠️ Usuario diferente o inconsistente detectado. Limpiando asignación anterior.");
        await prefs.remove("vehiculo_asignado");
        await prefs.remove("current_evidence_id");
        await prefs.remove("assigned_car_id");
        await prefs.remove("assigned_user_id");
        await prefs.remove("mecanica_ok");
        await prefs.remove("kilometraje_ok");
        await prefs.remove("kilometraje_end_ok");
        await prefs.remove("hojalateria_ok");
        await prefs.remove("tapiceria_ok");
        vAsignado = false;
      }
    }

    // 2. Validar ID de Evidencia
    final int? idEvidence = prefs.getInt('current_evidence_id');
    if (vAsignado && idEvidence == null) {
      print("⚠️ CORRECCIÓN AUTOMÁTICA: Vehículo asignado pero sin ID de evidencia. Reseteando para permitir reasignación.");
      await prefs.setBool("vehiculo_asignado", false);
      vAsignado = false;
    }

    // 3. Si no hay vehículo asignado, asegurar limpieza de banderas
    if (!vAsignado) {
      await prefs.remove("mecanica_ok");
      await prefs.remove("kilometraje_ok");
      await prefs.remove("kilometraje_end_ok");
      await prefs.remove("hojalateria_ok");
      await prefs.remove("tapiceria_ok");
    }

    // 4. Leer estatus actualizados
    final bool mecOk = prefs.getBool("mecanica_ok") ?? false;
    final bool kmOk = prefs.getBool("kilometraje_ok") ?? false;
    final bool kmFinalOk = prefs.getBool("kilometraje_end_ok") ?? false;
    final bool hojOk = prefs.getBool("hojalateria_ok") ?? false;
    final bool tapOk = prefs.getBool("tapiceria_ok") ?? false;
    final int? savedCarId = prefs.getInt("assigned_car_id");

    setState(() {
      evidenciaMecanicaOk = mecOk;
      evidenciaKilometrajeOk = kmOk;
      evidenciaKilometrajeFinalOk = kmFinalOk;
      evidenciaHojalateriaOk = hojOk;
      evidenciaTapiceriaOk = tapOk;
      vehiculoAsignado = vAsignado;
      assignedCarId = savedCarId;
    });

    print("📊 ESTATUS HOME: Asignado=$vAsignado | Mec=$mecOk | Km=$kmOk | KmFinal=$kmFinalOk | Hoj=$hojOk | Tap=$tapOk");
  }

  @override
 Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => HomeCubit(authService: AuthService()),
    child: BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // 🔹 RESTAURAR SELECCIÓN: Si hay un carro asignado y la lista cargó, seleccionarlo.
        if (state is HomeLoaded && vehiculoAsignado && assignedCarId != null && state.selectedCar == null) {
          try {
            final restoredCar = state.cars.firstWhere((c) => c.id == assignedCarId);
            context.read<HomeCubit>().changeCar(restoredCar);
            print("✅ Vehículo restaurado automáticamente: ${restoredCar.label}");
          } catch (e) {
            print("⚠️ No se pudo restaurar el vehículo asignado (ID: $assignedCarId). Puede que no esté en la lista.");
          }
        }
      },
      child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Bienvenido $userName",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Unidad asignada",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const CircularProgressIndicator(color: Colors.white);
                      }

                      if (state is HomeLoaded) {
                        // Bloquear selección si ya se inició la toma de evidencias
                        final bool isLocked = evidenciaMecanicaOk || evidenciaKilometrajeOk || evidenciaHojalateriaOk || evidenciaTapiceriaOk || vehiculoAsignado;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isLocked ? Colors.grey.shade300 : Colors.white,
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
                                  style: TextStyle(color: isLocked ? Colors.grey : Colors.black87),
                                ),
                              );
                            }).toList(),
                            onChanged: isLocked ? null : (value) {
                              if (value != null) {
                                _mostrarAlertaAsignacion(context, value);
                              }
                            },
                          ),
                          ),
                        );
                      }

                      if (state is HomeError) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                onPressed: () {
                                  context.read<HomeCubit>().loadCars();
                                },
                              )
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),


                  const SizedBox(height: 50),
                  /// 🔹 MENSAJE FINAL CUANDO TODO ESTÁ COMPLETADO
                  if (evidenciaMecanicaOk && evidenciaKilometrajeOk && evidenciaHojalateriaOk && evidenciaTapiceriaOk)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.greenAccent, width: 1.5),
                          ),
                          child: Column(
                            children: const [
                              Text(
                                "¡Has completado todas las evidencias!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Puedes tomar tu unidad. Presiona Finalizar para cerrar sesión.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove("mecanica_ok");
                              await prefs.remove("kilometraje_ok");
                              await prefs.remove("kilometraje_end_ok");
                              await prefs.remove("hojalateria_ok");
                              await prefs.remove("tapiceria_ok");
                              await prefs.remove("vehiculo_asignado");
                              await prefs.remove("current_evidence_id");
                              await prefs.remove("assigned_car_id");
                              await prefs.remove("assigned_user_id");
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
                              "Finalizar",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),


                  /// 🔹 MECÁNICA — con BlocProvider
                  botonMenuBloqueable(
                    context,
                    "Evidencias Mecánicas",
                    BlocProvider(
                      create: (_) => EvidenciaMecanicaCubit(),
                      child: const EvidenciaMecanicaScreen(),
                    ),
                    evidenciaMecanicaOk,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 KILOMETRAJE — con BlocProvider
                  botonMenuBloqueable(
                    context,
                    "Evidencias Kilometraje",
                    BlocProvider(
                      create: (_) => EvidenciaKilometrajeCubit(),
                      child: const EvidenciaKilometrajeScreen(),
                    ),
                    evidenciaKilometrajeOk,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 HOJALATERÍA — sin cambios por ahora
                  botonMenuBloqueable(
                    context,
                    "Evidencias Hojalatería",
                    const EvidenciaHojalateriaScreen(),
                    evidenciaHojalateriaOk,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 TAPICERÍA
                  botonMenuBloqueable(
                    context,
                    "Evidencias Tapicería",
                    const EvidenciaTapiceriaScreen(),
                    evidenciaTapiceriaOk,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 PANTALLA FINALIZAR DÍA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FinalizarDiaScreen()),
                        );
                      },
                      child: const Text(
                        "Ir a Finalizar Día",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: "Cerrar sesión",
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  // 🔹 PERSISTENCIA: No borramos las banderas de evidencia ni la asignación al hacer Logout.
                  // Solo se borran en "Finalizar" o si entra otro usuario.
                  // await prefs.remove("mecanica_ok");
                  // await prefs.remove("kilometraje_ok");
                  // await prefs.remove("hojalateria_ok");
                  // await prefs.remove("tapiceria_ok");

                  await AuthService().clearSession();

                  if (!mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Loginpage()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    ),
    );
  }

  /// 🔹 ALERTA DE CONFIRMACIÓN DE ASIGNACIÓN
  void _mostrarAlertaAsignacion(BuildContext context, CarModel car) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar Asignación"),
        content: Text("¿Está seguro de seleccionar la unidad ${car.label}? \n\nUna vez aceptado, se asignará a su usuario y no podrá cambiarla."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Cerrar alerta
              _realizarAsignacion(car);
            },
            child: const Text("Aceptar", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  /// 🔹 LÓGICA PARA ASIGNAR VEHÍCULO EN BACKEND
  Future<void> _realizarAsignacion(CarModel car) async {
    final authService = AuthService();
    final user = await authService.getLoggedUser();

    if (user != null && user.id != null && car.id != null) {
      // Intentamos parsear los IDs a int como requiere el backend
      final int userId = user.id!; // Asumiendo que user.id ya es int
      final int carId = car.id!;

      final success = await authService.createAssignment(userId: userId, carId: carId);

      // 🔹 Verificar si realmente obtuvimos el ID de la evidencia
      final prefs = await SharedPreferences.getInstance();
      final int? evidenceId = prefs.getInt('current_evidence_id');

      if (success && evidenceId != null) {
        await prefs.setBool("vehiculo_asignado", true);
        await prefs.setInt("assigned_car_id", carId);
        await prefs.setInt("assigned_user_id", userId); // Guardar usuario para validar persistencia

        setState(() {
          vehiculoAsignado = true;
          assignedCarId = carId;
        });

        // Actualizar visualmente el carro seleccionado en el Cubit
        if (mounted) context.read<HomeCubit>().changeCar(car);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehículo asignado correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: El servidor no devolvió el ID de asignación.")),
        );
      }
    }
  }

  /// 🔹 BOTÓN BLOQUEABLE
  Widget botonMenuBloqueable(
    BuildContext context,
    String text,
    Widget destino,
    bool completado,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          disabledBackgroundColor: Colors.grey, // Color de fondo cuando está validado
          disabledForegroundColor: Colors.black38, // Color del texto/icono cuando está validado
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
                cargarEstatusEvidencias();
              },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: completado ? Colors.black45 : Colors.black,
          ),
        ),
      ),
    );
  }
}
