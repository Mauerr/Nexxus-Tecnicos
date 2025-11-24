import 'package:flutter/material.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/homeAdmin.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/home_screen.dart';

class SessionGate extends StatelessWidget {
  final AuthService authService;

  const SessionGate({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: authService.getSession(),
      builder: (context, snapshot) {
        // Mientras carga SharedPreferences
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;

        if (session == null) {
          // No hay sesión → Login
          return const Loginpage();
        }

        final role = session['role'];

        if (role == 'admin') {
          return const HomeAdmin();
        } else if (role == 'tecnico') {
          return const HomeScreen();
        }

        // Rol raro/desconocido → por seguridad, al login
        return const Loginpage();
      },
    );
  }
}
