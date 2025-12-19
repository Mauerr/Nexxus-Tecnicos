abstract class RegistroVehiculoState {}

class RegistroVehiculoInitial extends RegistroVehiculoState {}

class RegistroVehiculoLoading extends RegistroVehiculoState {}

class RegistroVehiculoSuccess extends RegistroVehiculoState {}

class RegistroVehiculoError extends RegistroVehiculoState {
  final String message;
  RegistroVehiculoError(this.message);
}