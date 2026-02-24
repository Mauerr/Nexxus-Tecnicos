import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_screen.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';

// Cubits
import '../mecanica/evidenciaMecanica_cubit.dart';
import '../kilometraje/kilometraje_cubit.dart';
import '../hojalateria/evidenciaHojalateria_cubit.dart';
import '../tapiceria/evidenciaTapiceria_cubit.dart';

// Pantallas de Evidencia
import '../mecanica/evidenciamecanica.dart';
import '../kilometraje/evidenciakilometraje.dart';
import '../hojalateria/evidenciahojalateria.dart';
import '../tapiceria/evidencia_tapiceria_screen.dart';

class EmpezarLaboresDetalleScreen extends StatefulWidget {
  const EmpezarLaboresDetalleScreen({super.key});

  @override
  State<EmpezarLaboresDetalleScreen> createState() => _EmpezarLaboresDetalleScreenState();
}

class _EmpezarLaboresDetalleScreenState extends State<EmpezarLaboresDetalleScreen> {
  bool mecanicaOk = false;
  bool kilometrajeOk = false;
  bool hojalateriaOk = false;
  bool tapiceriaOk = false;

  @override
  void initState() {
    super.initState();
    _inicializarEstado();
  }

  Future<void> _inicializarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("mecanica_ok");
    await prefs.remove("hojalateria_ok");
    await prefs.remove("tapiceria_ok");
    await prefs.remove("kilometraje_end_ok");
    _cargarEstatus();
  }

  Future<void> _cargarEstatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mecanicaOk = prefs.getBool("mecanica_ok") ?? false;
      kilometrajeOk = prefs.getBool("kilometraje_end_ok") ?? false;
      hojalateriaOk = prefs.getBool("hojalateria_ok") ?? false;
      tapiceriaOk = prefs.getBool("tapiceria_ok") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (!kilometrajeOk)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(height: 48),

                  const Text(
                    "Empezar labores",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pero antes toma evidencia de la unidad e inicia el proceso de la jornada laboral",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView(
                      children: [
                        _botonMenu(
                          context,
                          "Evidencias Mecánicas",
                          BlocProvider(
                            create: (_) => EvidenciaMecanicaCubit(),
                            child: const EvidenciaMecanicaScreen(isEndDay: false),
                          ),
                          mecanicaOk,
                        ),
                        const SizedBox(height: 20),
                        _botonMenu(
                          context,
                          "Evidencias Hojalatería",
                          BlocProvider(
                            create: (_) => EvidenciaHojalateriaCubit(),
                            child: const EvidenciaHojalateriaScreen(isEndDay: false),
                          ),
                          hojalateriaOk,
                        ),
                        const SizedBox(height: 20),
                        _botonMenu(
                          context,
                          "Evidencias Tapicería",
                          BlocProvider(
                            create: (_) => EvidenciaTapiceriaCubit(),
                            child: const EvidenciaTapiceriaScreen(isEndDay: false),
                          ),
                          tapiceriaOk,
                        ),
                        const SizedBox(height: 20),
                        _botonMenu(
                          context,
                          "Evidencias Kilometraje Final",
                          BlocProvider(
                            create: (_) => EvidenciaKilometrajeCubit(),
                            child: const EvidenciaKilometrajeScreen(isEndDay: true),
                          ),
                          kilometrajeOk,
                          habilitado: mecanicaOk && hojalateriaOk && tapiceriaOk,
                        ),
                      ],
                    ),
                  ),

                  if (kilometrajeOk)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                           final prefs = await SharedPreferences.getInstance();
                           
                           // 🔹 Limpieza completa de sesión y evidencias (Desasignar unidad y resetear flujo)
                           await prefs.remove("mecanica_ok");
                           await prefs.remove("kilometraje_ok");
                           await prefs.remove("hojalateria_ok");
                           await prefs.remove("tapiceria_ok");
                           
                           await prefs.remove("mecanica_end_ok");
                           await prefs.remove("kilometraje_end_ok");
                           await prefs.remove("hojalateria_end_ok");
                           await prefs.remove("tapiceria_end_ok");

                           await prefs.remove("vehiculo_asignado");
                           await prefs.remove("current_evidence_id");
                           await prefs.remove("assigned_car_id");
                           await prefs.remove("assigned_user_id");
                           await prefs.remove("ready_to_start_work");
                           
                           await AuthService().clearSession();
                           
                           if (!mounted) return;
                           Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (_) => const Loginpage()),
                             (route) => false,
                           );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Iniciar Jornada",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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

  Widget _botonMenu(BuildContext context, String text, Widget destino, bool completado, {bool habilitado = true}) {
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
        onPressed: (habilitado && !completado)
            ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destino),
                );
                _cargarEstatus();
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: (habilitado && !completado) ? Colors.black : Colors.black45,
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