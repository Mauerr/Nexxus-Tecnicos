import 'dart:async';

class AsignacionRutasCubit {
  final _rutaController = StreamController<String>.broadcast();
  final _obsController = StreamController<String>.broadcast();

  // GETTERS
  Stream<String> get rutaStream => _rutaController.stream;
  Stream<String> get obsStream => _obsController.stream;

  // SETTERS
  Function(String) get changeRuta => _rutaController.sink.add;
  Function(String) get changeObservaciones => _obsController.sink.add;

  void dispose() {
    _rutaController.close();
    _obsController.close();
  }
}
