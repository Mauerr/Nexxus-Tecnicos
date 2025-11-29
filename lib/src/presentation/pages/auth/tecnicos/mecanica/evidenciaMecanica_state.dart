import 'package:equatable/equatable.dart';
import 'dart:io';

class EvidenciaMecanicaState extends Equatable {
  final File? fotoAceite;
  final File? fotoFrenos;
  final File? fotoAnticongelante;

  const EvidenciaMecanicaState({
    this.fotoAceite,
    this.fotoFrenos,
    this.fotoAnticongelante,
  });

  bool get completado =>
      fotoAceite != null &&
      fotoFrenos != null &&
      fotoAnticongelante != null;

  EvidenciaMecanicaState copyWith({
    File? fotoAceite,
    File? fotoFrenos,
    File? fotoAnticongelante,
  }) {
    return EvidenciaMecanicaState(
      fotoAceite: fotoAceite ?? this.fotoAceite,
      fotoFrenos: fotoFrenos ?? this.fotoFrenos,
      fotoAnticongelante: fotoAnticongelante ?? this.fotoAnticongelante,
    );
  }

  @override
  List<Object?> get props => [fotoAceite, fotoFrenos, fotoAnticongelante];
}