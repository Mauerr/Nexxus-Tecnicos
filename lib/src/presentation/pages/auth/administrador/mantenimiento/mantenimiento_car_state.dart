import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

abstract class MantenimientoCarState {}

class MantenimientoCarLoading extends MantenimientoCarState {}

class MantenimientoCarLoaded extends MantenimientoCarState {
  final List<CarModel> cars;
  final CarModel? selectedCar;

  MantenimientoCarLoaded({required this.cars, this.selectedCar});
}

class MantenimientoCarError extends MantenimientoCarState {
  final String message;
  MantenimientoCarError(this.message);
}