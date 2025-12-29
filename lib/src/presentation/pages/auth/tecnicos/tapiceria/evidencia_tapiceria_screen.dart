import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'evidenciaTapiceria_cubit.dart';
import 'evidenciaTapiceria_state.dart';

class EvidenciaTapiceriaScreen extends StatelessWidget {
  const EvidenciaTapiceriaScreen({super.key});

  Future<void> _guardarEstatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("tapiceria_ok", true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EvidenciaTapiceriaCubit(),
      child: Scaffold(
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
              BlocBuilder<EvidenciaTapiceriaCubit, EvidenciaTapiceriaState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Botón regresar
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "Evidencia Tapicería",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 60),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildEvidenciaButton(
                                context,
                                "Asientos delanteros",
                                state.fotoAsientosDelanteros != null,
                                () => context.read<EvidenciaTapiceriaCubit>().tomarFotoAsientosDelanteros(),
                              ),
                              const SizedBox(height: 20),

                              _buildEvidenciaButton(
                                context,
                                "Asientos traseros",
                                state.fotoAsientosTraseros != null,
                                () => context.read<EvidenciaTapiceriaCubit>().tomarFotoAsientosTraseros(),
                              ),
                              const SizedBox(height: 20),

                              _buildEvidenciaButton(
                                context,
                                "Tablero",
                                state.fotoTablero != null,
                                () => context.read<EvidenciaTapiceriaCubit>().tomarFotoTablero(),
                              ),

                              const SizedBox(height: 40),

                              // Botón Validar
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ElevatedButton(
                                  onPressed: state.completado
                                      ? () async {
                                          await _guardarEstatus();
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Evidencias validadas correctamente")),
                                          );
                                          Navigator.pop(context);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: state.completado ? Colors.greenAccent : Colors.grey.shade400,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "Validar",
                                    style: TextStyle(fontSize: 18, color: Colors.black),
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
      ),
    );
  }

  Widget _buildEvidenciaButton(BuildContext context, String texto, bool completado, VoidCallback onPressed) {
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