import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'registrovehiculo_state.dart';

class RegistroVehiculoCubit extends Cubit<RegistroVehiculoState> {
  final AuthService authService;

  RegistroVehiculoCubit(this.authService) : super(RegistroVehiculoInitial());

  Future<void> loadCars() async {
    // No emitimos Loading aquí para evitar que se abra el diálogo bloqueante al entrar
    try {
      final cars = await authService.getAllCars();
      emit(RegistroVehiculoLoaded(cars));
    } catch (e) {
      print("Error al cargar la lista de vehículos: $e");
      // Emitimos una lista vacía en lugar de Error para evitar que el listener cierre la pantalla
      emit(RegistroVehiculoLoaded([])); 
    }
  }

  Future<void> registrarVehiculo({
    required String marca,
    required String modelo,
    required String yearStr,
    required String fechaAdq,
    required String color,
    required String matricula,
  }) async {
    if (marca.isEmpty || modelo.isEmpty || yearStr.isEmpty || color.isEmpty || matricula.isEmpty) {
      emit(RegistroVehiculoError("Por favor completa todos los campos requeridos"));
      return;
    }

    final int? year = int.tryParse(yearStr);
    if (year == null) {
      emit(RegistroVehiculoError("El año debe ser un número válido"));
      return;
    }

    emit(RegistroVehiculoLoading());

    final Map<String, dynamic> carData = {
      "marca": marca,
      "model": modelo,
      "year": year,
      "color": color,
      "matricula": matricula,
    };

    if (fechaAdq.isNotEmpty) {
      carData["fecha_adquisicion"] = fechaAdq;
    }

    print("🚀 [RegistroVehiculoCubit] Enviando solicitud para registrar unidad...");
    print("📦 [RegistroVehiculoCubit] Payload que se enviará: $carData");

    final success = await authService.registerCar(carData);

    print("📡 [RegistroVehiculoCubit] Resultado del registro: $success");

    if (success) {
      emit(RegistroVehiculoActionSuccess("Unidad registrada con éxito"));
      loadCars(); // Recargar la lista automáticamente
    } else {
      emit(RegistroVehiculoError("Error al registrar la unidad en el servidor"));
      loadCars(); // Recargar para no perder la vista de lista
    }
  }

  // 🔹 Método para Editar Vehículo
  Future<void> editarVehiculo({
    required int id,
    required String marca,
    required String modelo,
    required String yearStr,
    required String fechaAdq,
    required String color,
    required String matricula,
  }) async {
    if (marca.isEmpty || modelo.isEmpty || yearStr.isEmpty || color.isEmpty || matricula.isEmpty) {
      emit(RegistroVehiculoError("Por favor completa todos los campos requeridos"));
      return;
    }

    final int? year = int.tryParse(yearStr);
    if (year == null) {
      emit(RegistroVehiculoError("El año debe ser un número válido"));
      return;
    }

    print("🛠️ [Cubit] Enviando solicitud de edición para ID: $id");
    emit(RegistroVehiculoLoading());

    final Map<String, dynamic> carData = {
      "marca": marca,
      "model": modelo,
      "year": year,
      "color": color,
      "matricula": matricula,
    };

    if (fechaAdq.isNotEmpty) {
      carData["fecha_adquisicion"] = fechaAdq;
    }

    final success = await authService.updateCar(id, carData);

    print("🛠️ [Cubit] Respuesta de edición recibida. Éxito: $success");
    if (success) {
      emit(RegistroVehiculoActionSuccess("Unidad actualizada con éxito"));
      loadCars(); // Recargar lista para ver cambios
    } else {
      emit(RegistroVehiculoError("Error al actualizar la unidad"));
      loadCars();
    }
  }

  // 🔹 Método para Eliminar Vehículo
  Future<void> eliminarVehiculo(int id) async {
    print("🗑️ [Cubit] Enviando solicitud de eliminación para ID: $id");
    emit(RegistroVehiculoLoading());
    
    final success = await authService.deleteCar(id);

    print("🗑️ [Cubit] Respuesta de eliminación recibida. Éxito: $success");
    if (success) {
      emit(RegistroVehiculoActionSuccess("Unidad eliminada con éxito"));
      loadCars(); // Recargar lista
    } else {
      emit(RegistroVehiculoError("Error al eliminar la unidad"));
      loadCars();
    }
  }
}