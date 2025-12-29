import 'dart:io';

class EvidenciaTapiceriaState {
  final File? fotoAsientosDelanteros;
  final File? fotoAsientosTraseros;
  final File? fotoTablero;

  const EvidenciaTapiceriaState({
    this.fotoAsientosDelanteros,
    this.fotoAsientosTraseros,
    this.fotoTablero,
  });

  bool get completado =>
      fotoAsientosDelanteros != null &&
      fotoAsientosTraseros != null &&
      fotoTablero != null;

  EvidenciaTapiceriaState copyWith({
    File? fotoAsientosDelanteros,
    File? fotoAsientosTraseros,
    File? fotoTablero,
  }) {
    return EvidenciaTapiceriaState(
      fotoAsientosDelanteros:
          fotoAsientosDelanteros ?? this.fotoAsientosDelanteros,
      fotoAsientosTraseros:
          fotoAsientosTraseros ?? this.fotoAsientosTraseros,
      fotoTablero: fotoTablero ?? this.fotoTablero,
    );
  }
}