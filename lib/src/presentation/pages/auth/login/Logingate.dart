import 'package:flutter/material.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../login/LoginPage.dart';
import '../administrador/homeAdmin.dart';
import '../tecnicos/home_screen.dart';

class SessionGate extends StatelessWidget {
  final AuthService authService;

  const SessionGate({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: authService.getSession(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;

        if (session == null) {
          return const Loginpage();
        }

        final role = session["role"];

        if (role == "admin") {
          return const HomeAdmin();
        }

        if (role == "tec") {
          return const HomeScreen();
        }

        return const Loginpage();
      },
    );
  }
}
