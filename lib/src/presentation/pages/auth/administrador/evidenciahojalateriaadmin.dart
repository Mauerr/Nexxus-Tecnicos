import 'package:flutter/material.dart';
import 'barrilExportPath.dart';

class EvidenciaHojalateriaAdmin extends StatefulWidget {
  const EvidenciaHojalateriaAdmin({super.key});

  @override
  State<EvidenciaHojalateriaAdmin> createState() =>
      _EvidenciaHojalateriaAdminState();
}

class _EvidenciaHojalateriaAdminState extends State<EvidenciaHojalateriaAdmin> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imagenes = [
    'lib/assets/evidenciamecanica/carro1.jpg',
    'lib/assets/evidenciamecanica/carro2.jpg',
    'lib/assets/evidenciamecanica/carro3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con la imagen difuminada
            Image.asset(
              'assets/img/background13.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              colorBlendMode: BlendMode.darken,
            ),

            // Contenedor blanco con slider
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 20),

                    // Título
                    const Text(
                      "Evidencias Hojalateria",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Slider con imágenes a pantalla completa dentro del contenedor
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _imagenes.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              // Imagen principal
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  _imagenes[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),

                              // Botón de descarga
                              Positioned(
                                top: 15,
                                left: 15,
                                child: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  child: IconButton(
                                    icon: const Icon(Icons.download,
                                        color: Colors.white),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Descargando evidencia...'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Texto “Datos obligatorios de monitoreo”
                              Positioned(
                                bottom: 25,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Datos Obligatorios de Monitoreo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Indicadores del slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _imagenes.length,
                        (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: _currentPage == index ? 12 : 8,
                          height: _currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Botón salir
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const RevisionEvidenciaAdmin()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Salir",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
