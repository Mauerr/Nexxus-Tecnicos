abstract class Registerblocstate {}

class RegisterInitial extends Registerblocstate {}

class RegisterLoading extends Registerblocstate {}

class RegisterSuccess extends Registerblocstate {}

class RegisterError extends Registerblocstate {
  final String message;
  RegisterError(this.message);
}
