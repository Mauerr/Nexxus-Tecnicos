import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistreBlocCubit.dart';
import 'package:nexxus/src/services/auth_service.dart';

final List<BlocProvider> blocProviders = [
  BlocProvider<LoginBlocCubit>(
    create: (context) => LoginBlocCubit(AuthService()),
  ),

  BlocProvider<Registrebloccubit>(
    create: (context) => Registrebloccubit(),
  ),
];
