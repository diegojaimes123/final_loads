// ignore_for_file: no_logic_in_create_state

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chatbotweb/chatBotWeb.dart';
import 'package:proyecto_final/controllers/MenuAppController.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/dashboard_screen.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'components/side_menu.dart';

// División por partes de los elementos principales del dashboard

class MainScreenTodo extends StatefulWidget {
  final ThemeManager themeManager;

  const MainScreenTodo({super.key, required this.themeManager});

  @override
  State<MainScreenTodo> createState() =>
      _MainScreenTodoState(themeManager: themeManager);
}

class _MainScreenTodoState extends State<MainScreenTodo> {
  final ThemeManager themeManager;

  _MainScreenTodoState({required this.themeManager}) {
    // Inicialización de Alan Button solo si la plataforma no es web
    if (!UniversalPlatform.isWeb) {
      /// Init Alan Button with project key from Alan AI Studio
      /// Inicializar el botón de Alan AI Studio
      AlanVoice.addButton(
          "257726fb1e303ccaf96867d4b3de54d42e956eca572e1d8b807a3e2338fdd0dc/stage",
          buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

      /// Handle commands from Alan AI Studio
      /// Manejo de comandos desde Alan AI Studio
      AlanVoice.onCommand.add((command) {
        debugPrint("got new command ${command.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // en el caso que el ancho de pantalla no sea escritorio habra un controller para que el drawer sea desplegable
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        themeManager: themeManager,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            // en caso que sea escritorio el drawer aparece estatico en la pantalla
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(
                  themeManager: themeManager,
                ),
              ),
            // Dasboard
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(
                themeManager: themeManager,
              ),
            ),
          ],
        ),
      ),
      // botón flotante para el chatbot escrito en caso que se este usando el aplicativo en entorno web
      floatingActionButton: _getFloating(),
    );
  }

  // Método privado que devuelve el botón flotante según la plataforma
  _getFloating() {
    if (UniversalPlatform.isWeb) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotWeb()),
          );
        },
        child: const Icon(Icons.support_agent),
      );
    } else if (UniversalPlatform.isWindows) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotWeb()),
          );
        },
        child: const Icon(Icons.support_agent),
      );
    } else {
      return null; // Retorna null si la plataforma no es web ni Windows
    }
  }
}
