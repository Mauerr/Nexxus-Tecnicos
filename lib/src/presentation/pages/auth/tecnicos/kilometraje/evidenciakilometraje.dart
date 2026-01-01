import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_screen.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_state.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EvidenciaKilometrajeScreen extends StatefulWidget {
  const EvidenciaKilometrajeScreen({super.key});

  @override
  State<EvidenciaKilometrajeScreen> createState() => _EvidenciaKilometrajeScreenState();
}

class _EvidenciaKilometrajeScreenState extends State<EvidenciaKilometrajeScreen> {
  final TextEditingController _kmController = TextEditingController();
  bool _isSending = false;
  bool _vehiculoAsignado = false;

  @override
  void initState() {
    super.initState();
    _checkAsignacion();
  }

  Future<void> _checkAsignacion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vehiculoAsignado = prefs.getBool("vehiculo_asignado") ?? false;
    });
  }

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _guardarValidacion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("kilometraje_ok", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/img/background13.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),

            BlocBuilder<EvidenciaKilometrajeCubit, EvidenciaKilometrajeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      const Text(
                        "Evidencia de Kilometraje",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 60),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "KM Inicial:",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: _kmController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Ingrese kilometraje",
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(height: 30),

                            _buildEvidenciaButton(
                              context,
                              "KM inicio del día",
                              state.fotoKmInicio != null,
                              () => context.read<EvidenciaKilometrajeCubit>().tomarFotoKmInicio(),
                            ),

                            const SizedBox(height: 40),

                            // 🔹 BOTÓN VALIDAR
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                onPressed: !_vehiculoAsignado
                                    ? () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("No tienes un vehículo asignado.")),
                                        );
                                      }
                                    : (state.fotoKmInicio != null && _kmController.text.isNotEmpty && !_isSending)
                                        ? () async {
                                            setState(() => _isSending = true);

                                            final authService = AuthService();
                                            final user = await authService.getLoggedUser();
                                            final km = int.tryParse(_kmController.text) ?? 0;

                                            print("🔍 DEBUG: Iniciando proceso de validación...");
                                            print("   -> Usuario ID: ${user?.id}");
                                            print("   -> KM Ingresado: $km");
                                            print("   -> Foto presente: ${state.fotoKmInicio != null}");

                                            if (user != null && user.id != null) {
                                              print("🚀 DEBUG: Enviando datos al backend...");
                                              final success = await authService.updateEvidenceKm(
                                                userId: user.id!.toString(),
                                                km: km,
                                                lat: 19.4325, // Coordenadas fijas por ahora
                                                lng: -99.1331,
                                                image: state.fotoKmInicio,
                                              );

                                              print("📡 DEBUG: Resultado del servicio: $success");

                                              if (success) {
                                                print("✅ DEBUG: Éxito. Guardando localmente y saliendo.");
                                                await _guardarValidacion();
                                                if (!mounted) return;
                                                
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Evidencias enviadas correctamente")),
                                                );

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                                  (route) => false,
                                                );
                                              } else {
                                                print("❌ DEBUG: Falló el envío. Revisa el código de estado en AuthService.");
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Error al enviar evidencias")),
                                                );
                                              }
                                            } else {
                                              print("⚠️ DEBUG: Usuario no válido o ID nulo.");
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Error: Usuario no identificado")),
                                              );
                                            }
                                            
                                            if (mounted) setState(() => _isSending = false);
                                          }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (state.fotoKmInicio != null && _kmController.text.isNotEmpty && _vehiculoAsignado)
                                      ? Colors.greenAccent
                                      : Colors.grey.shade400,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: _isSending
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                    : Text(
                                        "Validar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: (state.fotoKmInicio != null && _kmController.text.isNotEmpty && _vehiculoAsignado)
                                              ? Colors.black
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Botón de evidencia con check
  Widget _buildEvidenciaButton(
    BuildContext context,
    String texto,
    bool completado,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texto,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            if (completado) ...[
              const SizedBox(width: 12),
              const Icon(Icons.check_circle, color: Colors.green, size: 26),
            ],
          ],
        ),
      ),
    );
  }
}
