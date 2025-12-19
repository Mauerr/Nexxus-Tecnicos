import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'registrovehiculo_state.dart';

class RegistroVehiculoCubit extends Cubit<RegistroVehiculoState> {
  final AuthService authService;

  RegistroVehiculoCubit(this.authService) : super(RegistroVehiculoInitial());

  Future<void> registrarVehiculo({
    required String marca,
    required String modelo,
    required String yearStr,
    required String color,
    required String matricula,
  }) async {
    if (marca.isEmpty || modelo.isEmpty || yearStr.isEmpty || color.isEmpty || matricula.isEmpty) {
      emit(RegistroVehiculoError("Por favor completa todos los campos"));
      return;
    }

    final int? year = int.tryParse(yearStr);
    if (year == null) {
      emit(RegistroVehiculoError("El año debe ser un número válido"));
      return;
    }

    emit(RegistroVehiculoLoading());

    final carData = {
      "marca": marca,
      "model": modelo,
      "year": year,
      "color": color,
      "matricula": matricula,
    };

    final success = await authService.registerCar(carData);

    if (success) {
      emit(RegistroVehiculoSuccess());
    } else {
      emit(RegistroVehiculoError("Error al registrar la unidad en el servidor"));
    }
  }
}