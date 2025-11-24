import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nexxus/src/blocProviders.dart';
import 'package:nexxus/src/presentation/pages/auth/login/Logingate.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeAdmin.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistrePage.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidencia_mecanica.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Creamos una sola instancia de AuthService para toda la app
  final authService = AuthService();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders(authService),
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Nexxus Técnicos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        // 🔹 Ya no usamos initialRoute; usamos SessionGate como home
        home: SessionGate(authService: authService),

        routes: {
          'login': (BuildContext context) => const Loginpage(),
          'registro': (BuildContext context) => const Registrepage(),
          'home': (BuildContext context) => const HomeScreen(),
          'homeAdmin': (BuildContext context) => const HomeAdmin(),
          'evidencia-meca': (BuildContext context) => const EvidenciaMecanicaScreen(),
        },
      ),
    );
  }
}
