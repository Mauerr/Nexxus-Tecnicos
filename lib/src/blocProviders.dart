import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistreBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/inicio/home_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/mecanica/evidenciaMecanica_cubit.dart';
import 'package:nexxus/src/presentation/pages/auth/tecnicos/kilometraje/kilometraje_cubit.dart';
import 'package:nexxus/src/services/auth_service.dart';

List<BlocProvider> blocProviders(AuthService authService) {
  return [
    BlocProvider<LoginBlocCubit>(
      create: (context) => LoginBlocCubit(authService),
    ),
    BlocProvider<Registrebloccubit>(
      create: (context) => Registrebloccubit(),
    ),
    BlocProvider<EvidenciaMecanicaCubit>(
    create: (_) => EvidenciaMecanicaCubit(),
    ),
    BlocProvider(
    create: (_) => EvidenciaKilometrajeCubit(),
    ),
    BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(authService:authService)..loadCars(),
      
    ),
  ];
}





