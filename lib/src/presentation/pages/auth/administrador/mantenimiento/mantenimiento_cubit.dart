import 'dart:async';
import 'package:rxdart/rxdart.dart'; // ← IMPORTANTE

class MaintenanceCubit {
  final _tipoController = StreamController<String>.broadcast();
  final _kmController = StreamController<String>.broadcast();
  final _mecanicoController = StreamController<String>.broadcast();

  Stream<String> get tipoStream => _tipoController.stream;
  Stream<String> get kmStream => _kmController.stream;
  Stream<String> get mecanicoStream => _mecanicoController.stream;

  Function(String) get changeTipo => _tipoController.sink.add;
  Function(String) get changeKm => _kmController.sink.add;
  Function(String) get changeMecanico => _mecanicoController.sink.add;

  Stream<bool> get formValidStream => Rx.combineLatest3(
        tipoStream,
        kmStream,
        mecanicoStream,
        (a, b, c) => true,
      );

  void dispose() {
    _tipoController.close();
    _kmController.close();
    _mecanicoController.close();
  }
}
