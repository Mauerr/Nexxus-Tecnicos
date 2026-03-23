import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'validaciondevehiculoadmin_state.dart';

class ValidacionVehiculosAdminCubit extends Cubit<ValidacionVehiculosAdminState> {
  final AuthService authService;

  ValidacionVehiculosAdminCubit(this.authService) : super(ValidacionVehiculosAdminInitial());

  Future<void> loadCars() async {
    try {
      final cars = await authService.getAllCars();
      emit(ValidacionVehiculosAdminLoaded(cars));
    } catch (e) {
      print("Error al cargar la lista de vehículos: $e");
      emit(ValidacionVehiculosAdminLoaded([])); 
    }
  }

  Future<void> registrarVehiculo({
    required String marca,
    required String modelo,
    required String yearStr,
    required String color,
    required String matricula,
  }) async {
    if (marca.isEmpty || modelo.isEmpty || yearStr.isEmpty || color.isEmpty || matricula.isEmpty) {
      emit(ValidacionVehiculosAdminError("Por favor completa todos los campos"));
      return;
    }

    final int? year = int.tryParse(yearStr);
    if (year == null) {
      emit(ValidacionVehiculosAdminError("El año debe ser un número válido"));
      return;
    }

    emit(ValidacionVehiculosAdminLoading());

    final carData = {
      "marca": marca,
      "model": modelo,
      "year": year,
      "color": color,
      "matricula": matricula,
    };

    final success = await authService.registerCar(carData);

    if (success) {
      emit(ValidacionVehiculosAdminActionSuccess("Unidad registrada con éxito"));
      loadCars();
    } else {
      emit(ValidacionVehiculosAdminError("Error al registrar la unidad en el servidor"));
      loadCars();
    }
  }

  Future<void> editarVehiculo({
    required int id,
    required String marca,
    required String modelo,
    required String yearStr,
    required String color,
    required String matricula,
  }) async {
    if (marca.isEmpty || modelo.isEmpty || yearStr.isEmpty || color.isEmpty || matricula.isEmpty) {
      emit(ValidacionVehiculosAdminError("Por favor completa todos los campos"));
      return;
    }

    final int? year = int.tryParse(yearStr);
    if (year == null) {
      emit(ValidacionVehiculosAdminError("El año debe ser un número válido"));
      return;
    }

    emit(ValidacionVehiculosAdminLoading());

    final carData = {
      "marca": marca,
      "model": modelo,
      "year": year,
      "color": color,
      "matricula": matricula,
    };

    final success = await authService.updateCar(id, carData);

    if (success) {
      emit(ValidacionVehiculosAdminActionSuccess("Unidad actualizada con éxito"));
      loadCars();
    } else {
      emit(ValidacionVehiculosAdminError("Error al actualizar la unidad"));
      loadCars();
    }
  }

  Future<void> eliminarVehiculo(int id) async {
    emit(ValidacionVehiculosAdminLoading());
    
    final success = await authService.deleteCar(id);

    if (success) {
      emit(ValidacionVehiculosAdminActionSuccess("Unidad eliminada con éxito"));
      loadCars();
    } else {
      emit(ValidacionVehiculosAdminError("Error al eliminar la unidad"));
      loadCars();
    }
  }
}