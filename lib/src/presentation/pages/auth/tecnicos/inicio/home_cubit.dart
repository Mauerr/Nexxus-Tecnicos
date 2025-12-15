import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_state.dart';
import 'package:nexxus/src/services/auth_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthService authService;

  HomeCubit({required this.authService}) : super(HomeLoading()) {
    loadCars();
  }

  Future<void> loadCars() async {
    try {
      emit(HomeLoading());

      final cars = await authService.getAllCars();

      if (cars.isEmpty) {
        emit(HomeError("No hay unidades asignadas"));
        return;
      }

      emit(
        HomeLoaded(
          cars: cars,
          selectedCar: cars.first,
        ),
      );
    } catch (e) {
      // Log del error para depuración
      print("Error en HomeCubit loadCars: $e");

      // Detectar si el token expiró (Error 401)
      if (e.toString().contains("401") || e.toString().contains("Token is expired")) {
        emit(HomeError("Tu sesión ha expirado. Por favor cierra sesión e ingresa nuevamente."));
      } else {
        emit(HomeError("No fue posible cargar las unidades. $e"));
      }
    }
  }

  void changeCar(CarModel car) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;

      emit(
        HomeLoaded(
          cars: current.cars,
          selectedCar: car,
        ),
      );
    }
  }
}
