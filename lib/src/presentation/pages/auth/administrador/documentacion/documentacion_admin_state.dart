import 'package:file_picker/file_picker.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

abstract class DocumentacionAdminState {}

class DocumentacionAdminInitial extends DocumentacionAdminState {}

class DocumentacionAdminLoading extends DocumentacionAdminState {}

class DocumentacionAdminLoaded extends DocumentacionAdminState {
  final List<CarModel> cars;
  final CarModel? selectedCar;
  final String? selectedDocType;
  final PlatformFile? selectedFile;
  final bool isUploading;
  final List<dynamic> allDocuments;
  final List<dynamic> carDocuments;

  DocumentacionAdminLoaded({
    required this.cars,
    this.selectedCar,
    this.selectedDocType,
    this.selectedFile,
    this.isUploading = false,
    this.allDocuments = const [],
    this.carDocuments = const [],
  });

  DocumentacionAdminLoaded copyWith({
    List<CarModel>? cars,
    CarModel? selectedCar,
    String? selectedDocType,
    PlatformFile? selectedFile,
    bool? isUploading,
    List<dynamic>? allDocuments,
    List<dynamic>? carDocuments,
  }) {
    return DocumentacionAdminLoaded(
      cars: cars ?? this.cars,
      selectedCar: selectedCar ?? this.selectedCar,
      selectedDocType: selectedDocType ?? this.selectedDocType,
      selectedFile: selectedFile ?? this.selectedFile,
      isUploading: isUploading ?? this.isUploading,
      allDocuments: allDocuments ?? this.allDocuments,
      carDocuments: carDocuments ?? this.carDocuments,
    );
  }
}

class DocumentacionAdminSuccess extends DocumentacionAdminState {
  final String message;
  DocumentacionAdminSuccess(this.message);
}

class DocumentacionAdminError extends DocumentacionAdminState {
  final String message;
  DocumentacionAdminError(this.message);
}