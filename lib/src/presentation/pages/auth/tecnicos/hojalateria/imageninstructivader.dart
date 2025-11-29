import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciaHojalateria_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciaHojalateria_state.dart';

class ImagenInstructivaDerecho extends StatelessWidget {
  const ImagenInstructivaDerecho({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await context.read<EvidenciaHojalateriaCubit>().tomarFotoDerecho();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'lib/assets/imginstructiva.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}
