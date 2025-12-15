import 'package:flutter/material.dart';
import 'package:nexxus/src/models/user_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../login/LoginPage.dart';
import '../administrador/homeAdmin.dart';
import '../tecnicos/inicio/home_screen.dart';


class SessionGate extends StatelessWidget {
  final AuthService authService;

  const SessionGate({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: authService.getLoggedUser(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const Loginpage();
        }

        /// 🔹 Tomamos el rol desde el modelo
        final role = user.roles.isNotEmpty
            ? user.roles.first.id.toString().toLowerCase()
            : null;

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
