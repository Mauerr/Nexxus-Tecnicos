import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AprovisionamientoCubit {
  final _cableadoController = StreamController<String>.broadcast();
  final _fibraController = StreamController<String>.broadcast();
  final _radioController = StreamController<String>.broadcast();

  // Streams
  Stream<String> get cableadoStream => _cableadoController.stream;
  Stream<String> get fibraStream => _fibraController.stream;
  Stream<String> get radioStream => _radioController.stream;

  // Setters
  Function(String) get changeCableado => _cableadoController.sink.add;
  Function(String) get changeFibra => _fibraController.sink.add;
  Function(String) get changeRadio => _radioController.sink.add;

  // Validación
  Stream<bool> get formValidStream => Rx.combineLatest3(
        cableadoStream,
        fibraStream,
        radioStream,
        (a, b, c) => true,
      );

  void dispose() {
    _cableadoController.close();
    _fibraController.close();
    _radioController.close();
  }
}
