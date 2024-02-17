import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/Splash/page/SplashScreen.dart';
import 'package:proyecto_final/firebase_options.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

void main() async {
  // Asegura que los widgets estén inicializados antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase con las opciones predeterminadas para la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ejecuta la aplicación
  runApp(const MyApp());
}

// Instancia del gestor de temas
ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Elimina el escucha del gestor de temas al desechar el widget
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    // Agrega un escucha al gestor de temas al iniciar el widget
    _themeManager.addListener(themeListener);
    super.initState();
  }

  // Método para manejar cambios en el tema
  themeListener() {
    if (mounted) {
      // Actualiza el estado solo si el widget está montado
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la aplicación MaterialApp con configuraciones específicas
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StayAway',
      theme: lightTheme, // Tema claro
      darkTheme: darkTheme, // Tema oscuro
      themeMode: _themeManager
          .themeMode, // Modo de tema gestionado por el gestor de temas
      home: SplashScreen(
          themeManager:
              _themeManager), // Página de presentación con el gestor de temas
    );
  }
}
