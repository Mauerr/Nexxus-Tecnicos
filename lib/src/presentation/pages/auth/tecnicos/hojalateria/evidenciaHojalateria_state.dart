import 'dart:io';

class EvidenciaHojalateriaState {
  final File? fotoFrente;
  final File? fotoIzquierdo;
  final File? fotoDerecho;
  final File? fotoReverso;

  EvidenciaHojalateriaState({
    this.fotoFrente,
    this.fotoIzquierdo,
    this.fotoDerecho,
    this.fotoReverso,
  });

  bool get completado =>
      fotoFrente != null &&
      fotoIzquierdo != null &&
      fotoDerecho != null &&
      fotoReverso != null;

  EvidenciaHojalateriaState copyWith({
    File? fotoFrente,
    File? fotoIzquierdo,
    File? fotoDerecho,
    File? fotoReverso,
  }) {
    return EvidenciaHojalateriaState(
      fotoFrente: fotoFrente ?? this.fotoFrente,
      fotoIzquierdo: fotoIzquierdo ?? this.fotoIzquierdo,
      fotoDerecho: fotoDerecho ?? this.fotoDerecho,
      fotoReverso: fotoReverso ?? this.fotoReverso,
    );
  }
}
