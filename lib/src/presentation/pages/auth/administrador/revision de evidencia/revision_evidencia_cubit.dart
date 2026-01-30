import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'revision_evidencia_state.dart';

class RevisionEvidenciaCubit extends Cubit<RevisionEvidenciaState> {
  final AuthService authService;

  RevisionEvidenciaCubit(this.authService) : super(RevisionEvidenciaInitial());

  Future<void> init() async {
    try {
      print("🔵 [RevisionEvidenciaCubit] Iniciando carga de vehículos...");
      emit(RevisionEvidenciaLoading());
      final cars = await authService.getAllCars();
      print("✅ [RevisionEvidenciaCubit] Vehículos cargados: ${cars.length}");
      emit(RevisionEvidenciaLoaded(cars: cars));
    } catch (e) {
      print("❌ [RevisionEvidenciaCubit] Error CRÍTICO en init: $e");
      
      String errorMessage = "Error al cargar la lista de vehículos: $e";

      // Detección específica de Token Expirado (401)
      if (e.toString().contains("401") || e.toString().contains("token_not_valid") || e.toString().contains("Token is expired")) {
        print("⚠️ [RevisionEvidenciaCubit] Detectado error 401 (Token Expirado).");
        errorMessage = "Tu sesión ha expirado. Por favor cierra sesión e ingresa nuevamente.";
      }

      emit(RevisionEvidenciaError(errorMessage));
    }
  }

  Future<void> selectCar(CarModel car) async {
    if (state is RevisionEvidenciaLoaded) {
      final currentState = state as RevisionEvidenciaLoaded;
      
      print("🔵 [RevisionEvidenciaCubit] Seleccionando carro: ${car.label} (ID: ${car.id})");

      // Emitir estado de carga parcial manteniendo la lista de carros
      emit(currentState.copyWith(
        selectedCar: car,
        isLoadingEvidence: true,
        evidenceData: null, // Limpiar datos anteriores
        images: [],
      ));

      try {
        // 1. Obtener datos de la evidencia (ID, Fecha, Usuario)
        print("🔄 [RevisionEvidenciaCubit] Buscando última evidencia para carro ID ${car.id}...");
        final evidenceData = await authService.getLatestEvidenceByCar(car.id!);
        print("✅ [RevisionEvidenciaCubit] Datos de evidencia recibidos: $evidenceData");
        
        List<dynamic> images = [];
        
        // 2. Si hay evidencia, obtener las imágenes usando el ID
        if (evidenceData != null && evidenceData['id'] != null) {
          final int evidenceId = evidenceData['id']; // Asegúrate que el backend devuelva 'id'
          
          print("🔄 [RevisionEvidenciaCubit] Buscando imágenes para evidencia ID: $evidenceId");
          images = await authService.getEvidenceImages(evidenceId);
          print("✅ [RevisionEvidenciaCubit] Imágenes encontradas: ${images.length}");
        } else {
          print("⚠️ [RevisionEvidenciaCubit] No se encontró evidencia reciente o ID nulo.");
        }

        emit(currentState.copyWith(
          selectedCar: car,
          isLoadingEvidence: false,
          evidenceData: evidenceData,
          images: images,
        ));
      } catch (e) {
        print("❌ [RevisionEvidenciaCubit] Error cargando evidencia: $e");
        
        if (e.toString().contains("401")) {
             print("⚠️ [RevisionEvidenciaCubit] Token expirado durante la selección de carro.");
        }

        emit(currentState.copyWith(selectedCar: car, isLoadingEvidence: false));
      }
    }
  }
}