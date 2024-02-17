// ignore_for_file: no_logic_in_create_state, file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/loginRecuperacion/clasesRecuperacion.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class LoginRecuperacionPage extends StatefulWidget {
  final ThemeManager themeManager;

  const LoginRecuperacionPage({Key? key, required this.themeManager})
      : super(key: key);

  @override
  State<LoginRecuperacionPage> createState() =>
      _LoginRecuperacionPageState(themeManager);
}

class _LoginRecuperacionPageState extends State<LoginRecuperacionPage>
    with SingleTickerProviderStateMixin {
  final ThemeManager themeManager;

  late int index;

  late bool imagen = true;

  _LoginRecuperacionPageState(this.themeManager);

  @override
  Widget build(BuildContext context) {
    //Widget que almacena las diferentes vistas del responsive
    return LayoutBuilder(builder: (context, responsive) {
      //primera vista del responsive
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
                  child: LoginRecuperacion(
                    themeManager: widget.themeManager,
                  ),
                )));
      } else if (responsive.maxWidth <= 300) {
        // Segunda vista del responsive
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
                  child: LoginRecuperacion(
                    themeManager: widget.themeManager,
                  ),
                )));
      } else if (responsive.maxWidth <= 500) {
        // Tercera vista del responsive
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
                  child: LoginRecuperacion(
                    themeManager: widget.themeManager,
                  ),
                )));
      } else if (responsive.maxWidth >= 1000) {
        // Cuarta vista del responsive
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
                  child: LoginRecuperacion(
                    themeManager: widget.themeManager,
                  ),
                )));
      } else {
        // Vista por defecto
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
                  child: LoginRecuperacion(
                    themeManager: widget.themeManager,
                  ),
                )));
      }
    });
  }
}
