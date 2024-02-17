// ignore_for_file: no_logic_in_create_state, file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/LoginUsuario/Login/Clases.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// La clase de la página de inicio de sesión.
class LoginPage extends StatefulWidget {
  final ThemeManager themeManager;

  const LoginPage({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState(themeManager);
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final ThemeManager themeManager;

  late TabController tabController;

  late int index;

  late bool imagen = true;

  // Inicialización del controlador de pestañas.
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        index = tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  _LoginPageState(this.themeManager);

  @override
  Widget build(BuildContext context) {
    // Widget que almacena las diferentes vistas del diseño responsivo.
    return LayoutBuilder(builder: (context, responsive) {
      // Verificar si el ancho de la pantalla es igual a 375
      if (responsive.maxWidth == 375) {
        // Condicional para seleccionar la imagen según la pestaña activa.
        if (tabController.index == 1) {
          imagen = true;
        } else {
          imagen = false;
        }
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
                  //ir al formulario del login
                  child: Login(
                    tabController: tabController,
                    themeManager: widget.themeManager,
                  ),
                )));
      // Verificar si el ancho de la pantalla es igual o menor a 300
      } else if (responsive.maxWidth <= 300) {
        // Condicional para seleccionar la imagen según la pestaña activa.
        if (tabController.index == 1) {
          imagen = true;
        } else {
          imagen = false;
        }
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
                  //ir al formulario del login
                  child: Login(
                    tabController: tabController,
                    themeManager: widget.themeManager,
                  ),
                )));
                // Verificar si el ancho de la pantalla es igual o menor a 500
      } else if (responsive.maxWidth <= 500) {
        // Condicional para seleccionar la imagen según la pestaña activa.
        if (tabController.index == 1) {
          imagen = true;
        } else {
          imagen = false;
        }
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
                  //ir al formulario del login
                  child: Login(
                    tabController: tabController,
                    themeManager: widget.themeManager,
                  ),
                )));
                // Verificar si el ancho de la pantalla es igual o mayor a 1000
      } else if (responsive.maxWidth >= 1000) {
        // Condicional para seleccionar la imagen según la pestaña activa.
        if (tabController.index == 1) {
          imagen = true;
        } else {
          imagen = false;
        }
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
                  //ir al formulario del login
                  child: Login(
                    tabController: tabController,
                    themeManager: widget.themeManager,
                  ),
                )));
                // Vista por defecto
      } else {
        // Condicional para seleccionar la imagen según la pestaña activa.
        if (tabController.index == 1) {
          imagen = true;
        } else {
          imagen = false;
        }
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
                  //ir al formulario del login
                  child: Login(
                    tabController: tabController,
                    themeManager: widget.themeManager,
                  ),
                )));
      }
    });
  }
}
