import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistreBlocCubit.dart';

final List<BlocProvider> blocProviders = [
  BlocProvider<LoginBlocCubit>(create: (context) => LoginBlocCubit()),
  BlocProvider<Registrebloccubit>(create: (context) => Registrebloccubit()),
];
