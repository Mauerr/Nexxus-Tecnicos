import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import '../barrilExportPath.dart';
import 'documentacion_admin_cubit.dart';
import 'documentacion_admin_state.dart';
import 'package:url_launcher/url_launcher.dart';


class ArchivosVehiculoAdmin extends StatefulWidget {
  const ArchivosVehiculoAdmin({super.key});

  @override
  State<ArchivosVehiculoAdmin> createState() => _ArchivosVehiculoAdminState();
}

class _ArchivosVehiculoAdminState extends State<ArchivosVehiculoAdmin> {
  
  /// 🔹 Función para abrir el PDF externamente
  Future<void> _abrirDocumento(String path) async {
    final baseUrl = AuthService().baseUrl;
    
    // Limpiamos la ruta por si viene con una barra inicial
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    // Unimos la IP del backend agregando 'media/' antes de la ruta del archivo
    final fullUrl = "$baseUrl/media/$cleanPath";
    final uri = Uri.parse(fullUrl);
    
    try {
      // LaunchMode.externalApplication obliga a usar la app por defecto del sistema (visor PDF o navegador)
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No se pudo abrir el documento.")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al intentar abrir el archivo: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentacionAdminCubit(AuthService())..init(),
      child: BlocListener<DocumentacionAdminCubit, DocumentacionAdminState>(
        listener: (context, state) {
          if (state is DocumentacionAdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is DocumentacionAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                /// 🔹 Fondo con imagen oscurecida
                Image.asset(
                  'assets/img/background13.jpg',
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                  colorBlendMode: BlendMode.darken,
                ),

                /// 🔹 Contenido principal
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// 🔹 Header con botón salir
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const OpcionesCarroAdmin()),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              "Archivos del vehículo",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48), // Balance visual
                        ],
                      ),

                      const SizedBox(height: 30),

                      BlocBuilder<DocumentacionAdminCubit, DocumentacionAdminState>(
                        builder: (context, state) {
                          if (state is DocumentacionAdminLoading) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          }

                          if (state is DocumentacionAdminLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Seleccionar Unidad", style: TextStyle(color: Colors.white, fontSize: 18)),
                                const SizedBox(height: 10),
                                _buildDropdown<CarModel>(
                                  value: state.selectedCar,
                                  hint: "Seleccione una unidad",
                                  items: state.cars.map((car) => DropdownMenuItem(value: car, child: Text(car.label))).toList(),
                                  onChanged: (car) => context.read<DocumentacionAdminCubit>().selectCar(car!),
                                ),

                                const SizedBox(height: 20),

                                const Text("Tipo de Documento", style: TextStyle(color: Colors.white, fontSize: 18)),
                                const SizedBox(height: 10),
                                _buildDropdown<String>(
                                  value: state.selectedDocType,
                                  hint: "Seleccione tipo (Ej. poliza)",
                                  items: const [
                                    DropdownMenuItem(value: "poliza", child: Text("Póliza")),
                                    DropdownMenuItem(value: "tarjeta", child: Text("Tarjeta")),
                                    DropdownMenuItem(value: "verificacion", child: Text("Verificación")),
                                  ],
                                  onChanged: (type) => context.read<DocumentacionAdminCubit>().selectDocType(type!),
                                ),

                                const SizedBox(height: 30),

                                /// Botón cargar PDF
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => context.read<DocumentacionAdminCubit>().pickFile(),
                                    icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
                                    label: const Text("Elegir archivo PDF (Opcional)", style: TextStyle(fontSize: 18, color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ),
                                ),

                                /// 🔹 Mostrar nombre del PDF cargado
                                if (state.selectedFile != null) ...[
                                  const SizedBox(height: 15),
                    const Text(
                                    "Archivo seleccionado:",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.selectedFile!.name,
                                    style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontStyle: FontStyle.italic),
                                  ),
                                ],

                                const SizedBox(height: 40),

                                /// 🔹 Botón Subir al servidor
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state.isUploading ? null : () => context.read<DocumentacionAdminCubit>().uploadDocument(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: state.isUploading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text("Guardar Documento", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),

                                /// 🔹 HISTORIAL DE DOCUMENTOS DE LA UNIDAD
                                if (state.selectedCar != null) ...[
                                  const SizedBox(height: 40),
                                  const Divider(color: Colors.white54),
                                  const SizedBox(height: 20),
                                  const Text("Documentos Registrados", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  
                                  if (state.carDocuments.isEmpty)
                                    const Text("No hay documentos guardados para esta unidad.", style: TextStyle(color: Colors.white70)),
                                    
                                  if (state.carDocuments.isNotEmpty)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.carDocuments.length,
                                      itemBuilder: (context, index) {
                                        final doc = state.carDocuments[index];
                                        final type = doc['type_doc']?.toString().toUpperCase() ?? 'DOCUMENTO';
                                        final hasFile = doc['archivo'] != null && doc['archivo'].toString().trim().isNotEmpty;
                                        
                                        return Card(
                                          color: Colors.white.withOpacity(0.1),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          child: ListTile(
                                            leading: Icon(hasFile ? Icons.picture_as_pdf : Icons.insert_drive_file_outlined, color: hasFile ? Colors.greenAccent : Colors.white54, size: 30),
                                            title: Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            subtitle: Text(hasFile ? "Archivo guardado" : "Sin archivo", style: const TextStyle(color: Colors.white70)),
                                            trailing: hasFile ? const Icon(Icons.remove_red_eye, color: Colors.blueAccent) : const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
                                            onTap: hasFile ? () => _abrirDocumento(doc['archivo'].toString()) : null,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 40),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 20),

                      /// 🔹 Ir a datos de vehículo
                      customButton(
                        context,
                        "Ver Registro de Vehículos",
                        const ValidacionVehiculosAdmin(),
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Dropdown reutilizable
  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// 🔹 CustomButton estandarizado
  Widget customButton(BuildContext context, String text, Widget destination) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
