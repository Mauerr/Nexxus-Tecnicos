import 'dart:io';

class EvidenciaKilometrajeState {
  final File? fotoKmInicio;
  final File? fotoKmFin;
  final File? fotoAsientosDel;
  final File? fotoAsientosTras;

  bool get completado =>
      fotoKmInicio != null &&
      fotoKmFin != null &&
      fotoAsientosDel != null &&
      fotoAsientosTras != null;

  const EvidenciaKilometrajeState({
    this.fotoKmInicio,
    this.fotoKmFin,
    this.fotoAsientosDel,
    this.fotoAsientosTras,
  });

  EvidenciaKilometrajeState copyWith({
    File? fotoKmInicio,
    File? fotoKmFin,
    File? fotoAsientosDel,
    File? fotoAsientosTras,
  }) {
    return EvidenciaKilometrajeState(
      fotoKmInicio: fotoKmInicio ?? this.fotoKmInicio,
      fotoKmFin: fotoKmFin ?? this.fotoKmFin,
      fotoAsientosDel: fotoAsientosDel ?? this.fotoAsientosDel,
      fotoAsientosTras: fotoAsientosTras ?? this.fotoAsientosTras,
    );
  }
}
