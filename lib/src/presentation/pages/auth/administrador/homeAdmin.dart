import 'package:flutter/material.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'barrilExportPath.dart';



class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Fondo principal
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),

            // 🔹 Contenido principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bienvenido Admin",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 60),

                  // 🔹 Botones principales
                  Center(
                    child: Column(
                      children: [
                        customButton(
                          context,
                          "Revisión de Evidencias",
                          const RevisionEvidenciaAdmin(),
                        ),
                        const SizedBox(height: 20),
                         customButton(
                          context,
                          "Registro de Vehículos",
                          const RegistroVehiculosAdmin(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Validación de Vehículos",
                          const OpcionesCarroAdmin(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Mantenimiento",
                          const MantenimientoAdminScreen(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Aprovisionamiento de Vehículos",
                          const AprovisionamientoAdmin(),
                        ),
                        const SizedBox(height: 20),
                        customButton(
                          context,
                          "Asignación de Rutas",
                          const AsignacionRutasAdmin(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Icono de salida (Logout)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Cerrar sesión',
                onPressed: () async {
                  await AuthService().clearSession();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Loginpage()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Botón personalizado con navegación dinámica
  Widget customButton(BuildContext context, String text, Widget destination) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
