
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  AuthenticationScreen({super.key});

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
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Biometría Exitosa'),
            content: const Text('¡Tu huella dactilar ha sido autenticada con éxito!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextScreen()),
                  );
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
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

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Siguiente'),
      ),
      body: const Center(
        child: Text('¡Bienvenido a la siguiente pantalla!'),
      ),
    );
  }
}
