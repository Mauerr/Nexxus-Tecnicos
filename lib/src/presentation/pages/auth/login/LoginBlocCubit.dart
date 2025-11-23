import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'LoginBlocState.dart';
import 'package:nexxus/src/services/auth_service.dart';

class LoginBlocCubit extends Cubit<LoginState> {
  final AuthService authService;

  LoginBlocCubit(this.authService) : super(LoginInitial());

  final _usuarioController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  String _usuario = "";
  String _password = "";

  Stream<String> get usuarioStream => _usuarioController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  Stream<bool> get validateForm => Rx.combineLatest2(
        usuarioStream,
        passwordStream,
        (a, b) => a.toString().isNotEmpty && b.toString().isNotEmpty,
      );

  Function(String) get changeUsuario => (value) {
        _usuario = value.trim();
        _usuarioController.sink.add(_usuario);
      };

  Function(String) get changepassword => (value) {
        _password = value.trim();
        _passwordController.sink.add(_password);
      };

  Future<void> login() async {
    emit(LoginLoadingState());

    final result = await authService.login(_usuario, _password);

    if (result == null) {
      emit(LoginErrorState("Usuario o contraseña incorrectos"));
      return;
    }

    final role = result["role"];

    if (role == "admin") {
      emit(LoginSuccessAdminState());
    } else if (role == "tecnico") {
      emit(LoginSuccessTecnicoState());
    } else {
      emit(LoginErrorState("Rol desconocido"));
    }
  }

  void dispose() {
    _usuarioController.close();
    _passwordController.close();
  }
}
