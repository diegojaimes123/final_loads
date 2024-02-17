// ignore_for_file: no_logic_in_create_state, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/FormularioSitio/forms_provider.dart';
import 'package:proyecto_final/models/CategoriaModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'habitaciones/form_habitaciones.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

//Pagina 1

// ignore: must_be_immutable
class PantallaPageOne extends StatefulWidget {
  // Controladores de texto
  TextEditingController categoriaController = TextEditingController();
  TextEditingController titulo = TextEditingController();
  TextEditingController numeroHuespedes = TextEditingController();
  TextEditingController numeroCamas = TextEditingController();
  TextEditingController numeroBanhos = TextEditingController();
  TextEditingController descripcionSitio = TextEditingController();
  PantallaPageOne(
      {super.key,
      required this.categoriaController,
      required this.titulo,
      required this.numeroHuespedes,
      required this.numeroCamas,
      required this.numeroBanhos,
      required this.descripcionSitio});

  @override
  State<PantallaPageOne> createState() => _PantallaPageOneState(
      categoriaController: categoriaController,
      titulo: titulo,
      numeroHuespedes: numeroHuespedes,
      numeroCamas: numeroCamas,
      numeroBanhos: numeroBanhos,
      descripcionSitio: descripcionSitio);
}

class _PantallaPageOneState extends State<PantallaPageOne> {
  // variable para recibir la categoria seleccionada en el desplegable
  String? seleccionaCategoria;

  // Controladores de texto
  TextEditingController categoriaController = TextEditingController();
  TextEditingController titulo = TextEditingController();
  TextEditingController numeroHuespedes = TextEditingController();
  TextEditingController numeroCamas = TextEditingController();
  TextEditingController numeroBanhos = TextEditingController();
  TextEditingController descripcionSitio = TextEditingController();

  _PantallaPageOneState(
      {required this.categoriaController,
      required this.titulo,
      required this.numeroHuespedes,
      required this.numeroCamas,
      required this.numeroBanhos,
      required this.descripcionSitio});

  // Mascara para el número de huespedes
  var numeroH =
      MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      // Validar si el ancho de la pantalla es menor o igual a 699
      if (responsive.maxWidth <= 699) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agrega tu Sitio',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'CedarvilleCursive',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              // Campo categorías
              const SizedBox(height: 20),
              FutureBuilder(
                  // Obtener todas las categorías almacenadas en el servidor
                  future: getCategoria(),
                  builder: (context,
                      AsyncSnapshot<List<CategoriaModel>> categoriaList2) {
                    // Mientras se carga la información, mostrar un indicador de carga
                    if (categoriaList2.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Cuando la información está lista, construir el widget DropdownButton
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Categoria',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Crear elementos del menú desplegable a partir de la lista de categorías obtenida
                        items: categoriaList2.data!
                            .map((item) => DropdownMenuItem<String>(
                                  value: item.id.toString(),
                                  child: Text(
                                    item.nombre,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        // Valor seleccionado actualmente en el menú desplegable
                        value: seleccionaCategoria,
                        // Manejar el cambio de selección
                        onChanged: (String? value) {
                          // Actualizar el estado con la nueva selección
                          setState(() {
                            seleccionaCategoria = value;
                            categoriaController.text = seleccionaCategoria!;
                          });

                          // Realizar acciones adicionales según sea necesario cuando se selecciona un elemento
                          if (seleccionaCategoria == null ||
                              seleccionaCategoria!.isEmpty) {
                            return;
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              // Campo titulo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    controller: titulo,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Titulo del sitio',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validar el campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo número de huespedes
              const Text(
                'Numero de Huespedes',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    //fontFamily: 'CedarvilleCursive'
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    inputFormatters: [numeroH],
                    controller: numeroHuespedes,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    // Validar el campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Campo número de camas
                  Column(
                    children: [
                      const Text(
                        'Numero de Camas',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            //fontFamily: 'CedarvilleCursive'
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroCamas,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validar el campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  //Campo número de baños
                  Column(
                    children: [
                      const Text(
                        'Numero de Baños',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          //fontFamily: 'Arimo-Medium'
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroBanhos,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validar el campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Campo descripción del sitio
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    maxLines: 8,
                    controller: descripcionSitio,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Descripcion',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.text,
                    // Validar campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
        // Valida si el ancho de la pantalla es igual o mayor a 700 o es igual o menor a 999
      } else if (responsive.maxWidth >= 700 || responsive.maxWidth <= 999) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agrega tu Sitio',
                style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'CedarvilleCursive',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Campo categorías
              FutureBuilder(
                  // Utilizando FutureBuilder para manejar la obtención asíncrona de las categorías desde el servidor
                  future: getCategoria(),
                  builder: (context,
                      AsyncSnapshot<List<CategoriaModel>> categoriaList2) {
                    // Mientras se carga la información, mostrar un indicador de carga
                    if (categoriaList2.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Cuando la información está lista, construir el widget DropdownButton
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Categoria',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Crear elementos del menú desplegable a partir de la lista de categorías obtenida
                        items: categoriaList2.data!
                            .map((item) => DropdownMenuItem<String>(
                                  value: item.id.toString(),
                                  child: Text(
                                    item.nombre,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        // Valor seleccionado actualmente en el menú desplegable
                        value: seleccionaCategoria,
                        // Manejar el cambio de selección
                        onChanged: (String? value) {
                          // Actualizar el estado con la nueva selección
                          setState(() {
                            seleccionaCategoria = value;
                            categoriaController.text = seleccionaCategoria!;
                          });

                          // Realizar acciones adicionales según sea necesario cuando se selecciona un elemento
                          if (seleccionaCategoria == null ||
                              seleccionaCategoria!.isEmpty) {
                            return;
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              // Campo titulo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    controller: titulo,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Titulo del sitio',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo número de huespedes
              const Text(
                'Numero de Huespedes',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    //fontFamily: 'CedarvilleCursive'
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    inputFormatters: [numeroH],
                    controller: numeroHuespedes,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Campo número de camas
                  Column(
                    children: [
                      const Text(
                        'Numero de Camas',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            //fontFamily: 'CedarvilleCursive'
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroCamas,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  // Campo número de baños
                  Column(
                    children: [
                      const Text(
                        'Numero de Baños',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          //fontFamily: 'Arimo-Medium'
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroBanhos,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Campo descripción del sitio
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    maxLines: 8,
                    controller: descripcionSitio,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Descripcion',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.text,
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
        // Validar si el ancho de la pantalla es mayor o igual a 1000
      } else if (responsive.maxWidth >= 1000) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agrega tu Sitio',
                style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'CedarvilleCursive',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Campo categoría
              FutureBuilder(
                  // Utilizando FutureBuilder para manejar la obtención asíncrona de las categorías desde el servidor
                  future: getCategoria(),
                  builder: (context,
                      AsyncSnapshot<List<CategoriaModel>> categoriaList2) {
                    // Mientras se carga la información, mostrar un indicador de carga
                    if (categoriaList2.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Cuando la información está lista, construir el widget DropdownButton
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Categoria',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Crear elementos del menú desplegable a partir de la lista de categorías obtenida
                        items: categoriaList2.data!
                            .map((item) => DropdownMenuItem<String>(
                                  value: item.id.toString(),
                                  child: Text(
                                    item.nombre,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        // Valor seleccionado actualmente en el menú desplegable
                        value: seleccionaCategoria,
                        // Manejar el cambio de selección
                        onChanged: (String? value) {
                          // Actualizar el estado con la nueva selección
                          setState(() {
                            seleccionaCategoria = value;
                            categoriaController.text = seleccionaCategoria!;
                          });

                          // Realizar acciones adicionales según sea necesario cuando se selecciona un elemento
                          if (seleccionaCategoria == null ||
                              seleccionaCategoria!.isEmpty) {
                            return;
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              // Campo titulo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    controller: titulo,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Titulo del sitio',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo número de huespedes
              const Text(
                'Numero de Huespedes',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    //fontFamily: 'CedarvilleCursive'
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    inputFormatters: [numeroH],
                    controller: numeroHuespedes,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Campo número de camas
                  Column(
                    children: [
                      const Text(
                        'Numero de Camas',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            //fontFamily: 'CedarvilleCursive'
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroCamas,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  // Campo número de baños
                  Column(
                    children: [
                      const Text(
                        'Numero de Baños',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          //fontFamily: 'Arimo-Medium'
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            inputFormatters: [numeroH],
                            controller: numeroBanhos,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Campo descripción
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    maxLines: 8,
                    controller: descripcionSitio,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Descripcion',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.text,
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

//Pagina 2

// ignore: must_be_immutable
class PantallaPageTwo extends StatefulWidget {
  // Controladores de texto
  TextEditingController valorNoche = TextEditingController();
  TextEditingController lugar = TextEditingController();
  TextEditingController descripcionLugar = TextEditingController();
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  TextEditingController continenteController = TextEditingController();
  PantallaPageTwo(
      {super.key,
      required this.valorNoche,
      required this.lugar,
      required this.descripcionLugar,
      required this.latitud,
      required this.longitud,
      required this.continenteController});

  @override
  State<PantallaPageTwo> createState() => _PantallaPageTwoState(
      valorNoche: valorNoche,
      lugar: lugar,
      descripcionLugar: descripcionLugar,
      longitud: longitud,
      latitud: latitud,
      continenteController: continenteController);
}

class _PantallaPageTwoState extends State<PantallaPageTwo> {
  // Controladores de texto
  TextEditingController valorNoche = TextEditingController();
  TextEditingController lugar = TextEditingController();
  TextEditingController descripcionLugar = TextEditingController();
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  TextEditingController continenteController = TextEditingController();

  _PantallaPageTwoState(
      {required this.valorNoche,
      required this.lugar,
      required this.descripcionLugar,
      required this.latitud,
      required this.longitud,
      required this.continenteController});

  // mascara para el valor noche
  var valorN =
      MaskTextInputFormatter(mask: "#######", filter: {"#": RegExp(r'[0-9]')});

  // Lista de continentes para seleccionar
  final List<String> continente = [
    "AMÉRICA DEL SUR",
    "AMÉRICA DEL NORTE",
    "CENTRO AMÉRICA",
    "EUROPA",
    "ASIA",
    "ÁFRICA",
    "OCEANÍA",
  ];

  // Variable la cual recibira el continente seleccionado
  String? seleccionaContinente;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      // Validar si el ancho de la pantalla es mayor o igual a 1000
      if (responsive.maxWidth >= 1000) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Campo valor noche
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    inputFormatters: [valorN],
                    controller: valorNoche,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Valor noche',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo lugar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    controller: lugar,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Lugar',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Descripción lugar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    maxLines: 10,
                    controller: descripcionLugar,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Descripcion del lugar',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo continente
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Continente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Elementos del menú desplegable creados a partir de la lista de continentes
                  items: continente
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  // Valor seleccionado actualmente en el menú desplegable
                  value: seleccionaContinente,
                  // Manejar el cambio de selección
                  onChanged: (String? value) {
                    // Actualizar el estado con la nueva selección
                    setState(() {
                      seleccionaContinente = value;
                      continenteController.text = seleccionaContinente!;
                    });

                    // Realizar acciones adicionales según sea necesario cuando se selecciona un elemento
                    if (seleccionaContinente == null ||
                        seleccionaContinente!.isEmpty) {
                      return;
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Necesitamos la latitud y la longitud de su propiedad, ya que gestionamos un mapa que mostrará a sus futuros huéspedes la ubicación exacta. Puede encontrar estos datos en Google Maps o en su aplicación de localización preferida.',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans-SemiBold'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Campos longitud y latitud
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      /*const Text(
                    'Longitud',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),*/
                      const SizedBox(height: 5),
                      Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: longitud,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                              hintText: 'Longitud',
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      /*const Text(
                    'Latitud',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),*/
                      const SizedBox(height: 5),
                      Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: latitud,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                              hintText: 'Latitud',
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
        // Vista por defecto
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Campo valor noche
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    inputFormatters: [valorN],
                    controller: valorNoche,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Valor noche',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo lugar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    controller: lugar,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Lugar',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Campo descripción del lugar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: TextFormField(
                    maxLines: 10,
                    controller: descripcionLugar,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 13),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Descripcion del lugar',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    // Validación del campo
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo continente
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Continente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Elementos del menú desplegable creados a partir de la lista de continentes
                  items: continente
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  // Valor seleccionado actualmente en el menú desplegable
                  value: seleccionaContinente,
                  // Manejar el cambio de selección
                  onChanged: (String? value) {
                    // Actualizar el estado con la nueva selección
                    setState(() {
                      seleccionaContinente = value;
                      continenteController.text = seleccionaContinente!;
                    });

                    // Realizar acciones adicionales según sea necesario cuando se selecciona un elemento
                    if (seleccionaContinente == null ||
                        seleccionaContinente!.isEmpty) {
                      return;
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Necesitamos la latitud y la longitud de su propiedad, ya que gestionamos un mapa que mostrará a sus futuros huéspedes la ubicación exacta. Puede encontrar estos datos en Google Maps o en su aplicación de localización preferida.',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans-SemiBold'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Campos longitud y latitud
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: longitud,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                              hintText: 'Longitud',
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: TextFormField(
                            controller: latitud,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            obscureText: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                              hintText: 'Latitud',
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            // Validación del campo
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Se requiere de este campo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    });
  }
}

//Pagina 3
// ignore: must_be_immutable
class PantallaPageThree extends StatefulWidget {
  // Controladores de texto y listas necesarias
  TextEditingController valorLimpieza = TextEditingController();
  TextEditingController politica = TextEditingController();
  TextEditingController habitaciones = TextEditingController();
  List<String> tituloHabitaciones;
  List<String> descripcionHabitaciones;
  List<String> imagenes = [];
  PantallaPageThree(
      {super.key,
      required this.valorLimpieza,
      required this.politica,
      required this.habitaciones,
      required this.tituloHabitaciones,
      required this.descripcionHabitaciones,
      required this.imagenes});

  @override
  State<PantallaPageThree> createState() => _PantallaPageThreeState(
        valorLimpieza: valorLimpieza,
        politica: politica,
        habitaciones: habitaciones,
        tituloHabitaciones: tituloHabitaciones,
        descripcionHabitaciones: descripcionHabitaciones,
      );
}

class _PantallaPageThreeState extends State<PantallaPageThree> {
  // Controladores de texto y listas necesarias
  TextEditingController valorLimpieza = TextEditingController();
  TextEditingController politica = TextEditingController();
  TextEditingController habitaciones = TextEditingController();
  List<String> tituloHabitaciones;
  List<String> descripcionHabitaciones;

  _PantallaPageThreeState({
    required this.valorLimpieza,
    required this.politica,
    required this.habitaciones,
    required this.tituloHabitaciones,
    required this.descripcionHabitaciones,
  });

  // Mascaras para el valor de limpieza y la comisión
  var valorL =
      MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});

  var comisionC =
      MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});

  // Estados para los checkboxes
  bool isChecked = false;
  bool isChecked2 = false;

  // Listas y variables para manejar las imágenes
  List<String> urls = [];
  String selectSFile = '';
  Uint8List? selectedImagenInBytes;
  IconData botonG = Icons.arrow_upward;

  // Método para seleccionar una galeria de imagenes
  _selectFileS(bool imagenFrom) async {
    // pasar las imagenes una por una
    for (var e in controller.images) {
      // ignore: unnecessary_null_comparison
      if (e != null) {
        setState(() {
          selectSFile = e.name;
          selectedImagenInBytes = e.bytes;
        });
      }
      // almacenar en la lista la url de cada una
      urls.add(await _uploadFileS());
      print(selectSFile);
    }
    print(urls);
    // almacenar el la lista controlador todas las urls de las imagenes
    setState(() {
      widget.imagenes.addAll(urls);
      botonG = Icons.check;
    });
  }

  // Método para subir un archivo al servidor
  Future<String> _uploadFileS() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('site')
          .child('/$selectSFile');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putData(selectedImagenInBytes!, metadata);

      await uploadTask.whenComplete(() => null);

      // almacenar la url
      imageUrl = await ref.getDownloadURL();
      /*
      setState(() {
        _imagenController.text = imageUrl;
      });
      */
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
  }

  // controlador para almacenar la galeria de imagenes
  final controller = MultiImagePickerController(
    maxImages: 50,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  // limpiar recursos
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // controlador de las habitaciones
    List<TextEditingController> dynamicControllers =
        context.watch<FormsProvider>().controller;
    return LayoutBuilder(builder: (context, responsive) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Campo valor limpieza
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      inputFormatters: [valorL],
                      controller: valorLimpieza,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        hintText: 'Valor limpieza',
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      // Validación del campo
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Al hacer clic en el campo de habitaciones, aparecerá un botón. Utilícelo para agregar el título y una descripción sobre la habitación que está por añadir.',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Checkbox habitaciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Habitaciones',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Checkbox(
                      activeColor: const Color(0xFFAD974F),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                        habitaciones.text = isChecked.toString();
                      },
                    ),
                    if (isChecked == true)
                      GestureDetector(
                        onTap: () {
                          // modal para agregar habitaciones
                          showDialogFunc(context, dynamicControllers);
                        },
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFAD974F),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Center(
                            child: Text(
                              'Agregar',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  //fontFamily: 'CedarvilleCursive'
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Checkbox politicas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aceptar términos y condiciones',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Checkbox(
                      activeColor: const Color(0xFFAD974F),
                      value: isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked2 = value ?? false;
                        });
                        politica.text = isChecked2.toString();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text(
                  'Para acceder a nuestros términos y condiciones, por favor, haz clic en el siguiente botón',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                GestureDetector(
                  onTap: () async {
                    // Direccionar al documento online donde se encuentran las politicas de StayAway
                    String url =
                        "https://stayawaypagos.000webhostapp.com/terminos.pdf";
                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          8.0), // Puedes ajustar el valor según tus preferencias
                    ),
                    child: const Text(
                      "Términos y Condiciones",
                      style: TextStyle(
                          fontSize: 15,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JosefinSans-SemiBold'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Botón para añadir la galeria de imagenes
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MultiImagePickerView(
                    addButtonTitle: "Añadir Imagenes",
                    addMoreButtonTitle: "Añadir Más",
                    onDragBoxDecoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.45),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    controller: controller,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.black38,
                    child: IconButton(
                      icon: Icon(
                        botonG,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Función para seleccionar las imagenes y guardarlas en el servidor
                        setState(() {
                          botonG = Icons.watch;
                        });
                        _selectFileS(true);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Después de seleccionar sus imágenes, haga clic en el icono de "subir" para guardarlas en nuestro servidor. Este proceso puede demorar dependiendo de la cantidad de imágenes que esté subiendo.',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ));
    });
  }

  // Modal para añadir las habitaciones
  showDialogFunc(context, List dynamicControllers) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 450,
                  width: 400,
                  child: Column(
                    children: [
                      // comunicación con el formulario para añadir las habitaciones
                      Expanded(
                        child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider<FormsProvider>(
                                create: (_) => FormsProvider())
                          ],
                          builder: (context, _) => Example(
                            tituloHabitaciones: tituloHabitaciones,
                            descripcionHabitaciones: descripcionHabitaciones,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

//Pagina 4

// ignore: must_be_immutable
class PantallaPageFour extends StatefulWidget {
  // Controladores de texto
  TextEditingController reglas = TextEditingController();
  TextEditingController seguridad = TextEditingController();
  PantallaPageFour({super.key, required this.reglas, required this.seguridad});

  @override
  State<PantallaPageFour> createState() =>
      _PantallaPageFourState(reglas: reglas, seguridad: seguridad);
}

class _PantallaPageFourState extends State<PantallaPageFour> {
  // Controladores de texto
  TextEditingController reglas = TextEditingController();
  TextEditingController seguridad = TextEditingController();

  _PantallaPageFourState({required this.reglas, required this.seguridad});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Reglas del sitio',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'JosefinSans-SemiBold'),
          ),
          const SizedBox(height: 20),
          // Campo reglas
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: TextFormField(
                controller: reglas,
                maxLines: 10,
                obscureText: false,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Reglas',
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.text,
                // Validación del campo
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Se requiere de este campo';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Seguridad del sitio',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'JosefinSans-SemiBold'),
          ),
          const SizedBox(height: 20),
          // Campo medidad de seguridad
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: TextFormField(
                controller: seguridad,
                maxLines: 10,
                obscureText: false,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Seguridad',
                  //fillColor: Colors.grey[200],
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.text,
                // Validación del campo
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Se requiere de este campo';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
