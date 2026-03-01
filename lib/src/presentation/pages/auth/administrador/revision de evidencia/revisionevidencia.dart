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
  
  List<dynamic> _allEvidences = [];
  List<Map<String, dynamic>> _availableUsers = [];
  String? _selectedUserId;
  DateTimeRange? _selectedDateRange;

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
      _allEvidences = [];
      _availableUsers = [];
      _selectedUserId = null;
      _selectedDateRange = null;
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
          
          // Extraer usuarios únicos para el filtro
          final Map<String, Map<String, dynamic>> usersMap = {};
          for (var item in data) {
            final user = item['id_assignment']?['id_user'];
            if (user != null) {
              final id = user['id']?.toString();
              final name = user['name'];
              if (id != null && name != null) {
                usersMap[id] = {'id': id, 'name': name};
              }
            }
          }

          setState(() {
            _allEvidences = data;
            _availableUsers = usersMap.values.toList();
            _applyFilters();
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

  void _applyFilters() {
    List<dynamic> filtered = List.from(_allEvidences);

    // 1. Filtro por Usuario
    if (_selectedUserId != null) {
      filtered = filtered.where((item) {
        final userId = item['id_assignment']?['id_user']?['id']?.toString();
        return userId == _selectedUserId;
      }).toList();
    }

    // 2. Filtro por Rango de Fechas
    if (_selectedDateRange != null) {
      filtered = filtered.where((item) {
        final dateStr = item['id_assignment']?['start_date'];
        if (dateStr == null) return false;
        final date = DateTime.tryParse(dateStr);
        if (date == null) return false;
        
        // Comparación inclusiva (start <= date < end + 1 dia)
        return date.isAfter(_selectedDateRange!.start.subtract(const Duration(seconds: 1))) && 
               date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    final List<dynamic> newImages = filtered.expand((e) => ((e['images'] as List?) ?? [])).toList();

    setState(() {
      _localImages = newImages;
    });
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _applyFilters();
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

                            // 🔹 Filtros (Usuario y Fecha)
                            if (state.selectedCar != null) ...[
                              const Text(
                                "Filtros",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Dropdown Usuario
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedUserId,
                                    isExpanded: true,
                                    hint: const Text("Filtrar por Usuario"),
                                    items: [
                                      const DropdownMenuItem(value: null, child: Text("Todos los usuarios")),
                                      ..._availableUsers.map((u) => DropdownMenuItem(
                                        value: u['id'].toString(),
                                        child: Text(u['name']),
                                      )),
                                    ],
                                    onChanged: (val) {
                                      setState(() => _selectedUserId = val);
                                      _applyFilters();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Selector de Fechas
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                                  label: Text(
                                    _selectedDateRange == null 
                                      ? "Seleccionar Rango de Fechas" 
                                      : "Del ${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} al ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}",
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  onPressed: () => _pickDateRange(context),
                                ),
                              ),
                              if (_selectedDateRange != null || _selectedUserId != null)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedDateRange = null;
                                        _selectedUserId = null;
                                      });
                                      _applyFilters();
                                    },
                                    child: const Text("Limpiar Filtros", style: TextStyle(color: Colors.redAccent)),
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],

                            // 🔹 Indicador de carga de evidencia
                            if (state.isLoadingEvidence || _isLoadingLocal)
                              const Center(child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.white),
                              )),

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