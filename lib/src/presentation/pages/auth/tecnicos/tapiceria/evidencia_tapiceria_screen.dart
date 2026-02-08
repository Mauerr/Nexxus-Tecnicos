import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'evidenciaTapiceria_cubit.dart';
import 'evidenciaTapiceria_state.dart';

class EvidenciaTapiceriaScreen extends StatefulWidget {
  final bool isEndDay;
  const EvidenciaTapiceriaScreen({super.key, this.isEndDay = false});

  @override
  State<EvidenciaTapiceriaScreen> createState() => _EvidenciaTapiceriaScreenState();
}

class _EvidenciaTapiceriaScreenState extends State<EvidenciaTapiceriaScreen> {
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _verificarAsignacion();
  }

  Future<void> _verificarAsignacion() async {
    final prefs = await SharedPreferences.getInstance();
    final int? idEvidence = prefs.getInt('current_evidence_id');
    
    if (idEvidence == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Error de Asignación"),
          content: const Text("No se encontró el identificador de la asignación. Por favor regrese al inicio y vuelva a seleccionar la unidad."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Entendido"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _guardarEstatus() async {
    final prefs = await SharedPreferences.getInstance();
    String key = widget.isEndDay ? "tapiceria_end_ok" : "tapiceria_ok";
    await prefs.setBool(key, true);
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
                                  onPressed: (state.completado && !_isSending)
                                      ? () async {
                                          setState(() => _isSending = true);
                                          final authService = AuthService();
                                          
                                          // 🔹 Obtener ID dinámico
                                          final prefs = await SharedPreferences.getInstance();
                                          print("🔍 DEBUG: Buscando 'current_evidence_id' en SharedPreferences...");
                                          final int? idEvidence = prefs.getInt('current_evidence_id');
                                          print("🔍 DEBUG: ID encontrado: $idEvidence");

                                          if (idEvidence == null) {
                                            print("❌ ERROR: idEvidence es NULL. El usuario debe reasignar la unidad.");
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Error: No se encontró la asignación. Por favor reasigne la unidad.")),
                                            );
                                            setState(() => _isSending = false);
                                            return;
                                          }

                                          // 1. Subir Asientos Delanteros
                                          if (state.fotoAsientosDelanteros != null) {
                                            final success = await authService.uploadEvidencePhoto(
                                              idEvidence: idEvidence,
                                              typeEvidence: "tapiceria",
                                              typeImage: "asientos_d",
                                              typeStatus: widget.isEndDay ? "end" : "start",
                                              file: state.fotoAsientosDelanteros!,
                                            );
                                            print("📸 Asientos Delanteros upload success: $success");
                                            if (!success) print("❌ ERROR: Falló la subida de la foto Asientos Delanteros");
                                          }

                                          // 2. Subir Asientos Traseros
                                          if (state.fotoAsientosTraseros != null) {
                                            final success = await authService.uploadEvidencePhoto(
                                              idEvidence: idEvidence,
                                              typeEvidence: "tapiceria",
                                              typeImage: "asientos_t",
                                              typeStatus: widget.isEndDay ? "end" : "start",
                                              file: state.fotoAsientosTraseros!,
                                            );
                                            print("📸 Asientos Traseros upload success: $success");
                                            if (!success) print("❌ ERROR: Falló la subida de la foto Asientos Traseros");
                                          }

                                          // 3. Subir Tablero
                                          if (state.fotoTablero != null) {
                                            final success = await authService.uploadEvidencePhoto(
                                              idEvidence: idEvidence,
                                              typeEvidence: "tapiceria",
                                              typeImage: "tablero",
                                              typeStatus: widget.isEndDay ? "end" : "start",
                                              file: state.fotoTablero!,
                                            );
                                            print("📸 Tablero upload success: $success");
                                            if (!success) print("❌ ERROR: Falló la subida de la foto Tablero");
                                          }

                                          await _guardarEstatus();

                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Evidencias validadas correctamente")),
                                          );
                                          
                                          setState(() => _isSending = false);
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
                                  child: _isSending
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                        )
                                      : const Text(
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