abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;
  LoginErrorState(this.message);
}

class LoginSuccessAdminState extends LoginState {}

class LoginSuccessTecnicoState extends LoginState {}
