import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/revision%20de%20evidencia/revision_evidencia_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/revision%20de%20evidencia/revision_evidencia_state.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../barrilExportPath.dart'; // Ajusta esta ruta si es necesario (ej: ../../barrilExportPath.dart)


class RevisionEvidenciaAdmin extends StatelessWidget {
  const RevisionEvidenciaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RevisionEvidenciaCubit(AuthService())..init(),
      child: Scaffold(
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

              // 🔹 Contenido
              BlocBuilder<RevisionEvidenciaCubit, RevisionEvidenciaState>(
                builder: (context, state) {
                  if (state is RevisionEvidenciaLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  if (state is RevisionEvidenciaError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => context.read<RevisionEvidenciaCubit>().init(),
                              child: const Text("Reintentar"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is RevisionEvidenciaLoaded) {
                    // Extraer datos para mostrar
                    final date = state.evidenceData?['created_at'] ?? "Sin fecha";
                    // Ajustar según la estructura real de tu JSON (ej. user.name o user_name)
                    final user = state.evidenceData?['user']?['name'] ?? state.evidenceData?['user_name'] ?? "Sin asignar";
                    
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            // 🔹 Botón salir (icono superior)
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                tooltip: 'Cerrar sesión',
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeAdmin()),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🔹 Título
                            const Center(
                              child: Text(
                                "Revisión de Evidencias",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // 🔹 Selector de Unidad
                            const Text(
                              "Seleccionar Unidad",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<CarModel>(
                                  value: state.selectedCar,
                                  isExpanded: true,
                                  hint: const Text("Seleccione una unidad"),
                                  items: state.cars.map((car) {
                                    return DropdownMenuItem(
                                      value: car,
                                      child: Text(car.label),
                                    );
                                  }).toList(),
                                  onChanged: (car) {
                                    if (car != null) {
                                      context.read<RevisionEvidenciaCubit>().selectCar(car);
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Indicador de carga de evidencia
                            if (state.isLoadingEvidence)
                              const Center(child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.white),
                              )),

                            // 🔹 Fecha
                            const Text(
                              "Fecha última evidencia",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                state.selectedCar == null ? "-" : date,
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Usuario asignado
                            const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Usuario Asignado",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                state.selectedCar == null ? "-" : user,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // 🔹 Botones de Evidencias (con Slide)
                            Center(
                              child: Column(
                                children: [
                                  _evidenceButton(context, "Evidencias Mecánicas", state.images, "mecanica"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Hojalatería", state.images, "hojalateria"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Kilometraje", state.images, "kilometraje"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Tapicería", state.images, "tapiceria"),
                                  
                                  const SizedBox(height: 30),

                                  // 🔹 Botón salir (inferior)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HomeAdmin()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      child: const Text(
                                        "Salir",
                                        style: TextStyle(fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _evidenceButton(BuildContext context, String text, List<dynamic> allImages, String typeFilter) {
    final filteredImages = allImages.where((img) => img['type_evidence'] == typeFilter).toList();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: filteredImages.isEmpty
            ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No hay imágenes para esta categoría")))
            : () => _showImageSlider(context, text, filteredImages),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 20, color: Colors.black)),
            if (filteredImages.isNotEmpty) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                child: Text("${filteredImages.length}", style: const TextStyle(color: Colors.white, fontSize: 12)),
              )
            ]
          ],
        ),
      ),
    );
  }

  void _showImageSlider(BuildContext context, String title, List<dynamic> images) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final imgData = images[index];
                          String imgUrl = imgData['path'] ?? "";
                          if (!imgUrl.startsWith("http")) {
                            imgUrl = "http://10.15.14.20:3000$imgUrl";
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  imgUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                imgData['type_image']?.toString().toUpperCase() ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text("${index + 1} / ${images.length}"),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 30),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}