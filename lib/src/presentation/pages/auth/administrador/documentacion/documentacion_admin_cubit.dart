import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'documentacion_admin_state.dart';

class DocumentacionAdminCubit extends Cubit<DocumentacionAdminState> {
  final AuthService authService;

  DocumentacionAdminCubit(this.authService) : super(DocumentacionAdminInitial());

  Future<void> init() async {
    emit(DocumentacionAdminLoading());
    try {
      final cars = await authService.getAllCars();
      final docs = await authService.getAllCarDocuments();
      emit(DocumentacionAdminLoaded(cars: cars, allDocuments: docs, carDocuments: []));
    } catch (e) {
      emit(DocumentacionAdminError("Error al cargar la lista de vehículos: $e"));
    }
  }

  void selectCar(CarModel car) {
    if (state is DocumentacionAdminLoaded) {
      final currentState = state as DocumentacionAdminLoaded;
      final filteredDocs = currentState.allDocuments.where((doc) => doc['id_cars'] == car.id).toList();
      emit(currentState.copyWith(selectedCar: car, carDocuments: filteredDocs));
    }
  }

  void selectDocType(String type) {
    if (state is DocumentacionAdminLoaded) {
      emit((state as DocumentacionAdminLoaded).copyWith(selectedDocType: type));
    }
  }

  Future<void> pickFile() async {
    if (state is DocumentacionAdminLoaded) {
      final currentState = state as DocumentacionAdminLoaded;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        emit(currentState.copyWith(selectedFile: result.files.single));
      }
    }
  }

  Future<void> uploadDocument() async {
    if (state is DocumentacionAdminLoaded) {
      final currentState = state as DocumentacionAdminLoaded;
      
      if (currentState.selectedCar == null || currentState.selectedDocType == null) {
        emit(DocumentacionAdminError("Por favor selecciona un vehículo y el tipo de documento."));
        emit(currentState); // Volver al estado cargado
        return;
      }

      emit(currentState.copyWith(isUploading: true));

      try {
        print("🛠️ [Cubit] Preparando envío al backend...");
        print("   -> ID Vehículo: ${currentState.selectedCar!.id}");
        print("   -> Tipo Doc: ${currentState.selectedDocType}");
        print("   -> Archivo: ${currentState.selectedFile?.path ?? 'Ninguno (vacío)'}");

        final success = await authService.uploadCarDocument(
          idCars: currentState.selectedCar!.id!,
          typeDoc: currentState.selectedDocType!,
          filePath: currentState.selectedFile?.path, // Opcional según la documentación
        );

        if (success) {
          emit(DocumentacionAdminSuccess("Documento guardado correctamente."));
          
          // Recargar todos los documentos para actualizar la lista
          final newDocs = await authService.getAllCarDocuments();
          final filteredDocs = newDocs.where((doc) => doc['id_cars'] == currentState.selectedCar!.id).toList();

          // Limpiar archivo y tipo para permitir subir otro
          emit(currentState.copyWith(
            isUploading: false, selectedFile: null, selectedDocType: null,
            allDocuments: newDocs, carDocuments: filteredDocs,
          ));
        } else {
          throw Exception("El servidor devolvió un error.");
        }
      } catch (e) {
        emit(DocumentacionAdminError("Error al subir el documento: $e"));
        emit(currentState.copyWith(isUploading: false));
      }
    }
  }
}