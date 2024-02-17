// ignore_for_file: file_names

import "package:alan_voice/alan_voice.dart";
import "package:flutter/material.dart";
import "package:proyecto_final/categories/screens/categoryCard.dart";
import "package:proyecto_final/categories/screens/headerCategory.dart";
import "package:proyecto_final/categoryForm/formulario_categoria.dart";
import "package:proyecto_final/chatbotweb/chatBotWeb.dart";
import "package:proyecto_final/models/CategoriaModel.dart";
import "package:proyecto_final/theme/theme_constants.dart";
import "package:universal_platform/universal_platform.dart";
import 'package:proyecto_final/theme/theme_manager.dart';

// Vista que contendra todos los componentes los cuales conformaran la vista de categorías.

class CategoryPage extends StatefulWidget {
  final ThemeManager themeManager;
  const CategoryPage({super.key, required this.themeManager});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Constructor para la clase de estado
  _CategoryPageState() {
    // Inicializar el botón de Alan Voice si no está en la plataforma web
    if (!UniversalPlatform.isWeb) {
      /// Init Alan Button with project key from Alan AI Studio
      AlanVoice.addButton(
          "257726fb1e303ccaf96867d4b3de54d42e956eca572e1d8b807a3e2338fdd0dc/stage",
          buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

      /// Handle commands from Alan AI Studio
      // Manejar comandos desde Alan AI Studio
      AlanVoice.onCommand.add((command) {
        debugPrint("got new command ${command.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            const HeaderCategory(),
            const SizedBox(height: defaultPadding),
            Text(
              "Categorías",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 40),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de CategoriaForm cuando se presiona el botón
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoriaForm(
                      themeManager: widget.themeManager,
                    ),
                  ),
                );
              },
              child: const Text("Añadir Categoría"),
            ),
            const SizedBox(height: defaultPadding),
            Column(
              children: [
                // FutureBuilder para obtener y mostrar asincrónicamente la lista de categorías
                FutureBuilder(
                    future: getCategoria(),
                    builder: (context,
                        AsyncSnapshot<List<CategoriaModel>> categoriaList) {
                      // Mientras carga la información
                      if (categoriaList.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Si la información es nula
                      if (categoriaList.data != null) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: categoriaList.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // Mostrar la tarjeta de categoría individual para cada categoría
                              return CategoryCard(
                                categoria: categoriaList.data![index],
                                themeManager: widget.themeManager,
                              );
                            });
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
      // Mostrar el botón de acción flotante según la plataforma
      floatingActionButton: _getFloating(),
    );
  }

  // Método para determinar el botón de acción flotante apropiado según la plataforma
  _getFloating() {
    if (UniversalPlatform.isWeb) {
      return FloatingActionButton(
        onPressed: () {
          // Navegar a la página de ChatBotWeb cuando se presiona el botón
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
          // Navegar a la página de ChatBotWeb cuando se presiona el botón
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
