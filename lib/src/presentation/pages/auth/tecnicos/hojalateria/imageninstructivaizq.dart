import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/hojalateria/evidenciaHojalateria_cubit.dart';


class ImagenInstructivaIzquierdo extends StatelessWidget {
  const ImagenInstructivaIzquierdo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await context.read<EvidenciaHojalateriaCubit>().tomarFotoIzquierdo();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'lib/ssets/imginstructiva.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}
