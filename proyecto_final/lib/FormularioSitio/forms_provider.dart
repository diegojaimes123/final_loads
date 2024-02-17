// ignore_for_file: unnecessary_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Clase que gestiona controladores para formularios y notifica cambios a los widgets que escuchan.
class FormsProvider with ChangeNotifier {
  FormsProvider() {
    createControllers();
    createControllers2();
  }

  // Lista de controladores para el primer conjunto de campos de texto.
  final List<TextEditingController> _controllers = <TextEditingController>[];

  // Getter para acceder a los controladores del primer conjunto.
  List<TextEditingController> get controller => _controllers;

  // Método para crear un nuevo controlador y notificar a los oyentes.
  Future<void> createControllers() async {
    _controllers.add(TextEditingController());
    notifyListeners();
  }

// Método para eliminar un controlador en un índice específico y notificar a los oyentes.
  Future<void> deleteControllers({required int index}) async {
    if (index < _controllers.length) {
      _controllers.removeAt(index);
      notifyListeners();
    }
  }

  // Descripción

  // Lista de controladores para el segundo conjunto de campos de texto.
  final List<TextEditingController> _controllers2 = <TextEditingController>[];

  // Getter para acceder a los controladores del segundo conjunto.
  List<TextEditingController> get controller2 => _controllers2;

  // Método para crear un nuevo controlador del segundo conjunto y notificar a los oyentes.
  Future<void> createControllers2() async {
    _controllers2.add(TextEditingController());
    notifyListeners();
  }

  // Método para eliminar un controlador del segundo conjunto en un índice específico y notificar a los oyentes.
  Future<void> deleteControllers2({required int index}) async {
    if (index < _controllers2.length) {
      _controllers2.removeAt(index);
      notifyListeners();
    }
  }
}
