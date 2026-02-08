import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/mecanica/evidenciaMecanica_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/mecanica/evidenciaMecanica_state.dart';
import 'package:nexxus/src/services/auth_service.dart';

class EvidenciaMecanicaScreen extends StatefulWidget {
  final bool isEndDay;
  const EvidenciaMecanicaScreen({super.key, this.isEndDay = false});

  @override
  State<EvidenciaMecanicaScreen> createState() => _EvidenciaMecanicaScreenState();
}

class _EvidenciaMecanicaScreenState extends State<EvidenciaMecanicaScreen> {
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
      // Mostrar alerta y salir si no hay ID
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Error de Asignación"),
          content: const Text("No se encontró el identificador de la asignación. Por favor regrese al inicio y vuelva a seleccionar la unidad."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Regresar a Home
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
    String key = widget.isEndDay ? "mecanica_end_ok" : "mecanica_ok";
    await prefs.setBool(key, true);
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
                                onPressed: (state.completado && !_isSending)
                                    ? () async {
                                        setState(() => _isSending = true);
                                        final authService = AuthService();
                                        
                                        // 🔹 Obtener ID dinámico guardado en la asignación
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

                                        // 1. Subir Aceite
                                        if (state.fotoAceite != null) {
                                          final success = await authService.uploadEvidencePhoto(
                                            idEvidence: idEvidence, // ID dinámico
                                            typeEvidence: "mecanica",
                                            typeImage: "aceite",
                                            typeStatus: widget.isEndDay ? "end" : "start",
                                            file: state.fotoAceite!,
                                          );
                                          print("📸 Aceite upload success: $success");
                                        }

                                        // 2. Subir Frenos
                                        if (state.fotoFrenos != null) {
                                          final success = await authService.uploadEvidencePhoto(
                                            idEvidence: idEvidence,
                                            typeEvidence: "mecanica",
                                            typeImage: "frenos",
                                            typeStatus: widget.isEndDay ? "end" : "start",
                                            file: state.fotoFrenos!,
                                          );
                                          print("📸 Frenos upload success: $success");
                                        }

                                        // 3. Subir Anticongelante
                                        if (state.fotoAnticongelante != null) {
                                          final success = await authService.uploadEvidencePhoto(
                                            idEvidence: idEvidence,
                                            typeEvidence: "mecanica",
                                            typeImage: "anticongelante",
                                            typeStatus: widget.isEndDay ? "end" : "start",
                                            file: state.fotoAnticongelante!,
                                          );
                                          print("📸 Anticongelante upload success: $success");
                                        }

                                        // 🔹 Guardar completado
                                        await _guardarEstatus();

                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Evidencias validadas correctamente"),
                                          ),
                                        );

                                        setState(() => _isSending = false);
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
                                child: _isSending
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                      )
                                    : const Text(
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
