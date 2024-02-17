// ignore_for_file: file_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import '../HomePage/home_screens.dart';
import '../theme/theme_manager.dart';

class AuthenticationScreen extends StatefulWidget {
  final ThemeManager themeManager;
  final String email;
  final String contrasena;

  const AuthenticationScreen({
    super.key,
    required this.themeManager,
    required this.email,
    required this.contrasena,
  });

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  // Método para realizar la autenticación y navegar a la pantalla principal
  Future logInV2() async {
    try {
      // Intentar iniciar sesión utilizando Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.contrasena,
      );

      // Verificar si la autenticación fue exitosa
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreenPage(
                  themeManager: widget.themeManager,
                )));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2500),
            elevation: 10,
            backgroundColor: primaryColor,
            content: Text(
              'Ingresaste con escaner biometrico y credenciales.....',
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
      // ignore: use_build_context_synchronously
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreenPage(
                                  themeManager: widget.themeManager,
                                )));
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
        ),
      );

      if (isAuthenticated) {
        // Biometría exitosa, mostrar modal y luego cargar otra ventana.
        // ignore: use_build_context_synchronously
        logInV2();
      } else {
        print('Error en la autenticación o el usuario canceló');
      }
    } catch (e) {
      print('Error durante la autenticación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación Biométrica '),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticate(context),
          child: const Text('Autenticar huella'),
        ),
      ),
    );
  }
}
