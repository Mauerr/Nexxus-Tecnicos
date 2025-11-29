import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructiva.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivaizq.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivader.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/imageninstructivareverso.dart';

import 'evidenciaHojalateria_cubit.dart';
import 'evidenciaHojalateria_state.dart';

class EvidenciaHojalateriaScreen extends StatelessWidget {
  const EvidenciaHojalateriaScreen({super.key});

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
                                  context,
                                  "Frente",
                                  state.fotoFrente != null,
                                  const ImagenInstructivaFrente(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  context,
                                  "Lateral Izquierdo",
                                  state.fotoIzquierdo != null,
                                  const ImagenInstructivaIzquierdo(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  context,
                                  "Lateral Derecho",
                                  state.fotoDerecho != null,
                                  const ImagenInstructivaDerecho(),
                                ),

                                const SizedBox(height: 20),

                                _botonEvidencia(
                                  context,
                                  "Reverso",
                                  state.fotoReverso != null,
                                  const ImagenInstructivaReverso(),
                                ),

                                const SizedBox(height: 40),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: ElevatedButton(
                                    onPressed: state.completado
                                        ? () async {
                                            await context
                                                .read<EvidenciaHojalateriaCubit>()
                                                .guardarValidacion();

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
