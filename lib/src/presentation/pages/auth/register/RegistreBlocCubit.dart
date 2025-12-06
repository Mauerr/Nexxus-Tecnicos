import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegisterBlocState.dart';
import 'package:nexxus/src/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class Registrebloccubit extends Cubit<Registerblocstate> {
  Registrebloccubit() : super(RegisterInitial());

  // Password validation regex
  static final passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$');

  // Controllers
  final _nameController = BehaviorSubject<String>();
  final _lastnameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Streams
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get lastnameStream => _lastnameController.stream;
  Stream<String> get phoneStream => _phoneController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  // Métodos de validación
  void ChangeName(String name) {
    if (name.isNotEmpty && name.length < 2) {
      _nameController.sink.addError('El nombre es muy corto');
    } else {
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
    // Solo acepta correos gmail.com o hotmail.com
    bool valid = RegExp(r'^[\w\.-]+@(gmail|hotmail)\.com$').hasMatch(email);

    if (email.length < 5) {
      _emailController.sink.addError('El correo es muy corto');
    } else if (!valid) {
      _emailController.sink.addError('Debe ser @gmail.com o @hotmail.com');
    } else {
      _emailController.sink.add(email);
    }
  }

  void ChangePhone(String phone) {
    if (phone.isNotEmpty && phone.length < 10) {
      _phoneController.sink.addError('El teléfono es muy corto');
    } else {
      _phoneController.sink.add(phone);
    }
  }

  void ChangePassword(String password) {
    if (password.isNotEmpty && password.length < 6) {
      _passwordController.sink.addError('Al menos 6 caracteres');
    } else if (password.isNotEmpty && !passwordRegex.hasMatch(password)) {
      _passwordController.sink.addError(
          'Debe contener mayúscula, minúscula, número y carácter especial');
    } else {
      _passwordController.sink.add(password);
    }
  }

  // Limpiar valores al salir
  void dispose() {
    ChangeName('');
    ChangeLastName('');
    ChangePhone('');
    ChangeEmail('');
    ChangePassword('');
  }

  // Validación final del formulario
  Stream<bool> get validateForm => Rx.combineLatest5(
  nameStream,
  lastnameStream,
  phoneStream,
  emailStream,
  passwordStream,
  (a, b, c, d, e) => true,
);


  // Registro final
  void register() async {
    emit(RegisterLoading());

    final success = await AuthService().register(
      name: _nameController.value,
      lastname: _lastnameController.value,
      phone: _phoneController.value,
      email: _emailController.value,
      password: _passwordController.value,
    );

    if (success) {
      emit(RegisterSuccess());
    } else {
      emit(RegisterError("No se pudo registrar el usuario"));
    }
  }
}
