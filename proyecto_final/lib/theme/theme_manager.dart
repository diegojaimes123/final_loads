// Importación necesaria para Flutter.
import "package:flutter/material.dart";

// Clase `ThemeManager` que extiende `ChangeNotifier` para gestionar el modo de tema.
class ThemeManager with ChangeNotifier {
  // Variable privada que almacena el modo de tema actual.
  ThemeMode _themeMode = ThemeMode.light;

  // Getter para acceder al modo de tema actual.
  get themeMode => _themeMode;

  // Método para cambiar el modo de tema entre claro y oscuro.
  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // Notificar a los escuchadores (widgets) que el modo de tema ha cambiado.
    notifyListeners();
  }
}
