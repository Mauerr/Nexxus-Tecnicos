import 'package:flutter/material.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';

// Pantallas
import 'evidenciamecanica.dart';
import 'kilometraje/evidenciakilometraje.dart';
import 'evidenciahojalateria.dart';

// Cubits
import 'evidenciaMecanica_cubit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String unidadSeleccionada = "001 Volkswagen";

  bool evidenciaMecanicaOk = false;
  bool evidenciaKilometrajeOk = false;
  bool evidenciaHojalateriaOk = false;

  final List<String> unidades = [
    "001 Volkswagen",
    "002 Nissan NP300",
    "003 Ford Transit",
    "004 Toyota Hiace",
  ];

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    cargarEstatusEvidencias();
  }

  Future<void> cargarDatosUsuario() async {
    final data = await AuthService().getSession();
    setState(() {
      userName = data?["name"] ?? "Técnico";
    });
  }

  Future<void> cargarEstatusEvidencias() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      evidenciaMecanicaOk = prefs.getBool("mecanica_ok") ?? false;
      evidenciaKilometrajeOk = prefs.getBool("kilometraje_ok") ?? false;
      evidenciaHojalateriaOk = prefs.getBool("hojalateria_ok") ?? false;
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

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: unidadSeleccionada,
                      isExpanded: true,
                      underline: Container(),
                      items: unidades.map((u) {
                        return DropdownMenuItem(
                          value: u,
                          child: Text(u),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          unidadSeleccionada = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

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

                  await prefs.remove("mecanica_ok");
                  await prefs.remove("kilometraje_ok");
                  await prefs.remove("hojalateria_ok");

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
    );
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
          backgroundColor: completado ? Colors.grey.shade500 : const Color(0xFFD9D9D9),
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
            color: Colors.black.withOpacity(completado ? 0.4 : 1),
          ),
        ),
      ),
    );
  }
}
