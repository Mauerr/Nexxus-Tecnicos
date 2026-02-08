import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructiva.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivaizq.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivader.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivareverso.dart';
import 'package:nexxus/src/services/auth_service.dart';

import 'evidenciaHojalateria_cubit.dart';
import 'evidenciaHojalateria_state.dart';

class EvidenciaHojalateriaScreen extends StatefulWidget {
  final bool isEndDay;
  const EvidenciaHojalateriaScreen({super.key, this.isEndDay = false});

  @override
  State<EvidenciaHojalateriaScreen> createState() => _EvidenciaHojalateriaScreenState();
}

class _EvidenciaHojalateriaScreenState extends State<EvidenciaHojalateriaScreen> {
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EvidenciaHojalateriaCubit(),
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

              BlocBuilder<EvidenciaHojalateriaCubit, EvidenciaHojalateriaState>(
                builder: (blocContext, state) {
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
                          "Evidencia de Hojalatería",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 60),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _botonEvidencia(
                                  blocContext,
                                  "Frente",
                                  state.fotoFrente != null,
                                  const ImagenInstructivaFrente(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  blocContext,
                                  "Lateral Izquierdo",
                                  state.fotoIzquierdo != null,
                                  const ImagenInstructivaIzquierdo(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  blocContext,
                                  "Lateral Derecho",
                                  state.fotoDerecho != null,
                                  const ImagenInstructivaDerecho(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  blocContext,
                                  "Reverso",
                                  state.fotoReverso != null,
                                  const ImagenInstructivaReverso(),
                                ),

                                const SizedBox(height: 40),

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

                                            // 1. Subir Frente
                                            if (state.fotoFrente != null) {
                                              final success = await authService.uploadEvidencePhoto(
                                                idEvidence: idEvidence,
                                                typeEvidence: "hojalateria",
                                                typeImage: "frente",
                                                typeStatus: widget.isEndDay ? "end" : "start",
                                                file: state.fotoFrente!,
                                              );
                                              print("📸 Frente upload success: $success");
                                              if (!success) print("❌ ERROR: Falló la subida de la foto Frente");
                                            }

                                            // 2. Subir Izquierdo
                                            if (state.fotoIzquierdo != null) {
                                              final success = await authService.uploadEvidencePhoto(
                                                idEvidence: idEvidence,
                                                typeEvidence: "hojalateria",
                                                typeImage: "izq",
                                                typeStatus: widget.isEndDay ? "end" : "start",
                                                file: state.fotoIzquierdo!,
                                              );
                                              print("📸 Izquierdo upload success: $success");
                                              if (!success) print("❌ ERROR: Falló la subida de la foto Izquierdo");
                                            }

                                            // 3. Subir Derecho
                                            if (state.fotoDerecho != null) {
                                              final success = await authService.uploadEvidencePhoto(
                                                idEvidence: idEvidence,
                                                typeEvidence: "hojalateria",
                                                typeImage: "derecho",
                                                typeStatus: widget.isEndDay ? "end" : "start",
                                                file: state.fotoDerecho!,
                                              );
                                              print("📸 Derecho upload success: $success");
                                              if (!success) print("❌ ERROR: Falló la subida de la foto Derecho");
                                            }

                                            // 4. Subir Reverso
                                            if (state.fotoReverso != null) {
                                              final success = await authService.uploadEvidencePhoto(
                                                idEvidence: idEvidence,
                                                typeEvidence: "hojalateria",
                                                typeImage: "trasera",
                                                typeStatus: widget.isEndDay ? "end" : "start",
                                                file: state.fotoReverso!,
                                              );
                                              print("📸 Reverso upload success: $success");
                                              if (!success) print("❌ ERROR: Falló la subida de la foto Reverso");
                                            }

                                            // Guardar validación localmente
                                            String key = widget.isEndDay ? "hojalateria_end_ok" : "hojalateria_ok";
                                            await prefs.setBool(key, true);

                                            if (!mounted) return;
                                            setState(() => _isSending = false);
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
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonEvidencia(
    BuildContext context,
    String texto,
    bool completado,
    Widget destino,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<EvidenciaHojalateriaCubit>(),
                child: destino,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(texto, style: const TextStyle(fontSize: 20, color: Colors.black)),
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
