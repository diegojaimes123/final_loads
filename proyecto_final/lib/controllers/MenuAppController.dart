// ignore_for_file: file_names

import 'package:flutter/material.dart';

// Clase que controla la animación del drawer en los dashboards

class MenuAppController extends ChangeNotifier {
  // Llave global para acceder al estado del Scaffold (estructura del material)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Obtener la llave del Scaffold para su uso externo
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // Método para controlar la apertura del menú (drawer)
  void controlMenu() {
    // Verificar si el drawer no está abierto y abrirlo
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
