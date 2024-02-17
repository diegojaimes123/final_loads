// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/loginRecuperacion/LoginRecuperacion.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// ignore: must_be_immutable
class LoginContrasena extends StatefulWidget {
  // parametro el cual recibe la nueva contraseña
  final String? contrasena;
  final ThemeManager themeManager;
  const LoginContrasena(
      {Key? key, required this.themeManager, required this.contrasena})
      : super(key: key);

  @override
  State<LoginContrasena> createState() => _LoginContrasenaState();
}

class _LoginContrasenaState extends State<LoginContrasena>
    with SingleTickerProviderStateMixin {
  // Variable para controlar si la contraseña está oculta o no.
  bool _isObscure = true;

  // Controladores para los campos de correo electrónico y contraseña.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Función asincrónica para realizar el inicio de sesión y cambiar la contraseña.
  Future logInContrasena() async {
    // Inicio de sesión con Firebase usando correo electrónico y contraseña.
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Actualización de la contraseña del usuario actual en Firebase.
    await FirebaseAuth.instance.currentUser?.updatePassword(widget.contrasena!);

    // Muestra un diálogo de alerta indicando que la contraseña ha sido cambiada exitosamente.
    _showAlertContrasena(context);
  }

  // Función para mostrar un diálogo de alerta después de cambiar la contraseña.
  void _showAlertContrasena(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cambio de contraseña"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("¡Su contraseña fue cambiada exitosamente!"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // Botón en el diálogo para aceptar y navegar a la pantalla de inicio.
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreenPage(themeManager: widget.themeManager)),
                  ),
                  child: const Text(
                    'Aceptar',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Método que se llama cuando se destruye el widget para liberar recursos.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      //Aqui al igual ya es responsive atravez de los condicionales
      // valida si el ancho de la pantalla es igual a 375
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
                                      // ir a recuperación de contraseña
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
                                  // cambiar contraseña
                                  logInContrasena();
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
                    ),
                  ],
                )));
        // valida si el ancho de la pantalla es igual o menor a 300
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
                                    'Login',
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    style: const TextStyle(color: Colors.black),
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
                                      // ir a recuperación de contraseña
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
                                  // cambiar contraseña
                                  logInContrasena;
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
                    ),
                  ],
                )));
        // valida si el ancho de la pantalla es igual o menor a 500
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
                                      // ir a recuperación de contraseña
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
                                    // cambiar contraseña
                                    logInContrasena();
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
        // valida si el ancho de la pantalla es igual o mayor a 1000
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // ir a recuperación de contraseña
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
                                          // cambiar contraseña
                                          logInContrasena();
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
                            ),
                          ],
                        )))
              ],
            ));
        // vista por defecto
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
                                      // ir a recuperación de contraseña
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
                                    // cambiar de contraseña
                                    logInContrasena();
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
