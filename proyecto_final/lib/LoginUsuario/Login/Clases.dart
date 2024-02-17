// ignore_for_file: file_names, prefer_final_fields, use_build_context_synchronously, avoid_print

// Importaciones necesarias
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/identificacion/Identificaci%C3%B3nWeb.dart';
import 'package:proyecto_final/identificacion/reconocimiento_facial.dart';
import 'package:proyecto_final/loginRecuperacion/LoginRecuperacion.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';
import '../../models/ip/local.dart';
import '../prueba.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  final ThemeManager themeManager;
  late TabController tabController;
  Login({Key? key, required this.tabController, required this.themeManager})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Login> createState() => _LoginState(tabController: tabController);
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // Futuros que realizan la biomertria y el login en plataformas android.

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  late TabController tabController;
  // Constructor para inicializar el estado
  _LoginState({required this.tabController});

  bool _isObscure = true; // Estado para ocultar/mostrar la contraseña

  // Controladores para los campos de correo electrónico y contraseña
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Método para realizar la autenticación y navegar a la pantalla principal
  Future logInV2() async {
    try {
      // Intentar iniciar sesión utilizando Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Verificar si la autenticación fue exitosa
      if (userCredential.user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreenPage(
              themeManager: widget.themeManager,
            ),
          ),
        );
        // Alert que indica que inicio con huella
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2500),
            elevation: 10,
            backgroundColor: primaryColor,
            content: Text(
              'Ingresaste con tu huella dactilar y credenciales.....',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // Capturar y mostrar el error en caso de falla de autenticación
      print(e);
      //falta de credenciales.
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('StayAway'),
              content: const Text('Error al verificar credenciales.'),
              actions: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Cerrar'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    }
  }

  // Metodo que realiza la autenticacion por huella dactilar.
  Future<void> _authenticate(BuildContext context) async {
    try {
      final isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Coloca tu dedo en el sensor de huella dactilar',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        // Biometría exitosa, mostrar modal y luego cargar otra ventana.2
        logInV2();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2500),
            elevation: 10,
            backgroundColor: primaryColor,
            content: Text(
              'Cancelaste la autenticación. ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error durante la autenticación: $e');
    }
  }

  // Función asincrónica para realizar el inicio de sesión
  Future logIn() async {
    // Navegar a la pantalla de reconocimiento facial o identificación web
    if (UniversalPlatform.isAndroid) {
      bool hasBiometrics = await _localAuthentication.canCheckBiometrics;
      if (hasBiometrics) {
        // El dispositivo tiene un sensor de huella dactilar
        _authenticate(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            elevation: 10,
            backgroundColor: primaryColor,
            content: Text(
              'Lo siento, tu dispositivo no cuenta con escaner de huellas... Pero podemos auntenticar de otras formas.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReconocimientoFacial(
              themeManager: widget.themeManager,
              email: _emailController.text.trim(),
              contrasena: _passwordController.text.trim(),
            ),
          ),
        );
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IdentificacionWeb(
            themeManager: widget.themeManager,
            email: _emailController.text.trim(),
            contrasena: _passwordController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Liberar recursos cuando el widget sea eliminado
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      // Verificación de la anchura de la pantalla para realizar ajustes responsivos
      if (responsive.maxWidth == 375) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0x20D2D2D2),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                PreferredSize(
                    preferredSize: const Size.fromHeight(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              TabBar(
                                controller: tabController,
                                isScrollable: true,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                indicatorColor: Colors.white,
                                labelStyle: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                                tabs: const [
                                  Tab(
                                    text: 'Sign in',
                                  ),
                                  Tab(
                                    text: 'Sign up',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                /*
                    Las vistas tanto del registro como del inicio de sesion estan dentro de un expanded
                    porque me daba un error entonce la unica forma de que encontre de que funcionara fue con un exoanded
                    donde le di un tamaño con el flex
                    * */
                Expanded(
                  flex: 5,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      // Primera vista del tab que es el login
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: TextField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: _emailController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: 'Email',
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: TextField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: _passwordController,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: Icon(_isObscure
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          }),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Ir a recuperación de contraseña
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginRecuperacionPage(
                                                    themeManager:
                                                        widget.themeManager,
                                                  )));
                                    },
                                    child: const Text(
                                      '¿Olvido la contraseña?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 65),
                              child: InkWell(
                                onTap: () {
                                  // Función de login
                                  logIn();
                                },
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Iniciar Sesión',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 40)
                          ],
                        ),
                      ),
                      // La opción de registro se implementó en una clase diferente
                      Register(
                        themeManager: widget.themeManager,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (responsive.maxWidth <= 300) {
        // Diseño para pantallas con anchura máxima de 300
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            child: Container(
                decoration: BoxDecoration(
                  color: //Colors.black,
                      const Color(0x20D2D2D2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  TabBar(
                                    controller: tabController,
                                    isScrollable: true,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white,
                                    indicatorColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    tabs: const [
                                      Tab(
                                        text: 'Sign in',
                                      ),
                                      Tab(
                                        text: 'Sign up',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Vista para iniciar sesión
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'DelaGothicOne',
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, right: 30),
                                      child: Text(
                                        'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white
                                            //fontFamily: 'DelaGothicOne'
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    //height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1.0, right: 1.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _emailController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: Colors.grey[200],
                                          filled: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    //height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1.0, right: 1.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _passwordController,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                  _isObscure
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  size: 17),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = !_isObscure;
                                                });
                                              }),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Ir a recuperación de contraseña
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginRecuperacionPage(
                                                        themeManager:
                                                            widget.themeManager,
                                                      )));
                                        },
                                        child: const Text(
                                          '¿Olvido la contraseña?',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: InkWell(
                                    onTap: () {
                                      // Función de login
                                      logIn();
                                    },
                                    child: Container(
                                      width: 120,
                                      height: 45,
                                      padding: const EdgeInsets.all(13.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Iniciar Sesión',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(height: 40)
                              ],
                            ),
                          ),
                          // Vista para el registro
                          Register(
                            themeManager: widget.themeManager,
                          )
                        ],
                      ),
                    ),
                  ],
                )));
      } else if (responsive.maxWidth <= 500) {
        // Diseño para pantallas con anchura máxima de 500
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  TabBar(
                                    controller: tabController,
                                    isScrollable: true,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white,
                                    indicatorColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    tabs: const [
                                      Tab(
                                        text: 'Sign in',
                                      ),
                                      Tab(
                                        text: 'Sign up',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 5,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Vista para iniciar sesión
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 33,
                                            fontFamily: 'DelaGothicOne',
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, right: 30),
                                      child: Text(
                                        'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white
                                            //fontFamily: 'DelaGothicOne'
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _emailController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _passwordController,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = !_isObscure;
                                                });
                                              }),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Ir a recuperación de contraseña
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginRecuperacionPage(
                                                        themeManager:
                                                            widget.themeManager,
                                                      )));
                                        },
                                        child: const Text(
                                          '¿Olvido la contraseña?',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // Función de login
                                        logIn();
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(height: 40)
                              ],
                            ),
                          ),
                          // Vista para el registro
                          Register(
                            themeManager: widget.themeManager,
                          )
                        ],
                      ),
                    ),
                  ],
                )));
      } else if (responsive.maxWidth >= 1000) {
        // Diseño para pantallas con anchura mínima de 1000
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 30.0),
            child: Row(
              children: [
                // Columna izquierda con información
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'StayAway',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontFamily: 'CroissantOne'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Text(
                            "Descubre destinos inexplorados, "
                            "vive experiencias únicas y crea recuerdos que "
                            "durarán toda la vida. ¡Únete a la comunidad viajera "
                            "y haz realidad tus sueños de viaje!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'CroissantOne'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                // Columna derecha con pestañas de inicio de sesión y registro
                Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0x20D2D2D2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Barra de pestañas
                            PreferredSize(
                                preferredSize: const Size.fromHeight(30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          TabBar(
                                            controller: tabController,
                                            isScrollable: true,
                                            labelColor: Colors.white,
                                            unselectedLabelColor: Colors.white,
                                            indicatorColor: Colors.white,
                                            labelStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            tabs: const [
                                              Tab(
                                                text: 'Sign in',
                                              ),
                                              Tab(
                                                text: 'Sign up',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 6,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  // Vista para iniciar sesión
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 50),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 25),
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    fontFamily: 'DelaGothicOne',
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25, right: 30),
                                              child: Text(
                                                'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white
                                                    //fontFamily: 'DelaGothicOne'
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              child: TextField(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                controller: _emailController,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  hintText: 'Email',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black),
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              child: TextField(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                controller: _passwordController,
                                                obscureText: _isObscure,
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                      icon: Icon(_isObscure
                                                          ? Icons.visibility_off
                                                          : Icons.visibility),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isObscure =
                                                              !_isObscure;
                                                        });
                                                      }),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Password',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black),
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // Ir a recuperación de contraseña
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginRecuperacionPage(
                                                                themeManager: widget
                                                                    .themeManager,
                                                              )));
                                                },
                                                child: const Text(
                                                  '¿Olvido la contraseña?',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0),
                                          child: InkWell(
                                            onTap: () {
                                              // Función de login
                                              logIn();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Iniciar Sesión',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const SizedBox(height: 20)
                                      ],
                                    ),
                                  ),
                                  // Vista para el registro
                                  Register(
                                    themeManager: widget.themeManager,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )))
              ],
            ));
      } else {
        // Diseño para pantallas con anchura menor a 1000
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // Barra de pestañas
                    PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  TabBar(
                                    controller: tabController,
                                    isScrollable: true,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white,
                                    indicatorColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    tabs: const [
                                      Tab(
                                        text: 'Sign in',
                                      ),
                                      Tab(
                                        text: 'Sign up',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 5,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Vista para iniciar sesión
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 33,
                                            fontFamily: 'DelaGothicOne',
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, right: 30),
                                      child: Text(
                                        'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white
                                            //fontFamily: 'DelaGothicOne'
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _emailController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _passwordController,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(_isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = !_isObscure;
                                                });
                                              }),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Ir a recuperación de contraseña
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginRecuperacionPage(
                                                        themeManager:
                                                            widget.themeManager,
                                                      )));
                                        },
                                        child: const Text(
                                          '¿Olvido la contraseña?',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // Función de login
                                        logIn();
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(height: 40)
                              ],
                            ),
                          ),
                          // Vista para el registro
                          Register(
                            themeManager: widget.themeManager,
                          )
                        ],
                      ),
                    ),
                  ],
                )));
      }
    });
  }
}

//Clase del registro
class Register extends StatefulWidget {
  final ThemeManager themeManager;
  const Register({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controlador de página para gestionar las vistas del formulario de registro
  PageController? controller; // controlador

  // Índice actual en la lista de vistas
  int currentIndex = 0; //inicializacion de la lista

  // Porcentaje para el círculo de progreso de las vistas
  double porcentaje = 0.20; //porcentaje del circulo de progreso de las vistas

  // Lista de vistas
  List<Vistas> listaVistas = <Vistas>[];

  // Variable para el color del círculo de progreso de las vistas
  late bool validacionColor =
      true; //variable del color del circulo de progreso de las vistas

  //funcion void de las vistas que estan en la lista
  @override
  void initState() {
    // Inicialización del controlador de página con la primera página
    controller = PageController(initialPage: 0);
    super.initState();
    // Llamada a la función para configurar las vistas del registro
    _vistasregister();
  }

  // Controladores de texto para manejar la entrada de datos del usuario
  TextEditingController _nombreCompletoController = TextEditingController();
  TextEditingController _tipoDocumentoController = TextEditingController();
  TextEditingController _numeroDocumentoController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _idiomaController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _tipoBancoController = TextEditingController();
  TextEditingController _cuentaBancariaController = TextEditingController();
  TextEditingController _numeroDaviplataController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _imagenController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenhaController = TextEditingController();
  TextEditingController _confirmacionContasenhaController =
      TextEditingController();

  //Esta variable es para la validacion de los formularios
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Máscaras para establecer la cantidad de numeros que van en el textfield del numero de la  tajeta
  var cardMask = MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r'[0-9]')});

  var documento = MaskTextInputFormatter(
      mask: "# ### ### ###", filter: {"#": RegExp(r'[0-9]')});

  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  // Función para realizar el registro del usuario
  Future signIn() async {
    try {
      // Verificar que las contraseñas coincidan
      if (passwordConfirmed()) {
        // Crear un usuario en Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _contrasenhaController.text.trim(),
        );

        // Agregar los detalles del usuario a la base de datos
        final respuesta = await addUserDetails(
          _nombreCompletoController.text.trim(),
          _tipoDocumentoController.text.trim(),
          _numeroDocumentoController.text.trim(),
          _emailController.text.trim(),
          _telefonoController.text.trim(),
          _celularController.text.trim(),
          _idiomaController.text.trim(),
          _imagenController.text.trim(),
          _descripcionController.text.trim(),
          _tipoBancoController.text.trim(),
          _cuentaBancariaController.text.trim(),
          _numeroDaviplataController.text.trim(),
        );

        // Si el usuario se crea y se agregan los detalles correctamente, navegar a la pantalla de inicio
        if (userCredential.user != null && respuesta == 201) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreenPage(
                    themeManager: widget.themeManager,
                  )));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Función para agregar los detalles del usuario a la base de datos
  Future<int> addUserDetails(
    String nombreCompleto,
    String tipoDocumento,
    String numeroDocumento,
    String email,
    String telefono,
    String celular,
    String idioma,
    String imagen,
    String descripcion,
    String banco,
    String numCuenta,
    String daviplata,
  ) async {
    // Construir la URL de la API
    String url = "";

    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Usuarios/";
    } else {
      url = "http://127.0.0.1:8000/api/Usuarios/";
    }

    // Configurar los encabezados de la solicitud
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Configurar los datos del cuerpo de la solicitud
    final Map<String, dynamic> dataBody = {
      "nombreCompleto": nombreCompleto,
      "tipoDocumento": tipoDocumento,
      "numeroDocumento": numeroDocumento,
      "correoElectronico": email,
      "telefono": telefono,
      "telefonoCelular": celular,
      "idioma": idioma,
      "foto": imagen,
      "rolAdmin": false,
      "descripcion": descripcion,
      "banco": banco,
      "numeroCuenta": numCuenta,
      "daviplata": daviplata,
      "fechaRegistro":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
    };

    int resultado = 0;

    try {
      // Enviar la solicitud POST a la API
      final response = await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el resultado con el código de estado de la respuesta
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      print(e);
    }

    return resultado;
  }

  // Función para verificar que las contraseñas coincidan
  bool passwordConfirmed() {
    if (_contrasenhaController.text.trim() ==
        _confirmacionContasenhaController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  // Liberar recursos al destruir el widget
  @override
  void dispose() {
    // Liberar los controladores de texto y el controlador de página
    _nombreCompletoController.dispose();
    _tipoDocumentoController.dispose();
    _numeroDocumentoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _celularController.dispose();
    _idiomaController.dispose();
    _imagenController.dispose();
    _descripcionController.dispose();
    _tipoBancoController.dispose();
    _cuentaBancariaController.dispose();
    _numeroDaviplataController.dispose();
    _contrasenhaController.dispose();
    _confirmacionContasenhaController.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 6, //tamaño de la vista
        child: PageView.builder(
            controller: controller,
            itemCount: listaVistas.length, //recorre la longitud de la lista
            onPageChanged: (int index) {
              //condicional para el aumento del porcentaje del progreso en el circulo
              if (index >= currentIndex) {
                setState(() {
                  currentIndex = index;
                  porcentaje += 0.20;
                });
              } else {
                setState(() {
                  currentIndex = index;
                  porcentaje -= 0.20;
                });
              }
            },
            itemBuilder: (context, index) {
              return Container(
                child: listaVistas[index].vista1, //Llmado de las vistas
              );
            }),
      ),
      //Aqui va el boton
      Expanded(
          flex: 1,
          child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: CircularProgressIndicator(
                      value: porcentaje,
                      backgroundColor: Colors.grey,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(porcentaje <= 0.20
                              ? Colors.yellow
                              : porcentaje <= 0.60
                                  ? Colors.lightGreen
                                  : porcentaje > 0.60
                                      ? Colors.green
                                      : Colors.white),
                      //Aqui evalua el color del boton dependiendo el porcentaje
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor:
                        validacionColor ? Colors.white : Colors.green,
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  //condicional que evalua los textfield si esta correcto puede avanzar a la siguiente pagina
                  if (currentIndex == listaVistas.length - 1) {
                    //condiiconal de las vistas
                    validacionColor; //color
                    if (porcentaje == 1) {
                      //condicional que cuando llegue a 1 podra avanzar a la función de registro
                      signIn();
                    }
                  }
                  //animacion al pasar la pagina
                  controller!.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              }))
    ]);
  }

  //Lista dentro de la funcion void
  void _vistasregister() {
    var lista = <Vistas>[
      //Primera vista
      Vistas(
        vista1: Form(
            key: formKey, //Variable para la validacion del formulario
            //Lo hice en una clase diferente
            child: Row(
              children: [
                Expanded(
                  child: Prueba2(
                      //Paso de parametros
                      nombreCompleto: _nombreCompletoController,
                      tipoDocumento: _tipoDocumentoController,
                      numeroDocumento: _numeroDocumentoController),
                ),
              ],
            )),
      ),
      //segunda vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Prueba(
                descripcion: _descripcionController,
                telefono: _telefonoController,
                idioma: _idiomaController,
              ),
            )
          ],
        ),
      )),
      //Tercera vista
      Vistas(
        vista1: Form(
            key: formKey,
            child: Expanded(
              child: Prueba3(
                  tipoBanco: _tipoBancoController,
                  cuentaBancaria: _cuentaBancariaController,
                  numeroDaviplata: _numeroDaviplataController),
            )),
      ),
      //Cuarta vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Expanded(
          child: Prueba5(
              celularController: _celularController,
              imagenController: _imagenController),
        ),
      )),
      //Quinta Vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Expanded(
            child: Prueba4(
                email: _emailController,
                contrasenha: _contrasenhaController,
                confirmacionContasenha: _confirmacionContasenhaController)),
      )),
    ];
    setState(() {
      listaVistas = lista;
    });
  }
}

// Clase para representar las vistas en el formulario de registro
class Vistas {
  Widget vista1;

  Vistas({required this.vista1});
}
