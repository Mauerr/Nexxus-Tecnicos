import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/car_model.dart';

abstract class ValidacionVehiculosAdminState {}

class ValidacionVehiculosAdminInitial extends ValidacionVehiculosAdminState {}

class ValidacionVehiculosAdminLoading extends ValidacionVehiculosAdminState {}

class ValidacionVehiculosAdminActionSuccess extends ValidacionVehiculosAdminState {
  final String message;
  ValidacionVehiculosAdminActionSuccess(this.message);
}

class ValidacionVehiculosAdminLoaded extends ValidacionVehiculosAdminState {
  final List<CarModel> cars;
  ValidacionVehiculosAdminLoaded(this.cars);
}

class ValidacionVehiculosAdminError extends ValidacionVehiculosAdminState {
  final String message;
  ValidacionVehiculosAdminError(this.message);
}