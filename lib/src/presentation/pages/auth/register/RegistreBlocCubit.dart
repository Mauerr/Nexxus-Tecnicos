import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegisterBlocState.dart';
import 'package:rxdart/rxdart.dart';

class Registrebloccubit extends Cubit <Registerblocstate> {
  Registrebloccubit():super(RegisterInitial());

  // Password validation regex
  static final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$');
 
  //Referenciar Atributos
  // Creacion de variables para controlar los TextField
  final _nameController = BehaviorSubject<String>();
  final _lastnameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmpasswordController = BehaviorSubject<String>();


  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get lastnameStream => _lastnameController.stream;
  Stream<String> get phoneStream => _phoneController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmpasswordStream => _confirmpasswordController.stream;

  //Metodos para obtener la informacion y validaciones

  void ChangeName(String name) {
    if (name.isNotEmpty && name.length < 2){
      _nameController.sink.addError('El nombre es muy corto');
    }else{
      _nameController.sink.add(name);
    }
  }

  void ChangeLastName(String lastname) {
    if (lastname.isNotEmpty && lastname.length < 2) {
      _lastnameController.sink.addError('El apellido es muy corto');
    } else {
      _lastnameController.sink.add(lastname);
    }
  }

  void ChangeEmail(String email) {
    // RegExp no cumple con el estándar RFC 5322 para correos electrónicos.
    bool emailFormatValid =
        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
    if (email.length < 5) {
      _emailController.sink.addError('El correo es muy corto');
    }else if(!emailFormatValid){
      _emailController.sink.addError('El formato no es valido');
    }
    else{
      _emailController.sink.add(email);
    }
  }

  void ChangePhone(String phone) {
    if (phone.isNotEmpty && phone.length < 10) {
      _phoneController.sink.addError('El telefono es muy corto');
    } else {
      _phoneController.sink.add(phone);
    }
  }

  // pendiente configurar que password sea igual a confirmPassword al validar

  void ChangePassword(String password) {
    if (password.isNotEmpty && password.length < 6) {
      _passwordController.sink.addError('Al menos 6 caracteres');
    } else if (password.isNotEmpty && !passwordRegex.hasMatch(password)) {
      _passwordController.sink.addError('Debe contener mayúscula, minúscula, número y carácter especial');
    } 
    else {
      _passwordController.sink.add(password);
    }
  }

  void ChangeConfirmPassword(String confirmPassword) {
    if (confirmPassword != _passwordController.valueOrNull) {
      _confirmpasswordController.sink.addError('Las contraseñas no coinciden');
    } else {
      _confirmpasswordController.sink.add(confirmPassword);
    }
  }
  // se Ejecuta Cuando se pase a otra pantalla para limpiar
  void dispose() {
    ChangeName('');
    ChangeLastName('');
    //ChangeEmail('');
    ChangePhone('');
    ChangePassword('');
    ChangeConfirmPassword('');
  }

  // crear validacion de combinacion de stream
  Stream<bool> get validateForm => Rx.combineLatest5(
    nameStream, 
    lastnameStream, 
    phoneStream, 
    passwordStream, 
    confirmpasswordStream, 
    (a, b, c, d, e) => true
  );

  //metodo impresion de valores
  void register() {
    print('Nombre: ${_nameController.value}');
    print('Apellido: ${_lastnameController.value}');
    print('Telefono: ${_phoneController.value}');
    //print('Correo: ${_emailController.value}');
    print('Contraseña: ${_passwordController.value}');
    print('Confirmar Contraseña: ${_confirmpasswordController.value}');
  }

}