import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nexxus/src/blocProviders.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistrePage.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/home_screen.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeAdmin.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidencia_mecanica.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: blocProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Nexxus App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      /// 🔥 Ruta inicial siempre es login (luego haremos auto-login)
      initialRoute: 'login',

      routes: {
        'login': (context) => const Loginpage(),
        'registro': (context) => const Registrepage(),
        'home': (context) => const HomeScreen(),
        'homeAdmin': (context) => const HomeAdmin(),
        'evidencia-meca': (context) => const EvidenciaMecanicaScreen(),
      },
    );
  }
}
