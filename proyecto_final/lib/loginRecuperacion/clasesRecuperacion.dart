// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// ignore: must_be_immutable
class LoginRecuperacion extends StatefulWidget {
  final ThemeManager themeManager;
  const LoginRecuperacion({Key? key, required this.themeManager})
      : super(key: key);

  @override
  State<LoginRecuperacion> createState() => _LoginRecuperacionState();
}

class _LoginRecuperacionState extends State<LoginRecuperacion>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();

  // Función para enviar un correo electrónico de recuperación de contraseña
  Future passwordReset() async {
    var cuentaEmail = _emailController.text.trim();

    try {
      // Envía un correo electrónico de recuperación de contraseña
      await FirebaseAuth.instance.sendPasswordResetEmail(email: cuentaEmail);
      // Muestra un diálogo informativo si el envío es exitoso
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Recuperación de Contraseña'),
              content: Text('Un email fue envíado a la cuenta $cuentaEmail'),
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
    } on FirebaseAuthException catch (e) {
      // Maneja excepciones de Firebase Authentication
      print(e);
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('StayAway'),
              content: Text('email error: $e'),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      // Verifica el tamaño de la pantalla para ajustar el diseño
      // Verifica si el ancho de la pantalla es igual a 375
      if (responsive.maxWidth == 375) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
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
                                    'Recuperación de Contraseña',
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
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 25, right: 30),
                                    child: Text(
                                      'Ingrese su email para el restablecimiento de contraseña',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white
                                          //fontFamily: 'DelaGothicOne'
                                          ),
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                // Función para recuperar la contraseña
                                passwordReset();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Restablecer Contraseña',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
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
                    ),
                  ],
                )));
        // Verifica si el ancho de la pantalla es igual o menor a 300
      } else if (responsive.maxWidth <= 300) {
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
                    Expanded(
                      child: SingleChildScrollView(
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
                                    'Recuperación de Contraseña',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 25, right: 30),
                                    child: Text(
                                      'Ingrese su email para el restablecimiento de contraseña',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white
                                          //fontFamily: 'DelaGothicOne'
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    style: const TextStyle(color: Colors.black),
                                    controller: _emailController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelStyle: const TextStyle(
                                          fontSize: 13, color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: 'Email',
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      fillColor: Colors.grey[200],
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                // Función para recuperar la contraseña
                                passwordReset();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(13.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Restablecer Contraseña',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 40)
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
        // Verifica si el ancho de la pantalla es igual o menor a 500
      } else if (responsive.maxWidth <= 500) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
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
                                    'Recuperación de Contraseña',
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
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 25, right: 30),
                                    child: Text(
                                      'Ingrese su email para el restablecimiento de contraseña',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white
                                          //fontFamily: 'DelaGothicOne'
                                          ),
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Función para recuperar la contraseña
                                    passwordReset();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Restablecer Contraseña',
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
                    ),
                  ],
                )));
        // Verifica si el ancho de la pantalla es igual o mayor a 1000
      } else if (responsive.maxWidth >= 1000) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 30.0),
            child: Row(
              children: [
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
                            Expanded(
                              flex: 6,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 50),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Text(
                                            'Recuperación de Contraseña',
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
                                        SizedBox(
                                          height: defaultPadding,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 25, right: 30),
                                            child: Text(
                                              'Ingrese su email para el restablecimiento de contraseña',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white
                                                  //fontFamily: 'DelaGothicOne'
                                                  ),
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
                                          border:
                                              Border.all(color: Colors.white),
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
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: InkWell(
                                        onTap: () {
                                          // Función para recuperar la contraseña
                                          passwordReset();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Restablecer Contraseña',
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
                            ),
                          ],
                        )))
              ],
            ));
        // ancho de la pantalla por defecto
      } else {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
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
                                    'Recuperación de Contraseña',
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
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 25, right: 30),
                                    child: Text(
                                      'Ingrese su email para el restablecimiento de contraseña',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white
                                          //fontFamily: 'DelaGothicOne'
                                          ),
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Función para recuperar la contraseña
                                    passwordReset();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Restablecer Contraseña',
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
                    ),
                  ],
                )));
      }
    });
  }
}
