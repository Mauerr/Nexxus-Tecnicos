import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class FinalizarDiaScreen extends StatefulWidget {
  const FinalizarDiaScreen({super.key});

  @override
  State<FinalizarDiaScreen> createState() => _FinalizarDiaScreenState();
}

class _FinalizarDiaScreenState extends State<FinalizarDiaScreen> {
  bool mecanicaEndOk = false;
  bool kilometrajeEndOk = false;
  bool hojalateriaEndOk = false;
  bool tapiceriaEndOk = false;

  @override
  void initState() {
    super.initState();
    _cargarEstatus();
  }

  Future<void> _cargarEstatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Leemos las banderas de "Fin de día"
      mecanicaEndOk = prefs.getBool("mecanica_end_ok") ?? false;
      kilometrajeEndOk = prefs.getBool("kilometraje_end_ok") ?? false;
      // Asumimos que Hojalatería y Tapicería usarán estas llaves si se actualizan para soportar isEndDay
      hojalateriaEndOk = prefs.getBool("hojalateria_end_ok") ?? false;
      tapiceriaEndOk = prefs.getBool("tapiceria_end_ok") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si todas las evidencias finales están completas
    // Se habilitan todas las validaciones para el cierre de turno
    
    // Verificar si las evidencias previas al Kilometraje Final están listas
    bool evidenciasPreviasListas = mecanicaEndOk && hojalateriaEndOk && tapiceriaEndOk;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
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
                  
                  // Botón Regresar
                  if (!kilometrajeEndOk)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(height: 48),

                  const Text(
                    "Finalizar Día",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Complete las evidencias finales para cerrar el turno.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView(
                      children: [
                        // 1. MECÁNICA FINAL
                        _botonMenu(
                          context,
                          "Evidencias Mecánicas Final",
                          BlocProvider(
                            create: (_) => EvidenciaMecanicaCubit(),
                            child: const EvidenciaMecanicaScreen(isEndDay: true),
                          ),
                          mecanicaEndOk,
                        ),
                        const SizedBox(height: 20),

                        // 2. HOJALATERÍA FINAL
                        _botonMenu(
                          context,
                          "Evidencias Hojalatería Final",
                          BlocProvider(
                            create: (_) => EvidenciaHojalateriaCubit(),
                            child: const EvidenciaHojalateriaScreen(isEndDay: true),
                          ),
                          hojalateriaEndOk,
                        ),
                        const SizedBox(height: 20),

                        // 3. TAPICERÍA FINAL
                        _botonMenu(
                          context,
                          "Evidencias Tapicería Final",
                          BlocProvider(
                            create: (_) => EvidenciaTapiceriaCubit(),
                            child: const EvidenciaTapiceriaScreen(isEndDay: true),
                          ),
                          tapiceriaEndOk,
                        ),
                        const SizedBox(height: 20),

                        // 4. KILOMETRAJE FINAL
                        _botonMenu(
                          context,
                          "Evidencias Kilometraje Final",
                          BlocProvider(
                            create: (_) => EvidenciaKilometrajeCubit(),
                            child: const EvidenciaKilometrajeScreen(isEndDay: true),
                          ),
                          kilometrajeEndOk,
                          habilitado: evidenciasPreviasListas,
                        ),
                      ],
                    ),
                  ),

                  // BOTÓN CERRAR TURNO (Solo visible si kilometraje final está ok)
                  if (kilometrajeEndOk)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                           final prefs = await SharedPreferences.getInstance();
                           // Limpieza completa de sesión y evidencias
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
                _cargarEstatus(); // Recargar estado al volver
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
