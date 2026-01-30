import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

abstract class RevisionEvidenciaState {}

class RevisionEvidenciaInitial extends RevisionEvidenciaState {}

class RevisionEvidenciaLoading extends RevisionEvidenciaState {}

class RevisionEvidenciaError extends RevisionEvidenciaState {
  final String message;
  RevisionEvidenciaError(this.message);
}

class RevisionEvidenciaLoaded extends RevisionEvidenciaState {
  final List<CarModel> cars;
  final CarModel? selectedCar;
  final Map<String, dynamic>? evidenceData; // Datos generales (fecha, usuario)
  final List<dynamic> images; // Lista de imágenes de la evidencia
  final bool isLoadingEvidence; // Loading específico al cambiar de carro

  RevisionEvidenciaLoaded({
    required this.cars,
    this.selectedCar,
    this.evidenceData,
    this.images = const [],
    this.isLoadingEvidence = false,
  });

  RevisionEvidenciaLoaded copyWith({
    List<CarModel>? cars,
    CarModel? selectedCar,
    Map<String, dynamic>? evidenceData,
    List<dynamic>? images,
    bool? isLoadingEvidence,
  }) {
    return RevisionEvidenciaLoaded(
      cars: cars ?? this.cars,
      selectedCar: selectedCar ?? this.selectedCar,
      evidenceData: evidenceData ?? this.evidenceData,
      images: images ?? this.images,
      isLoadingEvidence: isLoadingEvidence ?? this.isLoadingEvidence,
    );
  }
}