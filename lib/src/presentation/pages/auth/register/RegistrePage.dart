import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexxus/src/presentation/pages/auth/register/RegistreBlocCubit.dart';
import 'package:nexxus/src/presentation/pages/auth/widgets/DefaultBotton.dart';
import 'package:nexxus/src/presentation/pages/auth/widgets/DefaultIconBack.dart';
import 'package:nexxus/src/presentation/pages/auth/widgets/DefaultTextfield.dart';

class Registrepage extends StatefulWidget {
  const Registrepage({super.key});

  @override
  State<Registrepage> createState() => _RegistrepageState();
}

class _RegistrepageState extends State<Registrepage> {

  Registrebloccubit? _registrebloccubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Desechar el cubit cuando se abandona la pantalla
      _registrebloccubit?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {

    _registrebloccubit = BlocProvider.of<Registrebloccubit>(context, listen: false);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/img/background13.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: Color.fromRGBO(0, 0, 0, 0.7),
              colorBlendMode: BlendMode.darken,
            ),
            // Funcion Icono Back
            Defaulticonback(izq: 5, top: 25),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.3),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 100),
                    Text(
                      'REGISTRO',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.nameStream,
                        builder: (context, asyncSnapshot) {
                          return DefaultTextfield(
                            label: 'Nombre',
                            icon: Icons.person,
                            errorText: asyncSnapshot.error?.toString(),
                            onChange: (text) {
                              _registrebloccubit?.ChangeName(text);
                            },
                          );
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.lastnameStream,
                        builder: (context, asyncSnapshot) {
                          return DefaultTextfield(
                            label: 'Apellido',
                            icon: Icons.person,
                            errorText: asyncSnapshot.error?.toString(),
                            onChange: (text) {
                              _registrebloccubit?.ChangeLastName(text);
                            },
                          );
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.phoneStream,
                        builder: (context, asyncSnapshot) {
                          return DefaultTextfield(
                            label: 'Telefono',
                            icon: Icons.phone,
                            errorText: asyncSnapshot.error?.toString(),
                            onChange: (text) {
                              _registrebloccubit?.ChangePhone(text);
                            },
                          );
                        }
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.passwordStream,
                        builder: (context, asyncSnapshot) {
                          return DefaultTextfield(
                            label: 'Contraseña',
                            icon: Icons.lock,
                            errorText: asyncSnapshot.error?.toString(),
                            //obscureText: true,
                            onChange: (text) {
                              _registrebloccubit?.ChangePassword(text);
                            },
                          );
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.confirmpasswordStream,
                        builder: (context, asyncSnapshot) {
                          return DefaultTextfield(
                            label: 'Confirmar Contraseña',
                            icon: Icons.lock_outline,
                            errorText: asyncSnapshot.error?.toString(),
                            //obscureText: true,
                            onChange: (text) {
                              _registrebloccubit?.ChangeConfirmPassword(text);
                            },
                          );
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 25,
                      ),
                      child: StreamBuilder(
                        stream: _registrebloccubit?.validateForm,
                        builder: (context, asyncSnapshot) {
                          return Defaultbotton(
                            text: 'Registrarse',
                            // Cambio de color de botón al validar
                            color: asyncSnapshot.hasData ? Colors.blue : Colors.grey,
                            onPressed: () {
                              if (asyncSnapshot.hasData) {
                                _registrebloccubit?.register();
                                //Navigator.pushNamed(context, 'login');
                              }
                              else{
                                Fluttertoast.showToast(
                                  msg: "Por favor completa todos los campos correctamente",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                                );
                              }
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
