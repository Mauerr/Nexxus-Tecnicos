import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocState.dart';

import 'package:nexxus/src/presentation/pages/auth/widgets/DefaultTextfield.dart';

import '../administrador/homeAdmin.dart';
import '../tecnicos/inicio/home_screen.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late LoginBlocCubit _loginCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener cubit
    _loginCubit = BlocProvider.of<LoginBlocCubit>(context, listen: false);

    return Scaffold(
      body: BlocListener<LoginBlocCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            Fluttertoast.showToast(msg: "Validando credenciales...");
          }

          if (state is LoginErrorState) {
            Fluttertoast.showToast(msg: state.message);
          }

          if (state is LoginSuccessAdminState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeAdmin()),
            );
          }

          if (state is LoginSuccessTecnicoState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🔹 Fondo
            Image.asset(
              'assets/img/background13.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),

            /// 🔹 Contenedor de login
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.32),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 125),
                  const Text(
                  'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 🔹 Usuario
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: StreamBuilder(
                      stream: _loginCubit.usuarioStream,
                      builder: (_, snapshot) {
                        return DefaultTextfield(
                          label: 'Usuario',
                          icon: Icons.email,
                          errorText: snapshot.error?.toString(),
                          onChange: _loginCubit.changeUsuario,
                        );
                      },
                    ),
                  ),

                  // 🔹 Contraseña
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: StreamBuilder(
                      stream: _loginCubit.passwordStream,
                      builder: (_, snapshot) {
                        return DefaultTextfield(
                          label: 'Contraseña',
                          icon: Icons.lock,
                          obscureText: true,
                          errorText: snapshot.error?.toString(),
                          onChange: _loginCubit.changepassword,
                        );
                      },
                    ),
                  ),

                  // 🔹 Botón iniciar sesión
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 15,
                    ),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _loginCubit.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'INICIAR SESION',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "No tienes cuenta?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                  // Registrar
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 15,
                    ),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, 'registro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'REGISTRATE',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
