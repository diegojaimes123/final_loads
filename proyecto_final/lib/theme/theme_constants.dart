// Importaciones necesarias para Flutter y Google Fonts.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Definición de constantes con los colores predominantes que se van a usar en la aplicación.
const primaryColor = Color(0xFFCCAD5C);
const secondaryColor = Color(0xFF000000);
const bgColor = Color(0xFF0E0C13);
const defaultPadding = 16.0;

// Definición del tema claro.
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  canvasColor: secondaryColor,
  // Ignorar el uso de miembros obsoletos, ya que se ha migrado a un nuevo enfoque.
  // ignore: deprecated_member_use
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  // Definición del tema para el cajón de navegación.
  // ignore: use_full_hex_values_for_flutter_colors
  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFFF2F0F2)),
  // Configuración del tema de texto utilizando Google Fonts con el color principal.
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: primaryColor),
  // Configuración del tema de botón elevado con el color principal.
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(primaryColor),
      foregroundColor: MaterialStatePropertyAll(Colors.white),
    ),
  ),
  // Configuración del tema del botón flotante de acción con colores específicos.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      // ignore: use_full_hex_values_for_flutter_colors
      backgroundColor: Color(0xFFFF2F0F2),
      foregroundColor: primaryColor),
);

// Definición del tema oscuro.
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  // Configuración del color de fondo oscuro.
  // ignore: deprecated_member_use
  backgroundColor: bgColor,
  canvasColor: secondaryColor,
  scaffoldBackgroundColor: bgColor,
  // Configuración del tema de texto utilizando Google Fonts con el color gris.
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.grey),
  // Configuración del tema de botón elevado con el color principal.
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(primaryColor),
      foregroundColor: MaterialStatePropertyAll(Colors.white),
    ),
  ),
  // Configuración del tema del botón flotante de acción con colores específicos.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor, foregroundColor: primaryColor),
);
