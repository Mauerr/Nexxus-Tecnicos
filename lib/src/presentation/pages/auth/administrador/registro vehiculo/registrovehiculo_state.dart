import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

abstract class RegistroVehiculoState {}

class RegistroVehiculoInitial extends RegistroVehiculoState {}

class RegistroVehiculoLoading extends RegistroVehiculoState {}

class RegistroVehiculoActionSuccess extends RegistroVehiculoState {
  final String message;
  RegistroVehiculoActionSuccess(this.message);
}

class RegistroVehiculoLoaded extends RegistroVehiculoState {
  final List<CarModel> cars;
  RegistroVehiculoLoaded(this.cars);
}

class RegistroVehiculoError extends RegistroVehiculoState {
  final String message;
  RegistroVehiculoError(this.message);
}