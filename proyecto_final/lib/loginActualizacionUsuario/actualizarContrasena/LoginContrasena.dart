// ignore_for_file: file_names, no_logic_in_create_state, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:proyecto_final/loginActualizacionUsuario/actualizarContrasena/ClasesContrasena.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class LoginContrasenaPage extends StatefulWidget {
  // propiedad obligatoria la cual recibe la nueva contraseña
  final String? contrasena;

  final ThemeManager themeManager;

  const LoginContrasenaPage(
      {Key? key, required this.themeManager, required this.contrasena})
      : super(key: key);

  @override
  State<LoginContrasenaPage> createState() =>
      _LoginContrasenaPageState(themeManager);
}

class _LoginContrasenaPageState extends State<LoginContrasenaPage>
    with SingleTickerProviderStateMixin {
  final ThemeManager themeManager;

  late int index;

  late bool imagen = true;

  @override
  void dispose() {
    super.dispose();
  }

  _LoginContrasenaPageState(this.themeManager);

  @override
  Widget build(BuildContext context) {
    //Widget que almacena las diferentes vistas del responsive
    return LayoutBuilder(builder: (context, responsive) {
      //primera vista del responsive
      // Valida que el ancho de la pantalla sea igual a 375
      if (responsive.maxWidth == 375) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Color(0x73606060),
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen6.jpg' : '../images/imagen7.jpg',
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir al formulario para actualizar contraseña
                  child: LoginContrasena(
                    themeManager: widget.themeManager,
                    contrasena: widget.contrasena,
                  ),
                )));
        // Valida que el ancho de la pantalla sea igual o menor a 300
      } else if (responsive.maxWidth <= 300) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir al formulario para actualizar contraseña
                  child: LoginContrasena(
                    themeManager: widget.themeManager,
                    contrasena: widget.contrasena,
                  ),
                )));
        // Valida que el ancho de la pantalla sea igual o menor a 500
      } else if (responsive.maxWidth <= 500) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir al formulario para actualizar contraseña
                  child: LoginContrasena(
                    themeManager: widget.themeManager,
                    contrasena: widget.contrasena,
                  ),
                )));
        // Valida que el ancho de la pantalla sea igual o mayor a 1000
      } else if (responsive.maxWidth >= 1000) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen8.jpg' : '../images/imagen7.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir al formulario para actualizar contraseña
                  child: LoginContrasena(
                    themeManager: widget.themeManager,
                    contrasena: widget.contrasena,
                  ),
                )));
        // Vista por defecto
      } else {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir al formulario para actualizar contraseña
                  child: LoginContrasena(
                    themeManager: widget.themeManager,
                    contrasena: widget.contrasena,
                  ),
                )));
      }
    });
  }
}
