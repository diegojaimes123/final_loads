// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/categoryForm/formulario_categoriaedit.dart';
import 'package:proyecto_final/models/CategoriaModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

import '../../models/ip/local.dart';

// diseño de la Card la cual contendra la información de cada una de las categorías y los botones para actualizar y eliminar
class CategoryCard extends StatelessWidget {
  final ThemeManager themeManager;
  final CategoriaModel categoria;

  const CategoryCard(
      {super.key, required this.categoria, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.6),
            offset: const Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(categoria.imagen),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Información de la categoría
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                categoria.nombre,
                style: const TextStyle(fontSize: 19, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Botones de editar y eliminar
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de editar
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoriaFormEdit(
                                      categorias: categoria,
                                      themeManager: themeManager,
                                    )),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón de eliminar
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _modalBorrarCategoria(
                              context, categoria, themeManager);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Función para mostrar un diálogo de confirmación antes de eliminar una categoría
void _modalBorrarCategoria(
    BuildContext context, CategoriaModel categoria, ThemeManager themeManager) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "¿Quiere eliminar esta categoría?",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 250,
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Center(
                    child: Text(
                      "Si elimina esta categoría no hay marcha atras. ¿Esta seguro de hacer esta operación?",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                  )
                ],
              ),
            ),
          ),
          actions: [
            // Botones de confirmar o cancelar la eliminación
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                ElevatedButton(
                    onPressed: () async {
                      // Obtener referencias de almacenamiento para los archivos de la categoría
                      firabase_storage.Reference storageReferenceIcono =
                          firabase_storage.FirebaseStorage.instance
                              .refFromURL(categoria.icono);

                      firabase_storage.Reference storageReferenceImagen =
                          firabase_storage.FirebaseStorage.instance
                              .refFromURL(categoria.imagen);

                      // Eliminar los archivos de almacenamiento
                      await storageReferenceIcono.delete();
                      await storageReferenceImagen.delete();

                      // URL base para la API de categorías
                      String url = "";

                      // Determinar la URL según la plataforma
                      if (UniversalPlatform.isAndroid) {
                        url = "http://$ip_ideapat:8000/api/Categorias/";
                      } else {
                        url = "http://127.0.0.1:8000/api/Categorias/";
                      }

                      // Enviar solicitud de eliminación a la API
                      final response =
                          await http.delete(Uri.parse("$url${categoria.id}/"));

                      // Si la eliminación es exitosa, navegar a la pantalla de inicio
                      if (response.statusCode == 204) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HomeScreenPage(
                              themeManager: themeManager,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Eliminar")),
              ],
            ),
          ],
        );
      });
}
