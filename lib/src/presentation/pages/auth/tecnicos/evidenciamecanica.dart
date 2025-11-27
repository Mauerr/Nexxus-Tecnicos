import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidenciaMecanica_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidenciaMecanica_state.dart';

class EvidenciaMecanicaScreen extends StatelessWidget {
  const EvidenciaMecanicaScreen({super.key});

  Future<void> _guardarEstatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("mecanica_ok", true);
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

            BlocBuilder<EvidenciaMecanicaCubit, EvidenciaMecanicaState>(
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
                        "Evidencia Mecánica",
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
                            _buildEvidenciaButton(
                              context,
                              "Aceite de motor",
                              state.fotoAceite != null,
                              () => context.read<EvidenciaMecanicaCubit>().tomarFotoAceite(),
                            ),
                            const SizedBox(height: 20),

                            _buildEvidenciaButton(
                              context,
                              "Líquido de frenos",
                              state.fotoFrenos != null,
                              () => context.read<EvidenciaMecanicaCubit>().tomarFotoFrenos(),
                            ),
                            const SizedBox(height: 20),

                            _buildEvidenciaButton(
                              context,
                              "Anticongelante",
                              state.fotoAnticongelante != null,
                              () => context.read<EvidenciaMecanicaCubit>().tomarFotoAnticongelante(),
                            ),

                            const SizedBox(height: 40),

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                onPressed: state.completado
                                    ? () async {
                                        // 🔹 Guardar completado
                                        await _guardarEstatus();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Evidencias validadas correctamente"),
                                          ),
                                        );

                                        // 🔹 Regresar al Home y refrescarlo
                                        Navigator.pop(context);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: state.completado
                                      ? Colors.greenAccent
                                      : Colors.grey.shade400,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Validar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
            )
          ],
        ),
      ),
    );
  }

  // 🔹 Botón con check verde
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
              style: const TextStyle(fontSize: 20, color: Colors.black),
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
