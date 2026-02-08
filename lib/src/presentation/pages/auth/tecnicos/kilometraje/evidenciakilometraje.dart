import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_screen.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_state.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EvidenciaKilometrajeScreen extends StatefulWidget {
  final bool isEndDay; // Nuevo parámetro
  const EvidenciaKilometrajeScreen({super.key, this.isEndDay = false});

  @override
  State<EvidenciaKilometrajeScreen> createState() => _EvidenciaKilometrajeScreenState();
}

class _EvidenciaKilometrajeScreenState extends State<EvidenciaKilometrajeScreen> {
  final TextEditingController _kmController = TextEditingController();
  bool _isSending = false;
  bool _vehiculoAsignado = false;

  @override
  void initState() {
    super.initState();
    _checkAsignacion();
  }

  Future<void> _checkAsignacion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vehiculoAsignado = prefs.getBool("vehiculo_asignado") ?? false;
    });
  }

  @override
  void dispose() {
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _guardarValidacion() async {
    final prefs = await SharedPreferences.getInstance();
    // Guardamos en diferente llave si es fin de día
    String key = widget.isEndDay ? "kilometraje_end_ok" : "kilometraje_ok";
    await prefs.setBool(key, true);
  }

  // Método local para actualizar KM Final (PATCH) según el requerimiento
  Future<bool> _updateKmFinal(int userId, int km) async {
    try {
      final url = Uri.parse("http://10.15.14.20:3000/evidences/update/$userId");
      
      // Intentamos obtener el token si existe en preferencias (común en AuthService)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); 
      if (token == null) print("⚠️ Token no encontrado en SharedPreferences");
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final body = jsonEncode({
        "km_final": km,
        "end_lat": 19.4325,
        "end_lng": -99.1331
      });

      print("🚀 Sending PATCH to $url");
      print("👤 User ID enviado: $userId");
      print("📦 Body enviado: $body");
      final response = await http.patch(url, headers: headers, body: body);
      print("✅ Response Code: ${response.statusCode}");
      print("📄 Response Body: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("⚠️ Error en la respuesta del servidor: ${response.reasonPhrase}");
      }
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error updating final KM: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/img/background13.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),

            BlocBuilder<EvidenciaKilometrajeCubit, EvidenciaKilometrajeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      const Text(
                        "Evidencia de Kilometraje",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 60),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.isEndDay ? "KM Final:" : "KM Inicial:",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: _kmController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Ingrese kilometraje",
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(height: 30),

                            _buildEvidenciaButton(
                              context,
                              widget.isEndDay ? "Foto Odómetro Final" : "KM inicio del día",
                              state.fotoKmInicio != null,
                              () => context.read<EvidenciaKilometrajeCubit>().tomarFotoKmInicio(),
                            ),

                            const SizedBox(height: 40),

                            // 🔹 BOTÓN VALIDAR
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                onPressed: !_vehiculoAsignado
                                    ? () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("No tienes un vehículo asignado.")),
                                        );
                                      }
                                    : (state.fotoKmInicio != null && _kmController.text.isNotEmpty && !_isSending)
                                        ? () async {
                                            setState(() => _isSending = true);

                                            final authService = AuthService();
                                            final user = await authService.getLoggedUser();
                                            final km = int.tryParse(_kmController.text) ?? 0;
                                            
                                            // 🔹 Obtener ID de evidencia para subir la foto
                                            final prefs = await SharedPreferences.getInstance();
                                            final int? idEvidence = prefs.getInt('current_evidence_id');

                                            print("🔍 DEBUG: Iniciando proceso de validación...");
                                            print("   -> Usuario ID: ${user?.id}");
                                            print("   -> KM Ingresado: $km");
                                            print("   -> Foto presente: ${state.fotoKmInicio != null}");
                                            print("   -> Evidence ID (SharedPreferences): $idEvidence");

                                            if (user != null && user.id != null && idEvidence != null) {
                                              print("🚀 DEBUG: Enviando datos al backend...");
                                              
                                              bool successKm = false;
                                              
                                              if (widget.isEndDay) {
                                                // Lógica de FIN DE DÍA
                                                // Usamos el método local con el endpoint PATCH específico
                                                print("🚀 Enviando KM Final para Usuario ID: ${user.id}");
                                                successKm = await _updateKmFinal(user.id!, km);
                                              } else {
                                                // Lógica de INICIO DE DÍA
                                                successKm = await authService.updateEvidenceKm(
                                                  userId: user.id!.toString(),
                                                  km: km,
                                                  lat: 19.4325,
                                                  lng: -99.1331,
                                                  image: state.fotoKmInicio,
                                                );
                                              }

                                              // 2. Subir imagen (Endpoint evidences-img/create)
                                              print("⏳ DEBUG: Ejecutando uploadEvidencePhoto...");
                                              final successImg = await authService.uploadEvidencePhoto(
                                                idEvidence: idEvidence,
                                                typeEvidence: "kilometraje",
                                                typeImage: widget.isEndDay ? "km_final" : "km_inicial",
                                                typeStatus: widget.isEndDay ? "end" : "start",
                                                file: state.fotoKmInicio!,
                                              );
                                              print("✅ DEBUG: uploadEvidencePhoto finalizado. Resultado: $successImg");

                                              print("📡 DEBUG: Resultado KM: $successKm | IMG: $successImg");

                                              if (successKm && successImg) {
                                                print("✅ DEBUG: Éxito. Guardando localmente y saliendo.");
                                                if (widget.isEndDay) {
                                                  // 🔹 Lógica de RESET para Fin de Día: Limpiar todo para permitir nueva asignación
                                                  final prefs = await SharedPreferences.getInstance();
                                                  await prefs.remove("mecanica_ok");
                                                  await prefs.remove("kilometraje_ok");
                                                  await prefs.remove("kilometraje_end_ok");
                                                  await prefs.remove("hojalateria_ok");
                                                  await prefs.remove("tapiceria_ok");
                                                  await prefs.remove("vehiculo_asignado");
                                                  await prefs.remove("current_evidence_id");
                                                  await prefs.remove("assigned_car_id");
                                                  await prefs.remove("assigned_user_id");

                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Turno finalizado. Unidad desasignada.")),
                                                  );
                                                  Navigator.pop(context);
                                                } else {
                                                  await _guardarValidacion();
                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Evidencias enviadas correctamente")),
                                                  );
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                                                    (route) => false,
                                                  );
                                                }
                                              } else {
                                                print("❌ DEBUG: Falló el envío. Detalles:");
                                                print("   -> successKm: $successKm");
                                                print("   -> successImg: $successImg");
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Error al enviar evidencias")),
                                                );
                                              }
                                            } else {
                                              print("⚠️ DEBUG: Datos faltantes para el envío.");
                                              print("   -> User: $user");
                                              print("   -> User ID: ${user?.id}");
                                              print("   -> Evidence ID: $idEvidence");
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Error: Usuario o Asignación no identificados")),
                                              );
                                            }
                                            
                                            if (mounted) setState(() => _isSending = false);
                                          }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (state.fotoKmInicio != null && _kmController.text.isNotEmpty && _vehiculoAsignado)
                                      ? Colors.greenAccent
                                      : Colors.grey.shade400,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: _isSending
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                    : Text(
                                        "Validar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: (state.fotoKmInicio != null && _kmController.text.isNotEmpty && _vehiculoAsignado)
                                              ? Colors.black
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Botón de evidencia con check
  Widget _buildEvidenciaButton(
    BuildContext context,
    String texto,
    bool completado,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texto,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            if (completado) ...[
              const SizedBox(width: 12),
              const Icon(Icons.check_circle, color: Colors.green, size: 26),
            ],
          ],
        ),
      ),
    );
  }
}
