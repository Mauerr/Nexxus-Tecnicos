import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/revision%20de%20evidencia/revision_evidencia_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/administrador/revision%20de%20evidencia/revision_evidencia_state.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../barrilExportPath.dart'; // Ajusta esta ruta si es necesario (ej: ../../barrilExportPath.dart)
import 'package:shared_preferences/shared_preferences.dart';


class RevisionEvidenciaAdmin extends StatefulWidget {
  const RevisionEvidenciaAdmin({super.key});

  @override
  State<RevisionEvidenciaAdmin> createState() => _RevisionEvidenciaAdminState();
}

class _RevisionEvidenciaAdminState extends State<RevisionEvidenciaAdmin> {
  late RevisionEvidenciaCubit _cubit;
  List<dynamic> _localImages = [];
  bool _isLoadingLocal = false;
  String _formattedDate = "Sin fecha";
  String _assignedUser = "Sin asignar";

  @override
  void initState() {
    super.initState();
    _cubit = RevisionEvidenciaCubit(AuthService())..init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _fetchEvidence(int carId) async {
    setState(() {
      _isLoadingLocal = true;
      _formattedDate = "Sin fecha";
      _assignedUser = "Sin asignar";
    });
    print("🔵 [RevisionEvidencia] Iniciando petición para carId: $carId");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = Uri.parse('http://10.15.14.20:3000/evidences/car/$carId');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };
      final response = await http.get(url, headers: headers);

      print("🔵 [RevisionEvidencia] Respuesta HTTP: ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        print("🔵 [RevisionEvidencia] Tipo de dato recibido: ${decoded.runtimeType}");

        if (decoded is List) {
          final List<dynamic> data = decoded;
          print("🔵 [RevisionEvidencia] Cantidad de asignaciones: ${data.length}");
          
          // Obtener la fecha de la última evidencia (último elemento de la lista)
          String newDate = "Sin fecha";
          String newUser = "Sin asignar";
          if (data.isNotEmpty) {
            try {
              final lastItem = data.last;
              // Extraemos la fecha de id_assignment -> start_date como se solicitó
              final String? rawDate = lastItem['id_assignment']?['start_date'];
              
              if (rawDate != null) {
                final DateTime dt = DateTime.parse(rawDate).toLocal();
                final String day = dt.day.toString().padLeft(2, '0');
                final String month = dt.month.toString().padLeft(2, '0');
                final String year = dt.year.toString();
                final String hour = dt.hour.toString().padLeft(2, '0');
                final String minute = dt.minute.toString().padLeft(2, '0');
                newDate = "$day-$month-$year - $hour:$minute";
              }

              // Extraer nombre del usuario
              final userObj = lastItem['id_assignment']?['id_user'];
              if (userObj != null) {
                final String name = userObj['name'] ?? "";
                newUser = name;
              }
            } catch (e) {
              print("❌ [RevisionEvidencia] Error parseando fecha: $e");
            }
          }

          // Flatten images from all assignments safely
          final List<dynamic> allImages = data.expand((e) => ((e['images'] as List?) ?? [])).toList();
          
          print("✅ [RevisionEvidencia] Total de imágenes extraídas: ${allImages.length}");
          setState(() {
            _localImages = allImages;
            _formattedDate = newDate;
            _assignedUser = newUser;
          });
        } else {
          print("❌ [RevisionEvidencia] El cuerpo de la respuesta no es una lista.");
          setState(() => _localImages = []);
        }
      } else {
        print("❌ [RevisionEvidencia] Error en servidor: ${response.body}");
        setState(() => _localImages = []);
      }
    } catch (e) {
      print("❌ [RevisionEvidencia] Excepción al obtener evidencia: $e");
      setState(() => _localImages = []);
    } finally {
      setState(() => _isLoadingLocal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
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
                    final date = _formattedDate;
                    final user = _assignedUser;
                    
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
                                      if (car.id != null) {
                                        _fetchEvidence(car.id!);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Indicador de carga de evidencia
                            if (state.isLoadingEvidence || _isLoadingLocal)
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
                                  _evidenceButton(context, "Evidencias Mecánicas", _localImages, "mecanica"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Hojalatería", _localImages, "hojalateria"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Kilometraje", _localImages, "kilometraje"),
                                  const SizedBox(height: 20),
                                  _evidenceButton(context, "Evidencias Tapicería", _localImages, "tapiceria"),
                                  
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
    final filteredImages = allImages.where((img) {
      final type = img['type_evidence'];
      return type == typeFilter;
    }).toList();

    print("🔍 [BotonEvidencia] Filtro: '$typeFilter' | Total: ${allImages.length} | Encontradas: ${filteredImages.length}");
    if (filteredImages.isNotEmpty) {
      print("🔍 [BotonEvidencia] Ejemplo de data filtrada: ${filteredImages.first}");
    }

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
    print("🖼️ [ImageSlider] Abriendo slider con ${images.length} imágenes.");
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
                          print("🖼️ [ImageSlider] Procesando imagen index $index: $imgData");
                          // Support both 'path' (old) and 'image' (new) keys
                          String imgUrl = imgData['path'] ?? imgData['image'] ?? "";
                          if (!imgUrl.startsWith("http")) {
                            // Ensure slash exists for uploads/ path
                            String path = imgUrl.startsWith("/") ? imgUrl : "/$imgUrl";

                            // Fix: Agregar prefijo /media si la ruta es de uploads
                            if (path.startsWith("/uploads")) {
                              path = "/media$path";
                            }

                            // Use the IP provided
                            imgUrl = "http://10.15.14.20:3000$path";
                          }
                          print("🖼️ [ImageSlider] URL Final generada: $imgUrl");

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  imgUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("❌ [ImageSlider] Error cargando imagen ($imgUrl): $error");
                                    return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                                  },
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