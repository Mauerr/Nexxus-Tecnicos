import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexxus/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/widgets/DefaultTextfield.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  LoginBlocCubit? _loginbloccubit;

  //se Ejecuta una sola vez cuando carga la pantalla
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _loginbloccubit?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    //inicializar _loginbloccubit para utilizar sus metodos
    _loginbloccubit = BlocProvider.of<LoginBlocCubit>(context, listen: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/img/background13.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.322),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 125),
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    //
                    child: StreamBuilder(
                      stream: _loginbloccubit?.usuarioStream,
                      builder: (context, asyncSnapshot) {
                        return DefaultTextfield(
                          label: 'Usuario',
                          icon: Icons.email,
                          errorText: asyncSnapshot.error?.toString(),
                          onChange: (text) {
                            //llamar _loginbloccubit
                            _loginbloccubit?.changeUsuario(text);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    child: StreamBuilder(
                      stream: _loginbloccubit?.passwordStream,
                      builder: (context, asyncSnapshot) {
                        return DefaultTextfield(
                          label: 'Contraseña',
                          icon: Icons.lock,
                          errorText: asyncSnapshot.error?.toString(),
                          obscureText: true,
                          onChange: (text) {
                            _loginbloccubit?.changepassword(text);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    height: 50,
                    child: StreamBuilder(
                      stream: _loginbloccubit?.validateForm,
                      builder: (context, asyncSnapshot) {
                        return ElevatedButton(
                          onPressed: () {
                            // IF validatorio de datos
                            if (asyncSnapshot.hasData) {
                              _loginbloccubit?.login();
                              Navigator.pushNamed(context, 'home');
                            } else {
                              print('no valido');
                              // muestra si los datos son incorrectos
                              Fluttertoast.showToast(
                                msg: 'El formulario no es valido',
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // cambio de color de boton
                            backgroundColor: asyncSnapshot.hasData
                                ? Colors.green
                                : Colors.grey,
                          ),
                          child: Text(
                            'INICIAR SESION',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  // 🔹 Nuevo botón "Iniciar como Administrador" (sin navegación de momento)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                            
                              Navigator.pushNamed(context, 'homeAdmin');
                            
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: const Text(
                      'INICIAR COMO ADMINISTRADOR',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Horizontal
                    children: [
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 5),
                      ),
                      Text(
                        'No tienes cuenta?',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 5),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'registro');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
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
