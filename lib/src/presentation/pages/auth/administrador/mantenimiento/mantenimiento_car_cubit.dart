import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'mantenimiento_car_state.dart';

class MantenimientoCarCubit extends Cubit<MantenimientoCarState> {
  final AuthService authService;

  MantenimientoCarCubit({required this.authService}) : super(MantenimientoCarLoading()) {
    loadCars();
  }

  Future<void> loadCars() async {
    try {
      emit(MantenimientoCarLoading());
      final cars = await authService.getAllCars();

      if (cars.isEmpty) {
        emit(MantenimientoCarError("No hay unidades disponibles"));
        return;
      }

      // Inicialmente seleccionamos el primero o ninguno, según prefieras.
      // HomeScreen selecciona el primero por defecto.
      emit(MantenimientoCarLoaded(cars: cars, selectedCar: cars.first));
    } catch (e) {
      emit(MantenimientoCarError("Error al cargar unidades: $e"));
    }
  }

  void changeCar(CarModel car) {
    if (state is MantenimientoCarLoaded) {
      final current = state as MantenimientoCarLoaded;
      emit(MantenimientoCarLoaded(cars: current.cars, selectedCar: car));
    }
  }
}