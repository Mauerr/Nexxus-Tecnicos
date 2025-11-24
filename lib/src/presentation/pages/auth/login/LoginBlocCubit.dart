import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/data/dataSource/remote/services/AuthService.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocState.dart';
import 'package:rxdart_flutter/rxdart_flutter.dart';

class LoginBlocCubit extends Cubit<LoginblocState> {
  LoginBlocCubit() : super(LoginInitial());

  //Referenciar Atributos
  // Creacion de variables para controlar los TextField
  final _usuarioController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get usuarioStream => _usuarioController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  //instancia de servicio para poder llamar al metodo login
  Authservice authservice = Authservice();

  //creacion de metodos para capturar valores get
  void changeUsuario(String usuario) {
    if (usuario.isNotEmpty && usuario.length < 3) {
      _usuarioController.sink.addError(
        'Debe contener al menos 3 caracteres',
      );
    } else {
      _usuarioController.sink.add(usuario);
    }
  }

  void changepassword(String password) {
    if (password.isNotEmpty && password.length < 6) {
      _passwordController.sink.addError(
        'La contraseña debe contener al menos 6 caracteres',
      );
    } else {
      _passwordController.sink.add(password);
    }
  }

  //crear validacion de combinacion de stream
  Stream<bool> get validateForm =>
      Rx.combineLatest2(usuarioStream, passwordStream, (a, b) => true);

  void dispose() {
    // se Ejecuta Cuando se pase a otra pantalla
    changeUsuario('');
    changepassword('');
  }

  //metodo para llamar al servicio de login y pasar los parametros de usuario y password que vienen de los textfield
  void login() {
    print('usuario: ${_usuarioController.value}');
    print('password: ${_passwordController.value}');
    authservice.login(_usuarioController.value, _passwordController.value); 
  }
}
