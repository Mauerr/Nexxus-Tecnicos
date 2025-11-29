import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciaHojalateria_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciaHojalateria_state.dart';

// Cubit + State correctos


/// 👉 Imagen instructiva PARA EL FRENTE
class ImagenInstructivaFrente extends StatelessWidget {
  const ImagenInstructivaFrente({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvidenciaHojalateriaCubit, EvidenciaHojalateriaState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              /// 👉 TAP PARA TOMAR LA FOTO REAL
              onTap: () async {
                await context.read<EvidenciaHojalateriaCubit>().tomarFotoFrente();

                Navigator.pop(context); // regresar a la lista
              },

              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Imagen instructiva',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Center(
                    child: Image.asset(
                      'lib/assets/imginstructiva.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
