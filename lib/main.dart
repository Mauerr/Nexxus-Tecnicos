import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexxus/src/blocProviders.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeAdmin.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistrePage.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/evidencia_mecanica.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => Loginpage(),
          'registro': (BuildContext context) => Registrepage(),
          'home': (BuildContext context) => HomeScreen(),
          'homeAdmin': (BuildContext context) => HomeAdmin(),
          'evidencia-meca': (BuildContext context) => EvidenciaMecanicaScreen(),
        },
      ),
    );
  }
}